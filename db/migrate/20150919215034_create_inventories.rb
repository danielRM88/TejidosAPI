class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.references :purchase, index: true
      t.references :fabric, index: true
      t.integer :pieces, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :unit, limit: 15, null: false
      t.decimal :unit_price, precision: 18, scale: 2, null: false
      t.timestamps null: false
    end
    add_foreign_key :inventories, :purchases, name: "PUR_HAS_FAB_PURCHASES_FK"
    add_foreign_key :inventories, :fabrics, name: "PUR_HAS_FAB_FABRICS_FK"
  end
end
