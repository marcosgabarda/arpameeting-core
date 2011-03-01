module UsersHelper
=begin
    
=end
    def check_signed_in
        respond_to do |format|
            format.html do
                if !signed_in?
                    flash[:notice] = 'Authentication required'
                    redirect_to signin_path
                end
            end
            format.xml { check_http_basic }
            format.json { check_http_basic }
        end
    end

=begin
    
=end
    def check_http_basic
        authenticate_or_request_with_http_basic('Authentication') do |username, password|
            user = User.authenticate(username, password)
            if !user.nil?
                sign_in user
            end
            !user.nil?
        end
    end
end
