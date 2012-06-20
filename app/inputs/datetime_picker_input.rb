class DatetimePickerInput < SimpleForm::Inputs::Base
  def input
    template = @builder.template
    date_format = options.delete(:date_format) || I18n.t("date.js_format")
    
    raw_value = @builder.object.send(attribute_name)
    value = raw_value.blank? ? '' : I18n.l(raw_value.to_date)
    hidden_value = raw_value.blank? ? '' : raw_value.strftime("%Y/%m/%d")
    
    picker = template.text_field_tag("", value, class: "datepicker", name: nil)
    picker_hidden = template.hidden_field_tag("#{object.class.to_s.downcase}[#{attribute_name}][date]", hidden_value, class: "datepicker-alt")
    time = template.select_time(raw_value || nil, :minute_step => 15, :ignore_date => true, :prefix => "#{object.class.to_s.downcase}[#{attribute_name}]")
    "#{picker} #{picker_hidden} #{time}".html_safe
  end
end