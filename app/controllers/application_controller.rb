class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery
  before_filter :ensure_authenticated_to_facebook
  before_filter :set_p3p_header_for_third_party_cookies
  rescue_from Mogli::Client::ClientException, :with => :handle_fb_exception

  def ensure_authenticated_to_facebook
    fetch_client_and_user
    if @_current_facebook_client == nil
      logger.info "No access token is available, therefore we have to redirect the user to root_url ... "
      redirect_to root_path and return false
    end
    #if session[:access_token]==nil || force
    #  logger.info "No access token is available, therefore we must authenticate the user ..."
    #  redirect_to root_path and return false
    #end
    #
    #check if the access token is still valid
    if @_current_facebook_client.expiration < (Time.now + 5.minutes)
      logger.info "The access_token has expired, therefore we must re-authenticate the user."
      cleanup_auth_cookie #cookie should have the same expiration date as the access token but this is not implemented as such yet by Mogli
      redirect_to root_path and return false
    end
    #
    ##This code should be removed once the bug on the error raised after an OAuth error is received is solved
    #user_hash = FacebookService.new.get_me(session[:access_token])
    #if user_hash.has_key?( "error")
    #  if user_hash["error"]["type"] == 'OAuthException'
    #    logger.info "The access_token is invalid, therefore we must re-authenticate the user."
    #    session[:access_token]=nil
    #    session[:access_token_expiration]=nil
    #    redirect_to root_path and return false
    #  else
    #    Mogli::Client.raise_client_exception(user_hash)
    #  end
    #end

    @fb_client = @_current_facebook_client
    @fb_app = Mogli::Application.find(FACEBOOK_CONFIG['app_id'], @fb_client)
    @fb_user = Mogli::User.find("me", @fb_client)
    @user = User.find_or_create_by_fb_user_id(@fb_user)
  end

  def cleanup_auth_cookie
    cookies.delete fb_cookie_name
  end

  def handle_fb_exception(exception)
    logger.warn exception
    flash[:exception] = exception

    render 'fb_exception'
  end

  def handle_exception(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>> Exception was caught <<<<<<<<<<<<"
    logger.error(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
  end
end
