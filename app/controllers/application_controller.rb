class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :prepare_context
  #rescue_from Exception, :with => :handle_exception

  def prepare_context
    authenticate_if_necessary
  end

  private
    def authenticate_if_necessary(force=false)
      if force || session[:access_token]==nil
        redirect_to new_oauth_path
        return false
      end

      begin
        test_user = Mogli::User.find("zuck", Mogli::Client.new(session[:access_token]))
      rescue Exception => e
        logger.error "Exception caught while testing the validity of the access_token:"
        logger.error e.to_s
        redirect_to new_oauth_path
        return false
      end

      if Mogli::Client.response_is_error?(test_user)
        if test_user["error"]["type"] == 'OAuthException'
          authenticate_if_necessary true
        else
          Mogli::Client.raise_client_exception(test_user)
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
