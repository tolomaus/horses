class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_if_necessary
  #rescue_from Exception, :with => :handle_exception

  def authenticate_if_necessary(force=false)
    if force || session[:access_token]==nil
      redirect_to new_oauth_path
      return false
    end

    #This code should be replaced by Mogli code once the bug on the error raised after an OAuth error is received is solved
    @user = FacebookService.new.get_me(session[:access_token])
    if Mogli::Client.response_is_error?(@user)
      if @user["error"]["type"] == 'OAuthException'
        logger.info "The access_token is invalid, therefore we must re-authenticate the user."
        redirect_to new_oauth_path
      else
        Mogli::Client.raise_client_exception(@user)
      end
    end

    @client = Mogli::Client.new(session[:access_token])
    @app = Mogli::Application.find(FACEBOOK_CONFIG['app_id'], @client)
  end

  def handle_exception(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>> Exception was caught <<<<<<<<<<<<"
    logger.error(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
  end
end
