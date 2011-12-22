class HorsesController < ApplicationController
  def index
    @horses = Horse.all
  end

  def show
    @horse = Horse.find(params[:id])
  end

  def new
    @title = "Register your horse"
    @horse=Horse.new
    set_instance_variables
  end

  def create
    @horse = Horse.new(params[:horse])
    if @horse.save
      #horse must have an id before registering it to Facebook
      @horse.registration_id = FacebookService.new.register_horse @horse, horse_path(@horse), session[:access_token]
      redirect_to @horse, :flash => { :success => "Horse was successfully registered. Registration id: #{@horse.registration_id}" }
    else
      @title = "Register your horse"
      set_instance_variables
      render 'new'
    end
  end

  def edit
    @horse = Horse.find(params[:id])
  end

  def update
    @horse = Horse.find(params[:id])
    if @horse.update_attributes(params[:horse])
      response = FacebookService.new.update_horse horse_path(@horse), session[:access_token]
      redirect_to @horse, :flash => { :success => "Horse was successfully updated. Response from Facebook: #{CGI.unescape(response)}" }
    else
      render 'edit'
    end
  end

  def destroy
    @horse = Horse.find(params[:id])
    @horse.destroy
    redirect_to horses_path
  end

  def create_callback
    layout 'facebook'
    @horse = Horse.find(params[:id])
  end
end
