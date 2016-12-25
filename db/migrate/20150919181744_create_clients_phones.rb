class CreateClientsPhones < ActiveRecord::Migration
  def change
    create_table :clients_phones do |t|
      t.references :phone, null: false, index: true
      t.references :client, null: false, index: true
      t.timestamps null: false
    end
    add_foreign_key :clients_phones, :phones, name: "CLIENTS_PHONES_PHONES_FK"
    add_foreign_key :clients_phones, :clients, name: "CLIENTS_PHONES_CLIENTS_FK"
  end
end
