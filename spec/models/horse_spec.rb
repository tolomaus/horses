require 'spec_helper'

describe Horse do
  before(:each) do
    @horse = Factory.build(:horse)
  end

  describe "validations" do
    it "should be valid when created with valid properties" do
      @horse.should be_valid
    end

    it "should be valid when created with an action with valid properties" do
      action = Factory.build(:action)
      @horse.actions.push action #must set the inverse_of on horse.actions

      @horse.should be_valid
    end

    it "should not be valid when created with a missing mandatory property" do
      @horse.name=nil
      @horse.should_not be_valid
    end

    it "should not be valid when created with an action with a missing mandatory property" do
      action = Factory.build(:action)
      action.fb_action_id=nil
      @horse.actions.push action

      @horse.should_not be_valid
    end

    it "should not be valid when created with an action with a missing occurred date" do
      action = Factory.build(:action)
      action.occurred_at=nil
      @horse.actions.push action

      @horse.should_not be_valid
    end
  end

  describe "transactions" do
    it "should save a new horse" do
      expect{
        @horse.save
      }.to change(Horse, :count).by(1)
    end

    it "should save a new horse inside a transaction" do
      expect{
        Horse.transaction do
          @horse.save
        end
      }.to change(Horse, :count).by(1)
    end

    describe "when saving a new horse with an action using push" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action_using_push()
        }.to change(Horse, :count).by(1)
      end

      it "should save the action" do
        expect{
          save_new_horse_and_action_using_push()
        }.to change(Action, :count).by(1)
      end
    end

    describe "when saving a new horse with an action using push operator" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action_using_push()
        }.to change(Horse, :count).by(1)
      end

      it "should save the action" do
        expect{
          save_new_horse_and_action_using_push()
        }.to change(Action, :count).by(1)
      end
    end

    describe "when saving a new horse with a new action using build" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action_using_build()
        }.to change(Horse, :count).by(1)
      end

      it "should save the action" do
        expect{
          save_new_horse_and_action_using_build()
        }.to change(Action, :count).by(1)
      end
    end

    describe "when saving first the new horse and then save it again with a new action using push" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action_with_intermediate_save_using_push()
        }.to change(Horse, :count).by(1)
      end
      it "should save the action" do
        expect{
          save_new_horse_and_action_with_intermediate_save_using_push()
        }.to change(Action, :count).by(1)
      end
    end

    describe "when saving first the new horse and then save it again with a new action using build" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action_with_intermediate_save_using_build()
        }.to change(Horse, :count).by(1)
      end
      it "should save the action" do
        expect{
          save_new_horse_and_action_with_intermediate_save_using_build()
        }.to change(Action, :count).by(1)
      end
    end
  end
end

def save_new_horse_and_action_using_push
  action = Factory.build(:action)
  @horse.actions.push action #must set the inverse_of on horse.actions
  if (!@horse.save)
    if (action.invalid?)
      Rails.logger.info "Validation errors on the action:"
      action.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse:"
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

def save_new_horse_and_action_using_push_operator
  action = Factory.build(:action)
  @horse.actions << action #must set the inverse_of on horse.actions
  if (!@horse.save)
    if (action.invalid?)
      Rails.logger.info "Validation errors on the action:"
      action.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse:"
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

def save_new_horse_and_action_using_build
  attr = Factory.attributes_for(:action)
  action = @horse.actions.build(attr) #must set the necessary attr_accessible's and also inverse_of on horse.actions
  if (!@horse.save)
    if (action.invalid?)
      Rails.logger.info "Validation errors on the action:"
      action.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse:"
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

def save_new_horse_and_action_with_intermediate_save_using_push
  Horse.transaction do
    @horse.save!
    action = Factory.build(:action)
    @horse.actions.push action
    if (!@horse.save)
      if (action.invalid?)
        Rails.logger.info "Validation errors on the action:"
        action.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
      end
      if (@horse.invalid?)
        Rails.logger.info "Validation errors on the horse:"
        @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
      end
      raise ActiveRecord::Rollback
    end
  end
end

def save_new_horse_and_action_with_intermediate_save_using_build
  Horse.transaction do
    @horse.save!
    attr = Factory.attributes_for(:action)
    action = @horse.actions.build(attr) #must set the necessary attr_accessible's
    if (!@horse.save)
      if (action.invalid?)
        Rails.logger.info "Validation errors on the action:"
        action.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
      end
      if (@horse.invalid?)
        Rails.logger.info "Validation errors on the horse:"
        @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
      end
      raise ActiveRecord::Rollback
    end
  end
end


