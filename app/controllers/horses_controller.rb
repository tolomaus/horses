class HorsesController < ApplicationController
  skip_before_filter :authenticate_if_necessary, :only => [:show, :create_callback]

  def index
    @title = "Your horses"
    @horses = Horse.all
  end

  def show
    @title = "Your horse"
    @horse = Horse.find(params[:id])
  end

  def new
    @title = "Register your horse"
    @horse=Horse.new
  end

  def create
    @horse = Horse.new(params[:horse])
    if @horse.save
      #horse must have an id before registering it to Facebook
      @horse.registration_id = FacebookService.new.register_horse @horse, create_callback_horse_url(@horse), session[:access_token]
      redirect_to @horse, :flash => { :success => "Horse was successfully registered. Registration id: #{@horse.registration_id}" }
    else
      @title = "Register your horse"
      render 'new'
    end
  end

  def edit
    @title = "Edit your horse"
    @horse = Horse.find(params[:id])
  end

  def update
    @horse = Horse.find(params[:id])
    if @horse.update_attributes(params[:horse])
      response = FacebookService.new.update_horse @horse, horse_url(@horse), session[:access_token]
      redirect_to @horse, :flash => { :success => "Horse was successfully updated. Response from Facebook: #{CGI.unescape(response)}" }
    else
      @title = "Edit your horse"
      render 'edit'
    end
  end

  def destroy
    @horse = Horse.find(params[:id])
    @horse.destroy
    redirect_to horses_path
  end

  def create_callback
    @horse = Horse.find(params[:id])
    render :layout => false
  end
end
