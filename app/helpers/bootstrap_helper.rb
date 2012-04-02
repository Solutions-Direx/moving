# encoding: UTF-8

module BootstrapHelper
  
  # modal do
  #   header "some text"
  #   body do
  #     
  #   end
  #   footer do
  #     
  #   end
  # end
  def modal(options = {}, &block)
    content_tag(:div, options.merge(:class => "modal")) do
      yield BootstrapModalBuilder.new(self)
    end
  end
  
  class BootstrapModalBuilder
    include ::ActionView::Helpers::TagHelper
    include ActionView::Context
    
    def initialize(template)
      @template = template
    end
    
    def header(options = {}, &block)
      closeable = true
      closeable = options.delete(:closeable) if options.has_key?(:closeable)
      close_text = options.delete(:close_text) || "×"
      close = closeable ? @template.content_tag(:a, close_text, :class => "close", "data-dismiss" => "modal") : ''
      content = close.concat(capture(&block))
      concat(@template.content_tag(:div, content, options.merge(:class => "modal-header")))
    end
    
    def body(options = {}, &block)
      content = capture(&block)
      concat(@template.content_tag(:div, content, options.merge(:class => "modal-body")))
    end
    
    def footer(options = {}, &block)
      content = capture(&block)
      concat(@template.content_tag(:div, content, options.merge(:class => "modal-footer")))
    end
    
    private

    def concat(tag)
      @template.safe_concat(tag)
      ""
    end
  end
end
