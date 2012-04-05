require 'spec_helper'

describe "storages/index" do
  before(:each) do
    assign(:storages, [
      stub_model(Storage,
        :name => "Name",
        :default => false,
        :account_id => "Account"
      ),
      stub_model(Storage,
        :name => "Name",
        :default => false,
        :account_id => "Account"
      )
    ])
  end

  it "renders a list of storages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Account".to_s, :count => 2
  end
end
