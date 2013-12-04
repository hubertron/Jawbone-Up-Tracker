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
