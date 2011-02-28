class Service < ActiveRecord::Base
    has_many :fields
    validates :name, :uniqueness => true
end
