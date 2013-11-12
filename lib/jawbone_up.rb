require "net/https"
require "uri"

class JawboneRequest
  API_URL = "https://jawbone.com/"

  def initialize
  end

  def jawbone_http(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def jawbone_request(url)
    Net::HTTP::Get.new(jawbone_request_uri(url))
  end

  def jawbone_request_with_token(url, token)
    request = Net::HTTP::Get.new(jawbone_request_uri(url))
    request['Authorization'] = "Bearer #{token}"
    request
  end

  def jawbone_request_uri(url)
    URI.parse(url).request_uri
  end

  def jawbone_parse_json(response)
    JSON.parse(response.body)
  end
end

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

class JawboneAuthorize < JawboneRequest
  attr_accessor :code

  def initialize(code)
    self.code = code
  end

  def authorize_request
    response = jawbone_http(authorization_url).request(jawbone_request(authorization_url))
    jawbone_parse_json(response)
  end

  def authorization_url
    API_URL + "auth/oauth2/token?client_id=#{Rails.configuration.up_app_client_id}&grant_type=authorization_code&code=#{self.code}&client_secret=#{Rails.configuration.up_app_secret}"
  end
end

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
end
