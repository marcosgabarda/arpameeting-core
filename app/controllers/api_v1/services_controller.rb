class ApiV1::ServicesController < ApiV1::APIController
    def index
        @services = Service.all
        api_respond @services
    end
end
