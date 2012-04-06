module ApplicationHelper
  
  def submit_or_cancel(form, submit_name = "", cancel_name='Cancel')
    unless submit_name.blank?
      form.submit(submit_name, :class => 'btn btn-primary') + " or " + link_to(cancel_name, 'javascript:history.go(-1);', :class => 'cancel')
    else
      form.submit(:class => 'btn btn-primary') + " or " + link_to(cancel_name, 'javascript:history.go(-1);', :class => 'cancel')
    end
  end
  
end
