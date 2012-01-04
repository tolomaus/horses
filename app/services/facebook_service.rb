require 'net/http'
require "uri"

class FacebookService
  def initialize( fb_client )
    @fb_client = fb_client
  end

  def register_horse!(horse, horse_url)
    if Rails.env=='development'
      #Not possible to receive callbacks from Facebook while the app is running internally
      return
    end
    uri = URI.parse("https://graph.facebook.com/me/whitehorsefarm:register")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    Rails.logger.info "Calling Facebook server #{uri} with url #{horse_url} to register #{horse.name} (id #{horse.id})"

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"access_token" => @fb_client.access_token, "horse" => horse_url})
    response = http.request(request)
    parsed_json = ActiveSupport::JSON.decode(response.body)
    if response.code!='200'
      raise "Registration of horse #{horse.name} (id: #{horse.id}) to Facebook failed. Error returned by Facebook: #{parsed_json['error']['type']}: #{parsed_json['error']['message']}"
    end

    return parsed_json[:id]
  end

  def update_horse!(horse, horse_url)
    if Rails.env=='development'
      #Not possible to receive callbacks from Facebook while the app is running internally
      return
    end
    uri = URI.parse("https://graph.facebook.com")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    Rails.logger.info "Calling Facebook server #{uri} to update #{horse.name} (id #{horse.id})"

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"id" => horse_url, "scrape" => "true"})
    response = http.request(request)
    parsed_json = ActiveSupport::JSON.decode(response.body)
    if response.code!='200'
      raise "Update of horse #{horse.name} (id: #{horse.id}) to Facebook failed. Error returned by Facebook: #{parsed_json['error']['type']}: #{parsed_json['error']['message']}"
    end

    return parsed_json[:id]
  end

  def get_me(fb_client)
    uri = URI.parse("https://graph.facebook.com/me?access_token=#{@fb_client.access_token}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    Rails.logger.info "Calling Facebook server #{uri} to get 'me'"

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    parsed_json = ActiveSupport::JSON.decode(response.body)
    if response.code!='200'
      Rails.logger.info "Get 'me' from Facebook failed. Error returned by Facebook: #{parsed_json['error']['type']}: #{parsed_json['error']['message']}"
    end

    return parsed_json
  end

  def find_id_by_horse_url!(horse_url)
    @fb_client.fql_query("SELECT uid, name, first_name, last_name FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1")

  end
end