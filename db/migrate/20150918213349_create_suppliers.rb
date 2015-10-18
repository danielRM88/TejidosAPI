class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :supplier_name, limit: 155, null: false
      t.string :type_id, limit: 5, null: false
      t.string :number_id, limit: 50, null: false
      t.string :address, limit: 255
      t.string :email, limit: 25
      t.string :supplier_state, limit: 20, null: false, default: 'CURRENT'
      t.timestamps null: false
    end
    add_index(:suppliers, [:type_id, :number_id], unique: true, where: "supplier_state = 'CURRENT'", name: "SUPPLIERS_UNIQUE_ID")
  end
end
