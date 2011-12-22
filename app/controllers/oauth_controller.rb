class OauthController < ApplicationController
  #skip_before_filter :prepare_context
  FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags,user_activities,manage_pages,read_stream,publish_actions'

  def new
    logger.info "Authentication is requested ..."
    session[:access_token]=nil
    redirect_to authenticator.authorize_url(:scope => FACEBOOK_SCOPE, :display => 'page')
  end
  
  def create    
    logger.info "Authentication callback is called ..."
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code],authenticator)
    session[:access_token]=mogli_client.access_token
    logger.info "Authentication succeeded: client access token = #{mogli_client.access_token}"
    redirect_to "/"
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new(FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], oauth_callback_url)
  end
end