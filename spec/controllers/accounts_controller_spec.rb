require 'spec_helper'

describe AccountsController do
  
  let(:user) { target }
  
  context "with manager logged in" do
    let(:target) { FactoryGirl.create(:manager) }
    before(:each) { login(user) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end

    describe "GET 'update'" do
      it "returns http success" do
        put 'update'
        response.should redirect_to(account_url)
      end
    end
  end
  
  context "with standand user logged in" do
    let(:target) { FactoryGirl.create(:standard_user) }
    before(:each) { login(user) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should_not be_success
      end
    end

    describe "GET 'update'" do
      it "returns http success" do
        put 'update'
        response.should_not redirect_to(account_url)
      end
    end
  end
  
  context "with removal man logged in" do
    let(:target) { FactoryGirl.create(:removal_man) }
    before(:each) { login(user) }
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should_not be_success
      end
    end

    describe "GET 'update'" do
      it "returns http success" do
        put 'update'
        response.should_not redirect_to(account_url)
      end
    end
  end

end
