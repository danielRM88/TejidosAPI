class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name, limit: 50, null: false
      t.string :type_id, limit: 5, null: false
      t.string :number_id, limit: 50, null: false
      t.string :address, limit: 255
      t.string :email, limit: 25
      t.string :client_state, limit: 20, null: false, default: 'CURRENT'
      t.timestamps null: false
    end
    add_index(:clients, [:type_id, :number_id], unique: true, where: "client_state = 'CURRENT'", name: "CLIENTS_UNIQUE_ID")
  end
end
