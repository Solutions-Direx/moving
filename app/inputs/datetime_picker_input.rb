class DatetimePickerInput < SimpleForm::Inputs::Base
  def input
    template = @builder.template
    date_format = options.delete(:date_format) || I18n.t("date.js_format")
    raw_value = @builder.object.send(attribute_name)
    value = raw_value.blank? ? '' : I18n.l(raw_value.to_date)
    picker = template.text_field_tag("#{object.class.to_s.downcase}[#{attribute_name}][date]", value, class: "datepicker", "data-date-format" => date_format)
    time = template.select_time(raw_value || nil, :ignore_date => true, :prefix => "#{object.class.to_s.downcase}[#{attribute_name}]")
    "#{picker} #{time}".html_safe
  end
end