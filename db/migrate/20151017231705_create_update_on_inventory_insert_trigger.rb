class CreateUpdateOnInventoryInsertTrigger < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION update_on_inventory_insert() RETURNS TRIGGER AS 
              $BODY$
                  BEGIN
                      --
                      -- Despues de un insert en inventories, se replica la sentencia en existences
                      --
                      IF (TG_OP = 'INSERT') THEN
                          INSERT INTO existences (inventory_id, pieces, amount, unit, created_at, updated_at)
                          VALUES (NEW.id, NEW.pieces, NEW.amount, NEW.unit, current_timestamp, current_timestamp);
                      END IF;
                      RETURN NULL; -- result is ignored since this is an AFTER trigger
                  END;
              $BODY$ LANGUAGE plpgsql;"
    execute "CREATE TRIGGER update_on_inventory_insert AFTER INSERT ON inventories FOR EACH ROW EXECUTE PROCEDURE update_on_inventory_insert();"
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_on_inventory_insert ON inventories;"
    execute "DROP FUNCTION IF EXISTS update_on_inventory_insert();"
  end
end
