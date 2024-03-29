require 'jawbone/jawbone_request'
require 'jawbone/jawbone_authorize'
require 'jawbone/jawbone_profile'
require 'jawbone/jawbone_moves'
require 'jawbone/jawbone_sleep'

class JawboneUp
  attr_accessor :access_token, :xid

  def initialize
  end

  def authorize(code)
    authorization = JawboneAuthorize.new(code).authorize_request
    token = authorization["access_token"]
    token
  end

  def profile(token)
    JawboneProfile.new(token)
  end

  def moves(token)
    JawboneMoves.new(token)
  end

  def sleep(token)
    JawboneSleep.new(token)
  end
end
