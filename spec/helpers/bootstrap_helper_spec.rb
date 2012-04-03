# encoding: UTF-8
require 'spec_helper'

describe BootstrapHelper do
  before(:each) do 
    helper.output_buffer = ""
  end
  
  context "button_link_to" do
    it "should render button link" do
      button_link = helper.button_link_to "Button Link", "http://google.com", {}
      button_link.should eq('<a href="http://google.com" class="btn">Button Link</a>')
    end
    
    it "should render button link with additional class" do
      button_link = helper.button_link_to "Button Link", "http://google.com", {:class => "test-link link"}
      button_link.should eq('<a href="http://google.com" class="btn test-link link">Button Link</a>')
    end
    
    it "should render large button link if :large provide" do
      button_link = helper.button_link_to "Button Link", "http://google.com", {:class => "test-link link", :large => true}
      button_link.should eq('<a href="http://google.com" class="btn btn-large test-link link">Button Link</a>')
    end
    
    it "should render level button link if :level provide" do
      button_link = helper.button_link_to "Button Link", "http://google.com", {:class => "test-link link", :level => "info"}
      button_link.should eq('<a href="http://google.com" class="btn btn-info test-link link">Button Link</a>')
    end
    
    it "should render large level button link if :level and :large provide" do
      button_link = helper.button_link_to "Button Link", "http://google.com", {:class => "test-link link", :level => "info", :large => true}
      button_link.should eq('<a href="http://google.com" class="btn btn-large btn-info test-link link">Button Link</a>')
    end
  end
  
  context "button_icon_link_to" do
    it "should render button link with icon if :icon provides" do
      button_icon_link = helper.icon_button_link_to "Icon Link", "http://google.com", :icon => "test"
      button_icon_link.should eq('<a href="http://google.com" class="btn"><i class="icon-test"></i> Icon Link</a>')
    end
    
    it "should render button link with white icon if :icon and :white provides" do
      button_icon_link = helper.icon_button_link_to "Icon Link", "http://google.com", :icon => "test", :white => true
      button_icon_link.should eq('<a href="http://google.com" class="btn"><i class="icon-test icon-white"></i> Icon Link</a>')
    end
    
    it "should not render button link with icon if :icon does not provides" do
      button_icon_link = helper.icon_button_link_to "Icon Link", "http://google.com", {}
      button_icon_link.should eq('<a href="http://google.com" class="btn"> Icon Link</a>') 
    end
  end
  
  context "modal" do
    context "with closeable header" do
      let(:modal_closeable) do
        output = helper.modal :id => "test-modal" do |builder|
          builder.header :close_text => "x" do
            helper.output_buffer.concat("Header")
          end
          builder.body do
            helper.output_buffer.concat("Body")
          end
          builder.footer do 
            helper.output_buffer.concat("Footer") 
          end
        end
      end
    
      subject { modal_closeable }
    
      it "should render correct wrapper html" do
        should match /<div class="modal" id="test-modal">.*<\/div>/
      end
    
      it "should render correct header html" do
        should match /<div class="modal-header"><a class="close" data-dismiss="modal">x<\/a><h3>Header<\/h3><\/div>/
      end
    
      it "should render correct body html" do
        should match /<div class="modal-body">Body<\/div>/
      end
    
      it "should render correct footer html" do
        should match /<div class="modal-footer">Footer<\/div>/
      end
    end
    
    context "without closeable header" do
      let(:modal_uncloseable) do
        helper.modal :id => "test-modal" do |builder|
          builder.header :closeable => false, :close_text => "x" do 
            helper.output_buffer.concat("Header")
          end
          builder.body do
            helper.output_buffer.concat("Body")
          end
          builder.footer do
            helper.output_buffer.concat("Footer")
          end
        end
      end
    
      subject { modal_uncloseable }
    
      it "should render correct wrapper html" do
        should match /<div class="modal" id="test-modal">.*<\/div>/
      end
    
      it "should render correct header html" do
        should match /<div class="modal-header"><h3>Header<\/h3><\/div>/
      end
    
      it "should render correct body html" do
        should match /<div class="modal-body">Body<\/div>/
      end
    
      it "should render correct footer html" do
        should match /<div class="modal-footer">Footer<\/div>/
      end
    end
    
  end
end
