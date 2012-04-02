require 'spec_helper'

describe User do
  
  context "non-existed" do
    context "with empty attributes" do
      before { @non_existing_user = User.new }
      subject { @non_existing_user }
      it { should have(1).error_on(:email) }
      it { should have(1).error_on(:password) }
    end
    
    context "with valid attributes" do
      before { @non_existing_user = FactoryGirl.build(:user) }
      subject { @non_existing_user }
      it { should be_valid }
    end
  end
  
  context "existed" do
    let(:user) { FactoryGirl.create(:user) }
    subject { user }
    it { should_not be_new_record }
  end
  
end
