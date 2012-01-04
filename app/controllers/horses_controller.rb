class HorsesController < ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook , :only => [:show]

  def index
    @title = "Your horses"
    @horses = Horse.find_all_by_user_id(@user.id)
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
    transaction do
      @horse = Horse.new(params[:horse])
      if !@horse.save
        @title = "Register your horse"
        render 'new'
        raise ActiveRecord::Rollback
      end
      #horse must have an internal id before registering it to Facebook
      facebook_service = FacebookService.new(@fb_client)
      @action = Action.new(:user => @user,
                           :horse => @horse,
                           :action_type => ActionType.find_by_name(:register),
                           :occurred_at => DateTime.now
      )
      @action.occurred_at = DateTime.now
      if !@action.save
        @title = "Register your horse"
        render 'new'
      end
      @action.fb_action_id = facebook_service.register_horse! @horse, horse_url(@horse)
      @horse.fb_object_id = facebook_service.find_id_by_horse_url! horse_url(@horse)
    end

    redirect_to @horse, :flash => { :success => "Horse was successfully registered. Object id: #{@horse.fb_object_id}, registration id: #{@horse.fb_registration_id}" } and return
  end

  def edit
    @title = "Edit your horse"
    @horse = Horse.find(params[:id])
    if @horse.fb_user_id != @user.id
      redirect_to @horse, :flash => { :error => "You are not allowed to edit this horse." } and return
    end
  end

  def update
    @horse = Horse.find(params[:id])
    if @horse.fb_user_id != @user.id
      redirect_to @horse, :flash => { :error => "You are not allowed to update this horse." }
    end
    if @horse.update_attributes(params[:horse])
      FacebookService.new(@fb_client).update_horse! @horse, horse_url(@horse)
      redirect_to @horse, :flash => { :success => "Horse was successfully updated." } and return
    else
      @title = "Edit your horse"
      render 'edit'
    end
  end

  def destroy
    @horse = Horse.find(params[:id])
    if @horse.fb_user_id != @user.id
      redirect_to @horse, :flash => { :error => "You are not allowed to delete this horse." } and return
    end
    @horse.destroy
    redirect_to horses_path and return
  end
end
