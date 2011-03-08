class Order < ActiveRecord::Base
    belongs_to :recharge
    has_many :transactions, :class_name => "OrderTransaction"
    
    attr_accessor :first_name, :last_name
    
    def purchase
        response = EXPRESS_GATEWAY.purchase(price_in_cents,
            {
                :ip => ip_address,
                :token => express_token,
                :payer_id => express_payer_id,
                :currency => "EUR"
            }
        )
        transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
        response.success?
    end
    
    def price_in_cents
        (recharge.amount.to_f*100).round
    end
    
    def express_token=(token)
        self[:express_token] = token
        if new_record? && !token.blank?
            details = EXPRESS_GATEWAY.details_for(token)
            self.express_payer_id = details.payer_id
            self.first_name = details.params["first_name"]
            self.last_name = details.params["last_name"]
        end
    end
    
end
