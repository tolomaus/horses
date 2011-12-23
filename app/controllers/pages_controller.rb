class PagesController < ApplicationController
  def home
    @title = "Home"

    @friends = @user.friends
    @friends = @friends.sort_by{|f| [f.last_name, f.first_name]}
    @posts = @user.posts

    # for other data you can always run fql
    @friends_using_app = @client.fql_query("SELECT uid, name, first_name, last_name FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1")
    @friends_using_app = @friends_using_app.sort_by{|f| [f["last_name"], f["first_name"]]}
  end

  def reauthenticate
    authenticate_if_necessary true
  end

  def close
    render :text => "<body onload='window.close();'/>"
  end
end
