require 'spec_helper'

describe User do
  before(:each) do
    @user = Factory.create(:user)
  end
  describe "queries" do
    it "should retrieve the horse relations the user rides" do
      @user.relationships.push Factory.build(:rider_rel)
      @user.relationships.push Factory.build(:rider_rel)
      @user.save!

      @user.reload
      @user.relationships.should_not be_nil
      @user.relationships.count.should == 2
    end

    it "should retrieve the horses the user rides with collect" do
      @user.relationships.push Factory.build(:rider_rel)
      @user.relationships.push Factory.build(:rider_rel)
      @user.save!

      @user.reload
      horses = @user.relationships.as_rider.joins(:horse).collect(&:horse)
      horses.should_not be_nil
      horses.count.should == 2
    end

    it "should retrieve the horses the user rides with select" do
      @user.relationships.push Factory.build(:rider_rel)
      @user.relationships.push Factory.build(:rider_rel)
      @user.save!

      @user.reload
      horses = @user.relationships.as_rider.select_horses
      horses.should_not be_nil
      horses.count.should == 2
    end
  end
end
