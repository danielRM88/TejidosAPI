class CreateUpdateOnInvoiceInsertTrigger < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION update_on_invoice_insert()
                RETURNS trigger AS
              $BODY$
                  DECLARE
                      p       integer;
                      a       numeric(10,2);
                  BEGIN
                      --
                      -- Despues de un insert en invoices, se reducen las cantidades y las piezas de existences
                      --
                      p = (SELECT e.pieces FROM existences e WHERE e.inventory_id = NEW.inventory_id);
                      a = (SELECT e.amount FROM existences e WHERE e.inventory_id = NEW.inventory_id);
                      IF (TG_OP = 'INSERT') THEN
                          IF (a - NEW.amount) < 0 THEN RAISE EXCEPTION 'not enough amount in existence'; END IF;
                          IF (p - NEW.pieces) < 0 THEN RAISE EXCEPTION 'not enough pieces in existence'; END IF;
                          IF (((a - NEW.amount) = 0 AND (p - NEW.pieces) != 0) OR ((a - NEW.amount) != 0 AND (p - NEW.pieces) = 0)) THEN 
                            RAISE EXCEPTION 'inconsistency between pieces and amount (one is zero the other is not)'; 
                          END IF;
                          UPDATE existences SET 
                            amount = (a - NEW.amount),
                            pieces = (p - NEW.pieces)
                          WHERE inventory_id = NEW.inventory_id;
                          DELETE FROM existences WHERE amount = 0 AND pieces = 0;
                      END IF;
                      RETURN NULL; -- result is ignored since this is an AFTER trigger
                  END;
              $BODY$
                LANGUAGE plpgsql;"
    execute "CREATE TRIGGER update_on_invoice_insert AFTER INSERT ON sales FOR EACH ROW EXECUTE PROCEDURE update_on_invoice_insert();"
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_on_invoice_insert ON sales;"
    execute "DROP FUNCTION IF EXISTS update_on_invoice_insert();"
  end
end
