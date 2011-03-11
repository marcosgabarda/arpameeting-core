class Participant < ActiveRecord::Base
    belongs_to :room
    validates :name, :presence => true
    
    attr_accessor :services
    
    def price 
        rate = 0.0
        #return rate if room.phonebrowser_service.nil?
        # Phone price
        if phone =~ /^\+346[0-9]+/ 
            rate = room.phonebrowser_service.rate_mobile
        # Mobile phone price
        elsif phone =~ /^\+349[0-9]+/
            rate = room.phonebrowser_service.rate
        end
        # TODO Parse international code and apply the corresponding 
        # price.
        duration = 0
        if !pb_call_finished.nil? and !pb_call_started.nil?
            duration = pb_call_finished - pb_call_started
        end
        return (rate/60) * duration 
    end
    
    def contact 
        if !phone.nil? and !phone.empty?
            return phone
        elsif !sip.nil? and !sip.empty?
            return sip
        elsif !browser.nil?
            return "browser"
        end
    end
end
