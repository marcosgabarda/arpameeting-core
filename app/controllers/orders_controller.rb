class OrdersController < ApplicationController
    
    before_filter :check_signed_in, :only => [:create, :new]
    
    def express
        @recharge = session[:current_recharge]
        response = EXPRESS_GATEWAY.setup_purchase( (@recharge.amount*100).to_i , # Price in cents.
            :ip => request.remote_ip,
            :return_url => new_order_url,
            :cancel_return_url => new_recharge_url
        )
        redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
    
    def new
        @order = Order.new(:express_token => params[:token])
    end
    
    def create
        @order = Order.new
        @order.recharge = Recharge.find(session[:current_recharge_id])
        #express_checkout recharge.amount
    end
    
end
