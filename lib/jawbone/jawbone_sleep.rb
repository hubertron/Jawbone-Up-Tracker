require 'jawbone/jawbone_request'
require 'jawbone/jawbone_sleep_today'

class JawboneSleep < JawboneRequest

  END_POINT_URL = "/nudge/api/users/@me/sleeps"

  def initialize(token)
    response = jawbone_http(sleep_url).request(jawbone_request_with_token(sleep_url, token))
    @json = jawbone_parse_json(response)
    @json
  end

  def sleep_url
    API_URL + END_POINT_URL
  end

  def today
    JawboneSleepToday.new(@json["data"]["items"].first)
  end
end
