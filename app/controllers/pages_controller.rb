class PagesController < ApplicationController
  def home
    redirect_to new_oauth_path and return unless session[:access_token]
    @title = "Home"
    @client=Mogli::Client.new(session[:access_token])
    @app  = Mogli::Application.find(FACEBOOK_CONFIG['app_id'], @client)
    @user = Mogli::User.find("me",@client)
    @friends = @user.friends
    @friends = @friends.sort_by{|f| [f.last_name, f.first_name]}
    @posts = @user.posts

    # for other data you can always run fql
    @friends_using_app = @client.fql_query("SELECT uid, name, first_name, last_name FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1")
    @friends_using_app = @friends_using_app.sort_by{|f| [f["last_name"], f["first_name"]]}
  end

  def close
    render :text => "<body onload='window.close();'/>"
  end
end
