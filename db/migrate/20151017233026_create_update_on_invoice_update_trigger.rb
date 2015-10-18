class CreateUpdateOnInvoiceUpdateTrigger < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION update_on_invoice_update()
                RETURNS trigger AS
              $BODY$
                  DECLARE
                      r       sales%rowtype;
                      p       integer;
                      a       numeric(10,2);
                  BEGIN
                    IF (NEW.invoice_state = 'CANCEL') THEN
                      FOR r IN (SELECT * FROM sales s WHERE s.invoice_id = NEW.id) LOOP
                        a = (SELECT e.amount FROM existences e WHERE e.inventory_id = r.inventory_id);
                        p = (SELECT e.pieces FROM existences e WHERE e.inventory_id = r.inventory_id);
                          IF (a > 0) THEN 
                              UPDATE existences SET 
                                  amount = (a + r.amount),
                                  pieces = (p + r.pieces)
                              WHERE inventory_id = r.inventory_id;
                          ELSE
                              INSERT INTO existences (inventory_id, pieces, amount, unit, created_at, updated_at) VALUES (r.inventory_id, r.pieces, r.amount, r.unit, current_timestamp, current_timestamp);
                          END IF;
                      END LOOP;
                    ELSIF (NEW.invoice_state = 'CURRENT') THEN
                      FOR r IN (SELECT * FROM sales s WHERE s.invoice_id = NEW.id) LOOP
                        p = (SELECT e.pieces FROM existences e WHERE e.inventory_id = r.inventory_id);
                        a = (SELECT e.amount FROM existences e WHERE e.inventory_id = r.inventory_id);
                        IF (a IS NULL OR (a - r.amount) < 0) THEN RAISE EXCEPTION 'not enough amount in existence'; END IF;
                        IF (p IS NULL OR (p - r.pieces) < 0) THEN RAISE EXCEPTION 'not enough pieces in existence'; END IF;
                        IF (((a - r.amount) = 0 AND (p - r.pieces) != 0) OR ((a - r.amount) != 0 AND (p - r.pieces) = 0)) THEN 
                          RAISE EXCEPTION 'inconsistency between pieces and amount (one is zero the other is not)';
                        END IF;
                        UPDATE existences SET 
                          amount = (a - r.amount),
                          pieces = (p - r.pieces)
                        WHERE inventory_id = r.inventory_id;
                        DELETE FROM existences WHERE amount = 0 AND pieces = 0;
                      END LOOP;
                    END IF;
                    RETURN NULL;
                  END;
              $BODY$
                LANGUAGE plpgsql;"
    execute "CREATE TRIGGER update_on_invoice_update AFTER UPDATE ON invoices FOR EACH ROW EXECUTE PROCEDURE update_on_invoice_update();"
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_on_invoice_update ON invoices;"
    execute "DROP FUNCTION IF EXISTS update_on_invoice_update();"
  end
end
