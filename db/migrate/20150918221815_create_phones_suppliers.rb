class CreatePhonesSuppliers < ActiveRecord::Migration
  def change
    create_table :phones_suppliers do |t|
      t.references :phone, null: false, index: true
      t.references :supplier, null: false, index: true
      t.timestamps null: false
    end
    add_foreign_key :phones_suppliers, :phones, name: "SUPPLIERS_PHONES_PHONES_FK"
    add_foreign_key :phones_suppliers, :suppliers, name: "SUPPLIERS_PHONES_SUPPLIERS_FK"
  end
end
