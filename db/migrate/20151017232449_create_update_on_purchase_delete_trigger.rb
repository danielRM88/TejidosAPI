class CreateUpdateOnPurchaseDeleteTrigger < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION update_on_purchase_delete() RETURNS TRIGGER AS 
              $BODY$
                  DECLARE
                      r                inventories%rowtype;
                      sales            integer;
                      pexistence       integer;
                      aexistence       numeric(10,2);
                      pinventory       integer;
                      ainventory       numeric(10,2);
                  BEGIN
                      sales = (SELECT COUNT(*) FROM sales si
                                               INNER JOIN inventories i ON si.inventory_id = i.id
                                               INNER JOIN purchases p ON p.id = i.purchase_id
                                               WHERE p.id = OLD.id);
                      
                      IF (sales > 0) THEN
                          RAISE EXCEPTION 'fabrics have been sold (delete inveioces first)';
                      END IF;

                      IF (OLD.purchase_state = 'CURRENT') THEN
                        pexistence = (SELECT SUM(e.pieces) FROM existences e 
                                                  INNER JOIN inventories i ON e.inventory_id = i.id
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = OLD.id));
                        aexistence = (SELECT SUM(e.amount) FROM existences e 
                                                  INNER JOIN inventories i ON e.inventory_id = i.id
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = OLD.id));

                        pinventory = (SELECT SUM(i.pieces) FROM inventories i
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = OLD.id));
                        ainventory = (SELECT SUM(i.amount) FROM inventories i
                                                  INNER JOIN purchases pu ON pu.id = i.purchase_id
                                                  WHERE (pu.id = OLD.id));

                        IF (pinventory > pexistence OR ainventory > aexistence) THEN
                          RAISE EXCEPTION 'not enough in existence to delete purchase (there may be some data inconsistency)';
                        END IF;
                      END IF;

                      FOR r IN (SELECT * FROM inventories i WHERE i.purchase_id = OLD.id) LOOP
                         DELETE FROM existences e WHERE e.inventory_id = r.id;
                      END LOOP;

                      DELETE FROM inventories i WHERE i.purchase_id = OLD.id;
                  
                      RETURN OLD;
                  END;
              $BODY$ 
              LANGUAGE plpgsql;"
    execute "CREATE TRIGGER update_on_purchase_delete BEFORE DELETE ON purchases FOR EACH ROW EXECUTE PROCEDURE update_on_purchase_delete();"
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_on_purchase_delete ON purchases;"
    execute "DROP FUNCTION IF EXISTS update_on_purchase_delete();"
  end
end
