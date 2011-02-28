class Participant < ActiveRecord::Base
    belongs_to :room
    validates :name, :presence => true
    
    attr_accessor :services
    
    def price 
        return 0.0 if !phone.nil? and !phone.empty?
        service = Service.find_by_name("phonebrowser")
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
