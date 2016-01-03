module Merchant
  class POS
    attr_accessor :token

    def initialize(args)
      @token = Braintree::ClientToken.generate
      args.each{|k, v| instance_variable_set("@#{k}", v)}
    end

    def create_new_customer
      result = Braintree::Customer.create(
        :first_name => @first_name,
        :last_name => @last_name,
        :company => @business_name
      )
      @current_user.braintree_customer_id = result.customer.id
      @current_user.save
    end

    def create_new_client_token
      result = Braintree::ClientToken.generate(
        :customer_id => params[:customer_id]
      )
    end


    def create_new_credit_card
      :credit_card => {
        :billing_address => {
          :company => @company,
          :country_code_alpha2 => "US",
          :country_name => "United States of America",
          :street_address => @address1,
          :extended_address => @address2,
          :first_name => @first_name,
          :last_name => @last_name,
          :postal_code => @zip_code
        }
      }
    end

  end
end