# encoding: UTF-8
require 'spec_helper'

describe BootstrapHelper do
  
  context "modal helper" do
    context "with closeable header" do
      let(:modal_closeable) do
        helper.modal :id => "test-modal" do |builder|
          builder.header :close_text => "x" do
            "Header"
          end
          builder.body do
            "Body"
          end
          builder.footer { "Footer" }
        end
      end
    
      subject { modal_closeable }
    
      it "should render correct wrapper html" do
        should match /<div class="modal" id="test-modal">.*<\/div>/
      end
    
      it "should render correct header html" do
        should match /<div class="modal-header"><a class="close" data-dismiss="modal">x<\/a>Header<\/div>/
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
            "Header" 
          end
          builder.body do
            "Body"
          end
          builder.footer { "Footer" }
        end
      end
    
      subject { modal_uncloseable }
    
      it "should render correct wrapper html" do
        should match /<div class="modal" id="test-modal">.*<\/div>/
      end
    
      it "should render correct header html" do
        should match /<div class="modal-header">Header<\/div>/
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
