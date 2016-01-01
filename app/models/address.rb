class Address < ActiveRecord::Base
  enum :address_type => {:shipping_adress => 0, :billing_address => 1}
  belongs_to :order

  validates_presence_of :user, :first_name, :last_name, :address1, :city,
    :state, :zip_code, :phone, :email, :type

end
