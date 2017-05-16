class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :supplier, null: false, index: true
      # t.references :iva, null: false, index: true
      t.decimal :vat, precision: 6, scale: 2, null: false
      t.string :purchase_number, limit: 50, null: false
      t.decimal :subtotal, precision: 18, scale: 2, null: false
      t.string :form_of_payment, limit: 155, null: false
      t.date :purchase_date, null: false
      t.string :purchase_state, limit: 20, null: false, default: 'CURRENT'
      t.timestamps null: false
    end
    add_foreign_key :purchases, :suppliers, name: "PURCHASES_SUPPLIERS_FK"
    # add_foreign_key :purchases, :ivas, name: "PURCHASES_IVAS_FK"
    add_index(:purchases, [:supplier_id, :purchase_number], unique: true, where: "purchase_state = 'CURRENT'", name: "PURCHASES_UNIQUE_NUMBER")
  end
end
