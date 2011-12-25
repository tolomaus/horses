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
    @horse.fb_user_id = @user.id
    if @horse.save
      #horse must have an internal id before registering it to Facebook
      @horse.fb_registration_id = FacebookService.new.register_horse @horse, horse_url(@horse), session[:access_token]
      @horse.fb_object_id = FacebookService.new.update_horse @horse, horse_url(@horse), session[:access_token]
      if @horse.save
        redirect_to @horse, :flash => { :success => "Horse was successfully registered. Object id: #{@horse.object_id}, registration id: #{@horse.registration_id}" }
        return
      end
    end
    # if one of the previous saves failed:
    @title = "Register your horse"
    render 'new'
  end

  def edit
    @title = "Edit your horse"
    @horse = Horse.find(params[:id])
  end

  def update
    @horse = Horse.find(params[:id])
    if @horse.update_attributes(params[:horse])
      FacebookService.new.update_horse @horse, horse_url(@horse), session[:access_token]
      redirect_to @horse, :flash => { :success => "Horse was successfully updated." }
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
