class OrdersController < ApplicationController
    
    before_filter :check_signed_in, :only => [:create, :new]
    
    def express
        @recharge = session[:current_recharge]
        response = EXPRESS_GATEWAY.setup_purchase( (@recharge.amount.to_f*100).to_i , # Price in cents.
            {
                :ip => request.remote_ip,
                :return_url => new_order_url,
                :cancel_return_url => new_recharge_url,
                :currency => "EUR"
            }
        )
        if response.token.nil?
            flash[:error] = "Error connecting with PayPal, please, try again later."
            redirect_to new_recharge_url
        else
            redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
        end
    end
    
    def new
        @order = Order.new(:express_token => params[:token])
        @order.recharge = session[:current_recharge]
    end
    
    def create
        @order = Order.new(params[:order])
        @order.ip_address = request.remote_ip
        @order.recharge = session[:current_recharge]
        if @order.save
            if @order.purchase
                user = current_user
                user.credit += @order.price_in_cents/100.0
                user.save
                render :action => 'success'
            else
                render :action => 'failure'
            end
        else
            render :action => 'new'
        end
    end
    
end
