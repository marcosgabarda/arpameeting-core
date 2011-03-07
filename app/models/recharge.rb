class Recharge < ActiveRecord::Base
    belongs_to :user
    validates :amount, :presence => true, 
                       :numericality => true,
                       :length => { :minimum => 0, :maximum => 2000 }
end
