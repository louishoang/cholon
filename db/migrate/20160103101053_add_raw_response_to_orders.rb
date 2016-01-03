class AddRawResponseToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :raw_response, :text
    add_column :orders, :cc_last_four, :string
    add_column :orders, :cc_type, :string
    add_column :orders, :cc_expiration_date, :string
    add_column :orders, :charged_at, :datetime
    add_column :orders, :issuing_bank, :string
  end

  def down
    remove_column :orders, :raw_response
    remove_column :orders, :cc_last_four
    remove_column :orders, :cc_type
    remove_column :orders, :cc_expiration_date
    remove_column :orders, :charged_at
    remove_column :orders, :issuing_bank
  end
end
