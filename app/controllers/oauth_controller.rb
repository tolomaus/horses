class OauthController < ApplicationController
  FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags,user_activities,manage_pages,read_stream'

  def new
    session[:access_token]=nil
    redirect_to authenticator.authorize_url(:scope => FACEBOOK_SCOPE, :display => 'page')
  end
  
  def create    
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code],authenticator)
    session[:access_token]=mogli_client.access_token
    logger.info "client access token: #{mogli_client.access_token}"
    redirect_to "/"
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new('277975605588155',
                                         '6cfef061c4aa154dc24b1c44ce3d720b',
                                         oauth_callback_url)
  end
end