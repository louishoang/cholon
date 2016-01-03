module Merchant
  class POS
    attr_accessor :token, :billing_address, :shipping_address, :customer

    CREDIT_CARD_TEST_NUMBER = "4111111111111111"

    def initialize(args)
      @token = Braintree::ClientToken.generate
      args.each{|k, v| instance_variable_set("@#{k}", v)}
    end

    def billing_address
      @order.billing_address
    end

    def shipping_address
      @order.shipping_address
    end

    def process_sale_transaction
      #NOTE : when using marketplace, we pay for all fees(transaction, refund ...)
      # :merchant_account_id => # use when split payment for marketplace
      # :service_fee_amount => 10 # use when split payment for marketplace
      # :hold_in_escrow => true
      # :tax_amount => #if applicable in the future

      result = Braintree::Transaction.sale(
        :amount => @order.total, #under 1000 for testing
        :payment_method_nonce => @nonce_from_the_client, #"fake-valid-nonce" when test
        :order_id => @order.id,
        :customer => {
          :first_name => billing_address.first_name,
          :last_name => billing_address.last_name,
          :company => billing_address.business_name,
        },
        :options => {
          :submit_for_settlement => true,
          :store_in_vault_on_success => true
        }
      )
    end

    def save_result_to_order(result)
      if result.class == Braintree::ErrorResult
        @order.status = Order.statuses[:declined]
        @order.raw_response = result.transaction.status.humanize
      elsif result.class == Braintree::SuccessfulResult
        @order.status = Order.statuses[:placed]
        @order.raw_response = result.transaction.status.humanize
      end
      @order.charged_at = result.transaction.created_at
      @order.cc_type = result.transaction.credit_card_details.card_type
      @order.cc_last_four = result.transaction.credit_card_details.last_4
      @order.cc_expiration_date = result.transaction.credit_card_details.expiration_date
      @order.issuing_bank = result.transaction.credit_card_details.issuing_bank
      @order.save

      result.class == Braintree::SuccessfulResult ? true : false
    end

    def save_customer_id_to_user(result)
      @current_user.braintree_customer_id = result.transaction.customer_details.id
      @current_user.save
    end

    def charge
      result = process_sale_transaction
      save_result_to_user(result)
      save_result_to_order(result)
    end
  end
end