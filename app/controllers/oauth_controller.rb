class OauthController < ApplicationController
  skip_before_filter :authenticate_if_necessary
  FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags,user_activities,manage_pages,read_stream,publish_actions'

  def new
    logger.info "Authentication is requested ..."
    session[:access_token]=nil
    redirect_to authenticator.authorize_url(:scope => FACEBOOK_SCOPE, :display => 'page')
  end
  
  def create    
    logger.info "Authentication callback is called ..."
    if params[:error]
      logger.error "oauth.create received an authentication error: #{params}"
      @error = params[:error]
      @error_reason = params[:error_reason]
      @error_description = params[:error_description]
      render 'error'
    end
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code],authenticator)
    session[:access_token]=mogli_client.access_token
    logger.info "Authentication succeeded: client access token = #{mogli_client.access_token}"
    redirect_to "/"
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new(FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], oauth_callback_url)
  end
end