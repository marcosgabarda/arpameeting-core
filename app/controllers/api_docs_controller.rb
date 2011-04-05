class ApiDocsController < ApplicationController
    
    layout 'apidocs'
    
    def index
        @base_url = 'http://' + request.host_with_port + '/api/1'
        @root = request.host
    end

end
