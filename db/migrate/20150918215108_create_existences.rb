class CreateExistences < ActiveRecord::Migration
  def change
    create_table :existences do |t|

      t.timestamps null: false
    end
  end
end
