require 'spec_helper'

describe DashboardController do
  
  context "with manager logged in" do
    let(:manager) { FactoryGirl.create(:manager) }
    before(:each) { login(manager) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end
  end
end
