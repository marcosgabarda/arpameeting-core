class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include RoomsHelper
  include UsersHelper
  include OrdersHelper
end
