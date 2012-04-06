class DatetimePickerInput < SimpleForm::Inputs::Base
  def input
    date_format = options.delete(:date_format) || I18n.t("date.js_format")
    value = @builder.object[attribute_name].blank? ? '' : I18n.l(@builder.object[attribute_name].to_date)
    picker = @builder.template.text_field_tag("#{attribute_name.to_s}_picker".to_sym, value, name: nil, class: "datepicker include_time", "data-date-format" => date_format)
    "#{picker} #{@builder.datetime_select(attribute_name, :discard_day => true, :discard_month => true, :discard_year => true, :minute_step => 15)}".html_safe
  end
end