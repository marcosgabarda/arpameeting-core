require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
    test "new user" do
        user = User.new
        user.email = 'name@domain.com'
        user.password = '123'
        user.password_confirmation = '123'
        assert user.save
    end
    
    test "new user without password" do
        user = User.new
        user.email = 'name@domain.com'
        assert !user.save
    end
    
    test "new user password dont match" do
        user = User.new
        user.email = 'name@domain.com'
        user.password = '123'
        user.password_confirmation = '456'
        assert !user.save
    end
    
    test "new user wrong email" do
        user = User.new
        user.email = 'name'
        user.password = '123'
        user.password_confirmation = '456'
        assert !user.save
    end
    
    test "authenticate users" do
        user = User.authenticate('test1@arpameeting.com', 'asd')
        assert_not_nil user
    end
    
    test "wrong authenticate users" do
        user = User.authenticate('test1@arpameeting.com', '123')
        assert_nil user
    end
end