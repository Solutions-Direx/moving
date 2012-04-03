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
  def modal(options = {})
    content_tag(:div, options.merge(:class => "modal")) do
      yield BootstrapModalBuilder.new(self)
    end
  end
  
  class BootstrapModalBuilder
    include ::ActionView::Helpers::TagHelper
    # include ActionView::Context
    
    def initialize(template)
      @template = template
    end
    
    def header(*args)
      options = options_from_hash(args)
      closeable = true
      closeable = options.delete(:closeable) if options.has_key?(:closeable)
      close_text = options.delete(:close_text) || "×"
      
      concat(tag(:div, options.merge(:class => "modal-header"), true))
      concat(content_tag(:a, close_text, options.merge(:class => "close", "data-dismiss" => "modal"))) if closeable
      concat(tag(:h3, {}, true))
      yield
      concat("</h3>")
      concat("</div>")
    end
    
    def body(*args)
      options = options_from_hash(args)
      concat(tag(:div, options.merge(:class => "modal-body"), true))
      yield
      concat("</div>")
    end
    
    def footer(*args)
      options = options_from_hash(args)
      concat(tag(:div, options.merge(:class => "modal-footer"), true))
      yield
      concat("</div>")
    end
    
    private
    
    def options_from_hash(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end

    def concat(tag)
      @template.safe_concat(tag)
      ""
    end
    
    def content_tag(tag, content, *args)
      options = options_from_hash(args)
      @template.content_tag(tag, content, options)
    end
  end
end
