class CreateFabrics < ActiveRecord::Migration
  def change
    create_table :fabrics do |t|
      t.string :code, limit: 20, null: false
      t.string :description, limit: 255, null: false
      t.string :color, limit: 50, null: false
      t.decimal :unit_price, precision: 18, scale: 2, null: false
      t.string :fabric_state, limit: 20, null: false, default: 'CURRENT'
      t.timestamps null: false
    end
    add_index(:fabrics, [:code], unique: true, where: "fabric_state = 'CURRENT'", name: "FABRICS_UNIQUE_CODE")
  end
end
