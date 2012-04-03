require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user, first_name: "Foo", last_name: "Bar") }
  let(:manager) { FactoryGirl.create(:manager) }
  let(:standard) { FactoryGirl.create(:standard) }
  let(:removal_man) { FactoryGirl.create(:removal_man) }
  
  context "non-existed" do
    context "with empty attributes" do
      before { @non_existing_user = User.new }
      subject { @non_existing_user }
      it { should have(1).error_on(:email) }
      it { should have(1).error_on(:password) }
      it { should have(1).error_on(:account_id) }
      it { should have(1).error_on(:role) }
    end
    
    context "with valid attributes" do
      before { @non_existing_user = FactoryGirl.build(:user) }
      subject { @non_existing_user }
      it { should be_valid }
    end
  end
  
  context "existed" do
    subject { user }
    it { should_not be_new_record }
  end
  
  context "check user role" do
    it "should be manager" do
      manager.manager?.should be_true
    end
  
    it "should be standard" do
      standard.standard?.should be_true
    end
  
    it "should be removal_man" do
      removal_man.removal_man?.should be_true
    end
  end
  
  it "should have valid full name" do 
    user.full_name.should eq("Foo Bar")
  end
end
