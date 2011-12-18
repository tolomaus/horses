module PagesHelper
  def post_to_wall_url
    "https://www.facebook.com/dialog/feed?redirect_uri=#{close_url}&display=popup&app_id=#{@app.id}";
  end

  def send_to_friends_url
    "https://www.facebook.com/dialog/send?redirect_uri=#{close_url}&display=popup&app_id=#{@app.id}&link=#{url('/')}";
  end
end
