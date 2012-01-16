require 'spec_helper'

describe Horse do
  before(:each) do
    @horse = Factory.build(:horse)
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
          save_new_horse_and_save_again_with_action_using_push()
        }.to change(Horse, :count).by(1)
      end
      it "should save the action" do
        expect{
          save_new_horse_and_save_again_with_action_using_push()
        }.to change(Action, :count).by(1)
      end
    end
  end
end

def save_new_horse_and_action_using_push
  @action = Factory.build(:action)
  @horse.actions.push @action
  @action.horse = @horse #must be linked explicitly because push uses the horse id which is nil for a new horse
  if (!@horse.save)
    if (@action.invalid?)
      Rails.logger.info "Validation errors on the action:"
      @action.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse:"
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

def save_new_horse_and_action_using_build
  @action = @horse.actions.build(Factory.attributes_for(:action))
  if (!@horse.save)
    if (@action.invalid?)
      Rails.logger.info "Validation errors on the action:"
      @action.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse:"
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

def save_new_horse_and_save_again_with_action_using_push
  Horse.transaction do
    @horse.save!
    @action = Factory.build(:action)
    @horse.actions.push @action
    if (!@horse.save)
      if (@action.invalid?)
        Rails.logger.info "Validation errors on the action:"
        @action.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
      end
      if (@horse.invalid?)
        Rails.logger.info "Validation errors on the horse:"
        @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
      end
      raise ActiveRecord::Rollback
    end
  end
end


