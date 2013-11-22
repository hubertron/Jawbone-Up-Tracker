require './lib/jawbone_up'

class RootController < ApplicationController
  before_filter :authenticate_user, :except => [:index, :authorize]
  layout "user", only: [:home]

  def index
  end

  def authorize
    @code   = params[:code]
    @token  = JawboneUp.new.authorize(@code)
    @user   = User.find_or_create_jawbone_user(@token)
    if @user.blank?
      redirect_to root_url
    else
      session[:user_id] = @user.id
      redirect_to home_url
    end
  end

  def home
    @moves = JawboneUp.new.moves(@current_user.up_access_token)
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url
  end
end
