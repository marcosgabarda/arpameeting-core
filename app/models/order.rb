class Order < ActiveRecord::Base
    belongs_to :recharge
    
    attr_accessor :first_name, :last_name
    
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
