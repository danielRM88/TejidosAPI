class CreateUpdateOnPurchaseUpdateTrigger < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION update_on_purchase_update() RETURNS TRIGGER AS 
              $BODY$
                  DECLARE
                      r                inventories%rowtype;
                      pexistence       integer;
                      aexistence       numeric(10,2);
                      pinventory       integer;
                      ainventory       numeric(10,2);
                  BEGIN
                      --
                      -- Despues de un modificar una compra se actualiza existencia
                      -- No se puede modificar una compra sin antes remover los registros asociados en purchase_have_inventories
                      --
                      IF (NEW.purchase_state = 'CURRENT') THEN
                        FOR r IN (SELECT * FROM inventories i WHERE i.purchase_id = NEW.id) LOOP
                           INSERT INTO existences (inventory_id, pieces, amount, unit, created_at, updated_at) VALUES (r.id, r.pieces, r.amount, r.unit, current_timestamp, current_timestamp);
                        END LOOP;
                      ELSIF (NEW.purchase_state = 'CANCEL') THEN
                        pexistence = (SELECT SUM(e.pieces) FROM existences e 
                                                  INNER JOIN inventories i ON e.inventory_id = i.id
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = NEW.id));
                        aexistence = (SELECT SUM(e.amount) FROM existences e 
                                                  INNER JOIN inventories i ON e.inventory_id = i.id
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = NEW.id));

                        pinventory = (SELECT SUM(i.pieces) FROM inventories i
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = NEW.id));
                        ainventory = (SELECT SUM(i.amount) FROM inventories i
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = NEW.id));

                        IF (pinventory > pexistence OR ainventory > aexistence) THEN
                          RAISE EXCEPTION 'not enough in existence to cancel purchase (If fabrics have been sold cancel the INVOICES first OR check that the purchase has not already been cancelled)';
                        END IF;
                        FOR r IN (SELECT * FROM inventories i WHERE i.purchase_id = NEW.id) LOOP
                           DELETE FROM existences e WHERE e.inventory_id = r.id;
                        END LOOP;
                      END IF;
                  
                      RETURN OLD;
                  END;
              $BODY$ 
              LANGUAGE plpgsql;"
    execute "CREATE TRIGGER update_on_purchase_update AFTER UPDATE ON purchases FOR EACH ROW EXECUTE PROCEDURE update_on_purchase_update();"
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_on_purchase_update ON purchases;"
    execute "DROP FUNCTION IF EXISTS update_on_purchase_update();"
  end
end
