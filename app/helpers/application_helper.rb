module ApplicationHelper
  
  def submit_or_cancel(form, submit_name = "", cancel_name='Cancel')
    unless submit_name.blank?
      form.submit(submit_name, :class => 'btn btn-primary') + " or " + link_to(cancel_name, 'javascript:history.go(-1);', :class => 'cancel')
    else
      form.submit(:class => 'btn btn-primary') + " or " + link_to(cancel_name, 'javascript:history.go(-1);', :class => 'cancel')
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
  
  def current_child_index(f, zero_based = true)
    index = f.object_name.gsub(/[^0-9]+/,'').to_i
    index += 1 unless zero_based
  end
  
end
