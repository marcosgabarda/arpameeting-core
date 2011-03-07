class RechargesController < ApplicationController
    before_filter :check_signed_in, :only => [:create, :new]
    
    def new
        @recharge = Recharge.new
    end

    def create
        @recharge = Recharge.new
        @recharge.amount = params[:recharge][:amount]
        @recharge.user = current_user
        session[:current_recharge] = @recharge
        redirect_to express_new_order_path
    end

end
