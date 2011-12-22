class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_instance_variables
  #rescue_from Exception, :with => :handle_exception

  def set_instance_variables
    @client = session[:client]
    @app = session[:app]
    @user = session[:user]
  end

  def handle_exception(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>> Exception was caught <<<<<<<<<<<<"
    logger.error(exception)
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
    logger.error ">>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<"
  end
end
