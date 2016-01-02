module Merchant
  class Processor
    attr_accessor :token

    def initialize()
      @token = Braintree::ClientToken.generate
    end


  end
end