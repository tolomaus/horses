class OauthController < ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook
  FACEBOOK_SCOPE = 'user_likes,user_photos,user_videos,publish_actions'#',user_actions:whitehorsefarm,friends_actions:whitehorsefarm'

  def new
    logger.info "Authentication is requested ..."
    session[:access_token]=nil
    session[:access_token_expiration]=nil
    redirect_to authenticator.authorize_url(:scope => FACEBOOK_SCOPE, :display => 'page')
  end
  
  def create    
    logger.info "Authentication callback is called ..."
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code],authenticator)
    session[:access_token]=mogli_client.access_token
    session[:access_token_expiration]=mogli_client.expiration
    logger.info "Authentication succeeded: client access token = #{mogli_client.access_token}"
    redirect_to root_url #FACEBOOK_CONFIG['canvas_url'] + horses_path
  end
  #
  #def cleanup
  #  session[:access_token]=nil
  #  session[:access_token_expiration]=nil
  #  redirect_to root_url
  #end

  def deauthorize_callback
    logger.info "Deauthorize callback is called ..."
    logger.info params
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new(FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], oauth_callback_url)
  end
end