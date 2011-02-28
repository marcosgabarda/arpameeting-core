require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
    
    test "get all rooms" do
        get :index
        assert_response :success
        assert_not_nil assigns(:rooms)
    end
    #post :create, :post => { :title => 'Some title'}
end
