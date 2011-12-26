class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_if_necessary
  #rescue_from Exception, :with => :handle_exception

  def authenticate_if_necessary(force=false)
    if force || session[:access_token]==nil
      logger.info ""
      redirect_to new_oauth_path
      return false
    end

    begin
      me = Mogli::User.find("me", Mogli::Client.new(session[:access_token]))
    rescue Exception => e
      logger.error "Exception caught while testing the validity of the access_token:"
      logger.error e.to_s
      redirect_to new_oauth_path
      return false
    end

    if Mogli::Client.response_is_error?(me)
      if me["error"]["type"] == 'OAuthException'
        authenticate_if_necessary true
      else
        Mogli::Client.raise_client_exception(me)
      end
    end

    @client = Mogli::Client.new(session[:access_token])
    @app = Mogli::Application.find(FACEBOOK_CONFIG['app_id'], @client)
    @user = Mogli::User.find("me", @client)
  end

  def handle_exception(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>> Exception was caught <<<<<<<<<<<<"
    logger.error(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
  end
end
