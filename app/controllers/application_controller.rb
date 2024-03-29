class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      return true
    else
      redirect_to root_url and return false
    end
  end
end
