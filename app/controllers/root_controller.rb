require './lib/jawbone_up'

class RootController < ApplicationController
  def index
  end

  def authorize
    @code   = params[:code]
    @token  = JawboneUp.new.authorize(@code)
    @user   = User.find_or_create_jawbone_user(@token)
  end

  def home

  end
end
