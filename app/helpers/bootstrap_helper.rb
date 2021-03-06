# encoding: UTF-8

module BootstrapHelper
  
  def status_tag(status, options = {})
    klass = ["label"]
    if options.has_key?(:level)
      klass << "label-#{options.delete(:level).to_s}"
    end
    klass << options[:class].strip.split(/\+/) unless options[:class].blank?
    options[:class] = klass.flatten.join(" ")
    content_tag(:span, status, options)
  end
  
  def address_for(address, wrapper_tag = :address, separator_tag = :br)
    optional_address = [address.city, address.province, address.postal_code].select{|s| s.present?}.join(", ")

    content_tag(wrapper_tag) do
      safe_concat(address.address + tag(separator_tag) + optional_address)
    end
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    options = {"sort" => column, "direction" => direction}
    link_to title, params.merge(options), {:class => css_class}
  end
  
  def button_link_to(text, url, options)
    klass = ["btn"]
    if options.has_key?(:large)
      klass << "btn-large"
      options.delete(:large)
    end
    if options.has_key?(:level)
      klass << "btn-#{options[:level]}"
      options.delete(:level)
    end
    klass << options[:class].strip.split(/\+/) unless options[:class].blank?
    options[:class] = klass.flatten.join(" ")
    link_to text, url, options
  end
  
  def icon_link_to(text, url, options)
    icon = options.delete(:icon) if options.has_key?(:icon)
    icon_tag = ''
    if icon
      icon_klass = ["icon-#{icon}"]
      if options.has_key?(:white)
        icon_klass << ["icon-white"]
        options.delete(:white)
      end
      icon_tag = content_tag(:i, '', :class => icon_klass.join(' '))
    end
    link_to (icon_tag + " #{text}").html_safe, url, options
  end
  
  def icon_button_link_to(text, url, options)
    icon = options.delete(:icon) if options.has_key?(:icon)
    icon_tag = ''
    if icon
      klass = ["icon-#{icon}"]
      if options.has_key?(:white)
        klass << ["icon-white"]
        options.delete(:white)
      end
      icon_tag = content_tag(:i, '', :class => klass.join(' '))
    end
    
    button_link_to (icon_tag + " #{text}").html_safe, url, options
  end
  
  def modal(options = {})
    klass = ["modal"]
    klass << options[:class].strip.split(/\+/) unless options[:class].blank?
    options[:class] = klass.flatten.join(" ")
    content_tag(:div, options) do
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