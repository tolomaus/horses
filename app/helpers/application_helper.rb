module ApplicationHelper
  def title
    base_title = @app.name
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  def url(path)
    base = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    base + path
  end
end
