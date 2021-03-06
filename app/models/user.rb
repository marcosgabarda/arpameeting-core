require 'digest/sha2'
class User < ActiveRecord::Base
    # An user have many rooms
    has_many :rooms
    
    # oAuth
    has_many :client_applications
    has_many :tokens, :class_name => "OauthToken", :order => "authorized_at desc", :include => [:client_application]
    
    attr_accessor :password, :password_confirmation
    
    validates :password, :presence     => true,
                         :confirmation => true,
                         :on => :create
    #                     :length       => { :within => 6..40 }
    
    validates :email, :uniqueness => true,
                      :presence => true,
                      :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
    
    #validates_uniqueness_of :email
    
    before_save :hash_new_password, :if => :password_changed?
    
    def password_changed?
        !@password.blank?
    end
    
    def has_password?(submitted_password)
        hashed_password == Digest::SHA2.hexdigest(salt + submitted_password)
    end
    
    def credit=(credit)
        self[:credit] = (credit*100).to_i
    end
    
    def credit
        (self[:credit].to_f)/100
    end
    
    def self.authenticate(email, submitted_password)
        user = find_by_email(email)
        return nil  if user.nil?
        return user if user.has_password?(submitted_password)
     end
    
    def self.authenticate_with_salt(id, cookie_salt)
        user = find_by_id(id)
        (user && user.salt == cookie_salt) ? user : nil
    end
    
    private
    
    def hash_new_password
        self.salt = ActiveSupport::SecureRandom.base64(8)
        self.hashed_password = Digest::SHA2.hexdigest(self.salt + @password)
    end
    
end
