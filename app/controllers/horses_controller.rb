class HorsesController < ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook , :only => [:show]

  def index
    @title = "Your horses"
    horses=Horse.related_to_user(@user)
                .with_related_users
    @related_horses = Horse.sort_by_importance(horses, @user)
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
    action = Action.new(:user => @user,
                        :horse => @horse,
                        :action_type => ActionType.find_by_name(:register),
                        :occurred_at => Time.now
    )
    @horse.actions.push action
    if !@horse.save
      @title = "Register your horse"
      render 'new'
    end

    facebook_service = FacebookService.new(@fb_client)
    begin
      action.fb_action_id = facebook_service.register_horse! @horse, horse_url(@horse)
    rescue Exception => e
      logger.error e
    end
    begin
      @horse.fb_object_id = facebook_service.find_id_by_horse_url! horse_url(@horse)
    rescue Exception => e
      logger.error e
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
