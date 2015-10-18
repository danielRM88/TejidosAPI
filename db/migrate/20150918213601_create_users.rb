class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, limit: 50, null: false
      t.string :user_lastname, limit: 50, null: false
      t.timestamps null: false
    end
  end
end
