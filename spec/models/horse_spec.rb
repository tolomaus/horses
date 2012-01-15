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

    describe "when saving a new horse with an action pushed to it" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action()
        }.to change(Horse, :count).by(1)
      end

      it "should save the action" do
        expect{
          save_new_horse_and_action()
        }.to change(Action, :count).by(1)
      end
    end

    describe "when saving a new horse with an action built on it" do
      it "should save the horse" do
        expect{
          save_new_horse_and_action_with_build()
        }.to change(Horse, :count).by(1)
      end

      it "should save the action" do
        expect{
          save_new_horse_and_action_with_build()
        }.to change(Action, :count).by(1)
      end
    end

    it "should save the horse when saving a new horse with an action pushed to it" do
      expect{
        save_new_horse_and_action_with_push()
      }.to change(Horse, :count).by(1)
    end

    it "should save the action when saving a new horse with an action pushed to it" do
      expect{
        save_new_horse_and_action_with_push()
      }.to change(Action, :count).by(1)
    end

    it "should save the new horse and then the action" do
      expect{
        @horse.save!
        @action = Factory.build(:action)
        @horse.actions.push @action
        if (!@horse.save)
          if (@action.invalid?)
            Rails.logger.info "Validation errors on the action ..."
            @action.errors.each { |attr,msg| Rails.logger.info "error: #{attr} - #{msg}"}
          end
          if (@horse.invalid?)
            Rails.logger.info "Validation errors on the horse ..."
            @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
          end
        end
      }.to change(Action, :count).by(1)
    end

    #it "should save the horse when saving a new horse with an action pushed to it inside a transaction" do
    #  expect{
    #    Horse.transaction do
    #      @action = Factory.build(:action)
    #      if (@action.invalid?)
    #        Rails.logger.info "Validating the action ..."
    #        @action.errors.each { |attr,msg| Rails.logger.info "error: #{attr} - #{msg}"}
    #        raise ActiveRecord::Rollback
    #      end
    #      @horse.actions.push @action
    #      if (!@horse.save)
    #        Rails.logger.info "Validating the horse ..."
    #        @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
    #        raise ActiveRecord::Rollback
    #      end
    #    end
    #  }.to change(Horse, :count).by(1)
    #end
    #
    #it "should save the action when saving a new horse with an action pushed to it inside a transaction" do
    #  expect{
    #    Horse.transaction do
    #      @action = Factory.build(:action)
    #      @horse.actions.push @action
    #      if (!@horse.save)
    #        @horse.errors.each { |attr,msg| Rails.logger.info "error: #{attr} - #{msg}"}
    #        raise ActiveRecord::Rollback
    #      end
    #    end
    #  }.to change(Action, :count).by(1)
    #end

  end
end

def save_new_horse_and_action_with_push
  @action = Factory.build(:action)
  @horse.actions.push @action
  if (!@horse.save)
    if (@action.invalid?)
      Rails.logger.info "Validation errors on the action ..."
      @action.errors.each { |attr, msg| Rails.logger.info "error: #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse ..."
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

def save_new_horse_and_action_with_build
  @horse.actions.build(Factory.build(:action))
  if (!@horse.save)
    if (@action.invalid?)
      Rails.logger.info "Validation errors on the action ..."
      @action.errors.each { |attr, msg| Rails.logger.info "error: #{attr} - #{msg}" }
    end
    if (@horse.invalid?)
      Rails.logger.info "Validation errors on the horse ..."
      @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
    end
  end
end

