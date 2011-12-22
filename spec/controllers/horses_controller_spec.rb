require 'spec_helper'

describe HorsesController do

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'delete'" do
    it "should be successful" do
      get 'delete'
      response.should be_success
    end
  end

end
