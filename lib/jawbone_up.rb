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


class JawboneMovesToday
  attr_accessor :activity

  def initialize(activity)
    @activity = activity
  end

  def steps
    @activity["details"]["steps"]
  end

  def last_updated
    Time.at(@activity["time_updated"]).strftime("%m/%d/%Y%l:%M%P")
  end

  def miles
    "%0.2f" % (@activity["details"]["km"] * 0.621371)
  end

  def km
    "%0.2f" % (@activity["details"]["km"])
  end

  def total_burn
    format_delimiter(@activity["details"]["bmr"] + @activity["details"]["calories"])
  end

  def active_burn
    format_delimiter(@activity["details"]["calories"])
  end

  def resting_burn
    format_delimiter(@activity["details"]["bmr"])
  end

  def active
    format_seconds(@activity["details"]["active_time"])
  end

  def longest_active
    format_seconds(@activity["details"]["longest_active"])
  end

  def longest_idle
    format_seconds(@activity["details"]["longest_idle"])
  end

  def format_delimiter(number)
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts[0]
  end

  def format_seconds(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    format = ""
    format += "#{dd}d "  unless dd == 0
    format += "#{hh}h " unless hh == 0
    format += "#{mm}m " unless mm == 0
    format += "#{ss}s " unless ss == 0
    format
  end
end

class JawboneMoves < JawboneRequest

  attr_accessor :json

  END_POINT_URL = "/nudge/api/users/@me/moves"

  def initialize(token)
    response = jawbone_http(moves_url).request(jawbone_request_with_token(moves_url, token))
    @json = jawbone_parse_json(response)
    @json
  end

  def moves_url
    API_URL + END_POINT_URL
  end

  def today
    JawboneMovesToday.new(@json["data"]["items"].first)
  end

  def title
    puts "JSON FOR MOVES"
    puts @json.inspect
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

  def moves(token)
    JawboneMoves.new(token)
  end
end
