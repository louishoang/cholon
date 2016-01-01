class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :abbreviation
      t.string :name

      t.timestamps null: false
    end
  end
end
