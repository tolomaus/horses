require 'spec_helper'

describe Horse do
  before(:each) do
    @horse = Factory.build(:horse)
  end

  describe "queries" do
    it "should retrieve the rides" do
      ride1 = Factory.build(:ride)
      ride2 = Factory.build(:ride)
      @horse.actions.push ride1
      @horse.actions.push ride2
      @horse.save!

      @horse.reload
      @horse.actions.to_ride.count.should == 2
      @horse.actions.to_ride.should include(ride1)
      @horse.actions.to_ride.should include(ride2)
    end
    it "should retrieve the registration" do
      registration = Factory.build(:registration)
      @horse.actions.push registration
      @horse.save!

      @horse.reload
      @horse.actions.to_register.should_not be_nil
    end
    it "should retrieve the riders" do
      rider_rel1 = Factory.build(:rider_rel)
      rider_rel2 = Factory.build(:rider_rel)
      @horse.relationships.push rider_rel1
      @horse.relationships.push rider_rel2
      @horse.save!

      @horse.reload
      @horse.relationships.as_rider.count.should == 2
      @horse.relationships.as_rider.should include(rider_rel1)
      @horse.relationships.as_rider.should include(rider_rel2)
    end
    it "should retrieve the horses related to me" do
      me = User.me
      user1 = Factory.create(:user)
      user2 = Factory.create(:user)

      horse1 = Factory.build(:horse)
      horse1.relationships.push Factory.build(:representative_rel, :user => me)
      horse1.relationships.push Factory.build(:rider_rel, :user => user1)
      horse1.relationships.push Factory.build(:owner_rel, :user => user2)
      horse1.save!

      horse2 = Factory.build(:horse)
      horse2.relationships.push Factory.build(:representative_rel, :user => me)
      horse2.relationships.push Factory.build(:rider_rel, :user => me)
      horse2.relationships.push Factory.build(:owner_rel, :user => me)
      horse2.save!

      horse3 = Factory.build(:horse)
      horse3.relationships.push Factory.build(:representative_rel, :user => user1)
      horse3.relationships.push Factory.build(:rider_rel, :user => user1)
      horse3.relationships.push Factory.build(:owner_rel, :user => user1)
      horse3.save!

      horse4 = Factory.build(:horse)
      horse4.relationships.push Factory.build(:representative_rel, :user => user1)
      horse4.relationships.push Factory.build(:rider_rel, :user => user2)
      horse4.relationships.push Factory.build(:owner_rel, :user => me)
      horse4.relationships.push Factory.build(:owner_rel, :user => user1)
      horse4.relationships.push Factory.build(:owner_rel, :user => user2)
      horse4.save!

      horses = Horse.related_to_user(me).with_related_users.all
      horses.count.should == 3
      horses.should include(horse1, horse2, horse4)
    end
  end

  describe "validations" do
    it "should be valid when created with valid properties" do
      @horse.should be_valid
    end

    it "should be valid when created with an action with valid properties" do
      ride = Factory.build(:ride)
      @horse.actions.push(ride) #must set the inverse_of on horse.actions

      @horse.should be_valid
    end

    it "should not be valid when created with a missing mandatory property" do
      @horse.name=nil
      @horse.should_not be_valid
    end

    it "should not be valid when created with an action with a missing mandatory property" do
      ride = Factory.build(:ride)
      ride.fb_action_id=nil
      @horse.actions.push(ride)

      @horse.should_not be_valid
    end

    it "should not be valid when created with an action with a missing occurred date" do
      ride = Factory.build(:ride)
      ride.occurred_at=nil
      @horse.actions.push(ride)

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

    describe "saving a new horse with an action using push" do
      it "should be successful" do
        ride = Factory.build(:ride)
        expect{
        expect{
          @horse.actions.push ride #must set the inverse_of on horse.rides
          if (!@horse.save)
            if (ride.invalid?)
              Rails.logger.info "Validation errors on the action:"
              ride.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
            end
            if (@horse.invalid?)
              Rails.logger.info "Validation errors on the horse:"
              @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
            end
          end
        }.to change(Horse, :count).by(1)
        }.to change(Action, :count).by(1)
      end
    end

    describe "saving a new horse with an action using push operator" do
      it "should be successful" do
        ride = Factory.build(:ride)
        expect{
        expect{
          @horse.actions << ride #must set the inverse_of on horse.rides
          if (!@horse.save)
            if (ride.invalid?)
              Rails.logger.info "Validation errors on the action:"
              ride.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
            end
            if (@horse.invalid?)
              Rails.logger.info "Validation errors on the horse:"
              @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
            end
          end
        }.to change(Horse, :count).by(1)
        }.to change(Action, :count).by(1)
      end
    end

    describe "saving a new horse with a new action using build" do
      it "should be successful" do
        expect{
        expect{
          attr = Factory.attributes_for(:ride)
          ride = @horse.actions.build(attr) #must set the necessary attr_accessible's and also inverse_of on horse.rides
          if (!@horse.save)
            if (ride.invalid?)
              Rails.logger.info "Validation errors on the action:"
              ride.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
            end
            if (@horse.invalid?)
              Rails.logger.info "Validation errors on the horse:"
              @horse.errors.each { |attr, msg| Rails.logger.info "- #{attr} - #{msg}" }
            end
          end
        }.to change(Horse, :count).by(1)
        }.to change(Action, :count).by(1)
      end
    end

    describe "saving first the new horse and then save it again with a new action using push" do
      it "should be successful" do
        ride = Factory.build(:ride)
        expect{
        expect{
          Horse.transaction do
            @horse.save!
            @horse.actions.push ride
            if (!@horse.save)
              if (ride.invalid?)
                Rails.logger.info "Validation errors on the action:"
                ride.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
              end
              if (@horse.invalid?)
                Rails.logger.info "Validation errors on the horse:"
                @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
              end
              raise ActiveRecord::Rollback
            end
          end
        }.to change(Horse, :count).by(1)
        }.to change(Action, :count).by(1)
      end
    end

    describe "saving first the new horse and then save it again with a new action using build" do
      it "should be successful" do
        expect{
        expect{
          Horse.transaction do
            @horse.save!
            attr = Factory.attributes_for(:ride)
            ride = @horse.actions.build(attr) #must set the necessary attr_accessible's
            if (!@horse.save)
              if (ride.invalid?)
                Rails.logger.info "Validation errors on the action:"
                ride.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
              end
              if (@horse.invalid?)
                Rails.logger.info "Validation errors on the horse:"
                @horse.errors.each { |attr,msg| Rails.logger.info "- #{attr} - #{msg}"}
              end
              raise ActiveRecord::Rollback
            end
          end
        }.to change(Horse, :count).by(1)
        }.to change(Action, :count).by(1)
      end
    end

    describe "saving an existing horse and action with changes" do
      before(:each) do
        @horse = Factory.build(:horse)
        @horse.actions.push Factory.build(:ride)
        @horse.save!
      end

      it "should update the horse" do
        @horse.name="UPDATED"
        @horse.save!
        @horse.reload
        @horse.name.should == "UPDATED"
      end
      it "should update the action" do
        @horse.actions.first.fb_action_id="UPDATED"
        @horse.save!
        @horse.reload
        @horse.actions.first.fb_action_id.should == "UPDATED"
      end
    end
  end
end


