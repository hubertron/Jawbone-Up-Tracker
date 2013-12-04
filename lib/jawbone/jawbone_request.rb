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

