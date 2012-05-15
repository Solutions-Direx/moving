module ApplicationHelper
  
  def submit_or_cancel(form, submit_name = "", cancel_name="#{t 'cancel'}")
    unless submit_name.blank?
      form.submit(submit_name, :class => 'btn btn-primary') + " #{t 'or'} " + link_to(cancel_name, 'javascript:history.go(-1);', :class => 'cancel')
    else
      form.submit(:class => 'btn btn-primary') + " #{t 'or'} " + link_to(cancel_name, 'javascript:history.go(-1);', :class => 'cancel')
    end
  end
  
  def time_options
    minutes = ["00", "15", "30", "45"]
    ampm = ["AM", "PM"]
    options = []
    ampm.each do |ap|
      ([12] << (1..11).to_a).flatten.each do |hour|
        minutes.each do |min|
          options << "#{hour}:#{min} #{ap}"
        end
      end
    end
    options
  end
  
  def room_size_options
    options = []
    Room::SIZES.each do |size|
      options << [I18n.t(size), size]
    end
    options
  end
  
  def current_child_index(f, zero_based = true)
    index = f.object_name.gsub(/[^0-9]+/,'').to_i
    index += 1 unless zero_based
  end
  
  def section
    content_tag(:div, "", :class => 'section')
  end
  
  def body_class(klass)
    content_for(:body_class) { klass }
  end
  
  def locking_field_tag(form)
    can_lock = form.object.respond_to?(:locking_enabled?) && form.object.locking_enabled? && !form.object.new_record?
    form.hidden_field(form.object.class.locking_column) if can_lock
  end
  
end
