require 'spec_helper'

describe Account do
  
  it "should have company name" do
    account = FactoryGirl.create(:account)
    account.company_name.should_not be_empty
  end
  
  it "should have owner" do
    account = FactoryGirl.create(:account)
    owner = FactoryGirl.create(:account_owner, :account => account)
    account.owner.should == owner
  end
end
