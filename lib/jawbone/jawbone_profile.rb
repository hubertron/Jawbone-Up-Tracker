require 'jawbone/jawbone_request'

class JawboneProfile < JawboneRequest
  attr_accessor :json

  END_POINT_URL = "nudge/api/v.1.0/users/@me"

  def initialize(token)
    response = jawbone_http(profile_url).request(jawbone_request_with_token(profile_url, token))
    @json = jawbone_parse_json(response)
    @json
  end

  def profile_url
    API_URL + END_POINT_URL
  end

  def first_name
    @json["data"]["first"]
  end

  def last_name
    @json["data"]["last"]
  end

  def xid
    @json["data"]["xid"]
  end

  def image_url
    @json["data"]["image"]
  end
end

