require 'spec_helper'

describe DashboardController do
  let(:user) { target }
  
  context "with manager logged in" do
    let(:target) { FactoryGirl.create(:manager) }
    before(:each) { login(user) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should render_template("show")
      end
    end
  end
  
  context "with standand user logged in" do
    let(:target) { FactoryGirl.create(:standard_user) }
    before(:each) { login(user) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should render_template("show")
      end
    end
  end
  
  context "with removal man logged in" do
    let(:target) { FactoryGirl.create(:removal_man) }
    before(:each) { login(user) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should render_template("show")
      end
    end
  end
end
