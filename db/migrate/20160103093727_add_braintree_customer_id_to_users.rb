class AddBraintreeCustomerIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :braintree_customer_id, :integer
  end

  def down
    remove_column :users, :braintree_customer_id
  end
end
