class ServicesController < ApplicationController
    def index
        @services = Service.all
        respond_to do |format|
            format.html {render :xml => @services}
            format.xml {render :xml => @services}
            format.json {render :json => @services}
        end
    end
end
