require 'jawbone/jawbone_request'
require 'jawbone/jawbone_moves_today'

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
    puts @json.inspect
  end
end
