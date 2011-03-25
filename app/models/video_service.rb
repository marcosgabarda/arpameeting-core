class VideoService < ActiveRecord::Base
    belongs_to :service
    belongs_to :room
    has_many :participants, :through => :room
    
    validates :group_name, :uniqueness => true
    
    before_save :default_service
    
    def default_service
        self.service = Service.find_by_name("video")
        if !VideoService.find_by_group_name(self.group_name).nil?
            self.group_name = "video" + Digest::SHA2.hexdigest(Time.now.to_s)
        end
    end

end
