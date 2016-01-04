class Address < ActiveRecord::Base
  belongs_to :order, :foreign_key => :order_number
  validates_presence_of :first_name, :last_name, :address1, :city,
    :state, :zip_code, :order_number

end
