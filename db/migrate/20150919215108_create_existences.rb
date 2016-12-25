class CreateExistences < ActiveRecord::Migration
  def change
    create_table :existences do |t|
      t.references :inventory, null: false, index: true
      t.integer :pieces, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :unit, limit: 15, null: false
      t.timestamps null: false
    end
    add_foreign_key :existences, :inventories, name: "EX_HAVE_INVENTORIES_FK"
    add_index(:existences, [:inventory_id], unique: true, name: "EXISTENCES_UNIQUE_INV")
  end
end
