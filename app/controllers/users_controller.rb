class UsersController < ApplicationController
    
    def create
        @user = User.new(params[:user])
        if @user.save
            # Successful save
            redirect_to signin_path
        else
            redirect_to signup_path
        end
    end
    
    def new
        @user = User.new
    end
end
