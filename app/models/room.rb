class Room < ActiveRecord::Base
    belongs_to :user
    has_one :phonebrowser_service
    has_one :video_service
    has_many :participants
    
    accepts_nested_attributes_for :participants
    
    def start
        phonebrowser_service.start
    end
    
    def price
        price = 0.0
        participants.each do |participant|
            price += participant.price
        end
        return price.round(2)
    end
    
end
