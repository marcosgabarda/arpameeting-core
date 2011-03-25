class UsersController < ApplicationController
    
    before_filter :check_sing_up_enabled, :only => [:new, :create]
    before_filter :check_signed_in, :only => [:update, :edit]
    before_filter :check_same_user, :only => [:update, :edit]
    
    def check_same_user
        user = User.find(params[:id])
        if user != current_user
            flash[:notice] = 'You can\'t edit a profile from other user.'
            redirect_to root_path
        end
    end
    
    def show
        @user = User.find(params[:id])
    end
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        
    end
    
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
