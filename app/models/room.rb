class Room < ActiveRecord::Base
    belongs_to :user
    has_one :phonebrowser_service
    has_many :participants
    accepts_nested_attributes_for :participants
    def start
        phonebrowser_service.start
    end
end
