class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :invoice, null: false, index: true
      t.references :inventory, null: false, index: true
      t.integer :pieces, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :unit, limit: 15, null: false
      t.decimal :unit_price, precision: 18, scale: 2, null: false
      t.timestamps null: false
    end
    add_foreign_key :sales, :invoices, name: "SALES_INVOICES_FK"
    add_foreign_key :sales, :inventories, name: "SALES_INV_FK"
  end
end
