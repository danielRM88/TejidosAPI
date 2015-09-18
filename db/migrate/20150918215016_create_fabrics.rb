class CreateFabrics < ActiveRecord::Migration
  def change
    create_table :fabrics do |t|

      t.timestamps null: false
    end
  end
end
