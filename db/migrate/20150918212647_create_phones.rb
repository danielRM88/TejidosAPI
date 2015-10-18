class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :country_code, limit: 5, null: false
      t.string :area_code, limit: 5, null: false
      t.string :phone_number, limit: 15, null: false
      t.timestamps null: false
    end
    add_index(:phones, [:country_code, :area_code, :phone_number], unique: true, name: "PHONES_UNIQUE_PHONE")
  end
end
