class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :business_name
      t.string :address1, null: false
      t.string :address2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :phone
      t.string :email
      t.string :type
      t.string :order_number, null: false

      t.timestamps null: false
    end
  end
end
