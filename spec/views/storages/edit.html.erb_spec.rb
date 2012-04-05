require 'spec_helper'

describe "storages/edit" do
  before(:each) do
    @storage = assign(:storage, stub_model(Storage,
      :name => "MyString",
      :default => false,
      :account_id => "MyString"
    ))
  end

  it "renders the edit storage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => storages_path(@storage), :method => "post" do
      assert_select "input#storage_name", :name => "storage[name]"
      assert_select "input#storage_default", :name => "storage[default]"
      assert_select "input#storage_account_id", :name => "storage[account_id]"
    end
  end
end
