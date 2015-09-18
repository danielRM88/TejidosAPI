class CreateIvas < ActiveRecord::Migration
  def change
    create_table :ivas do |t|

      t.timestamps null: false
    end
  end
end
