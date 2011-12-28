class PagesController < ApplicationController
  skip_before_filter :authenticate_if_necessary, :only => [:index, :privacy, :deauthorize_callback]

  def index
    logger.info "Access token: #{session[:access_token]}"
    if session[:access_token]
      logger.info "An access token is available, therefore we can immediately redirecting to horses_url ... "
      redirect_to horses_url
    end
  end

  def home
    @title = "Home"

    @friends = @user.friends
    @friends = @friends.sort_by{|f| [f.last_name, f.first_name]}
    @posts = @user.posts

    # for other data you can always run fql
    @friends_using_app = @client.fql_query("SELECT uid, name, first_name, last_name FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1")
    @friends_using_app = @friends_using_app.sort_by{|f| [f["last_name"], f["first_name"]]}
  end

  def monitor
  end

  def privacy
  end

  def close
    render :text => "<body onload='window.close();'/>"
  end
end
