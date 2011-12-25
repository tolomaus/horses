require 'net/http'
require "uri"

class FacebookService
  def register_horse(horse, horse_url, access_token)
    uri = URI.parse("https://graph.facebook.com/me/spookje:register")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    Rails.logger.info "Calling Facebook server #{uri} with url #{horse_url} to register #{horse.name} (id #{horse.id})"

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"access_token" => access_token, "horse" => horse_url})
    response = http.request(request)
    Rails.logger.info "response: #{response.code}: #{response.message}"
    Rails.logger.info "response body: #{response.body}"
    parsed_json = ActiveSupport::JSON.decode(response.body)
    if response.code!='200'
      raise "Registration of horse #{horse.name} (id: #{horse.id}) to Facebook failed. Error returned by Facebook: #{parsed_json['error']['type']}: #{parsed_json['error']['message']}"
    end

    return parsed_json[:id]
  end

  def update_horse(horse, horse_url, access_token)
    uri = URI.parse("https://graph.facebook.com")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    Rails.logger.info "Calling Facebook server #{uri} to update #{horse.name} (id #{horse.id})"

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"id" => horse_url, "scrape" => "true"})
    response = http.request(request)
    Rails.logger.info "response: #{response.code}: #{response.message}"
    Rails.logger.info "response body: #{response.body}"
    parsed_json = ActiveSupport::JSON.decode(response.body)
    if response.code!='200'
      raise "Update of horse #{horse.name} (id: #{horse.id}) to Facebook failed. Error returned by Facebook: #{parsed_json['error']['type']}: #{parsed_json['error']['message']}"
    end

    return parsed_json[:id]
  end
end