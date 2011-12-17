class PagesController < ApplicationController
  def home
    redirect_to new_oauth_path and return unless session[:access_token]
    logger.info "We are now authenticated!!! (access_token: #{session[:access_token]})"
    @client=Mogli::Client.new(session[:at])
    @app  = Mogli::Application.find('277975605588155', @client)
    @user = Mogli::User.find("me",@client)
    @friends = @user.friends
    @posts = @user.posts

    # for other data you can always run fql
    @friends_using_app = @client.fql_query("SELECT uid, name, is_app_user, pic_square FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1")

  end


end
