class CreateUpdateOnInvoiceDeleteTrigger < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION update_on_invoice_delete()
                RETURNS trigger AS
              $BODY$
                  DECLARE
                      r       sales%rowtype;
                      p       integer;
                      a       numeric(10,2);
                  BEGIN

                    FOR r IN (SELECT * FROM sales s WHERE s.invoice_id = OLD.id) LOOP
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

                    DELETE FROM sales si WHERE si.invoice_id = OLD.id;

                    RETURN OLD;
                  END;
              $BODY$
                LANGUAGE plpgsql;"
    execute "CREATE TRIGGER update_on_invoice_delete BEFORE DELETE ON invoices FOR EACH ROW EXECUTE PROCEDURE update_on_invoice_delete();"
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_on_invoice_delete ON invoices;"
    execute "DROP FUNCTION IF EXISTS update_on_invoice_delete();"
  end
end
