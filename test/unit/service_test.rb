require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
    
    test "new service" do
        service = Service.new
        service.name = "name_uniq"
        assert service.save
    end
    
    test "new existing service" do
        service = Service.new
        service.name = "phonebrowser"
        assert !service.save
    end
    
end
