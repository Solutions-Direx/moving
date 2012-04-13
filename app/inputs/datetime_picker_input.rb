class DatetimePickerInput < SimpleForm::Inputs::Base
  def input
    template = @builder.template
    date_format = options.delete(:date_format) || I18n.t("date.js_format")
    raw_value = @builder.object.send(attribute_name)
    
    value = raw_value.blank? ? '' : I18n.l(raw_value.to_date)
    picker = template.text_field_tag("#{object.class.to_s.downcase}[#{attribute_name}][date]", value, class: "datepicker", "data-date-format" => date_format)
    hour = template.select_tag "#{object.class.to_s.downcase}[#{attribute_name}][hour]", template.options_for_select((1..12), raw_value ? raw_value.strftime("%I").to_i : nil)
    minute = template.select_minute(raw_value || nil, :minute_step => 15, :prefix => "#{object.class.to_s.downcase}[#{attribute_name}]")
    ampm = ""
    ampm << template.content_tag(:label, :class => "radio inline") { template.radio_button_tag("#{object.class.to_s.downcase}[#{attribute_name}][ampm]", 'AM', raw_value && raw_value.strftime("%p") == "AM", :id => "removal_at_am") + "AM" }
    ampm << template.content_tag(:label, :class => "radio inline") { template.radio_button_tag("#{object.class.to_s.downcase}[#{attribute_name}][ampm]", 'PM', raw_value && raw_value.strftime("%p") == "PM", :id => "removal_at_pm") + "PM" }
    "#{picker} #{hour} : #{minute} #{ampm}".html_safe
  end
end