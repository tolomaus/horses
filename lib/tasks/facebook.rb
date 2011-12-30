# You can put this file in your lib directory.
# Don't forget to add 'use Rack::Facebook' in config.ru.
# http://blog.coderubik.com/2011/03/restful-facebook-canvas-app-with-rails-and-post-for-canvas/
module Rack
  class Facebook
    
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Request.new(env)
      
      if request.POST['signed_request']
        env["REQUEST_METHOD"] = 'GET'
      end
      
      return @app.call(env)
    end
  
  end
end

