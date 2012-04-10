# common js runner
$ ->
  $(document).controls()
  
  $('.modal #close').click ->
    $('#modal-form').modal('hide')
    return false
  
  $('.modal #submit-form').click ->
    $('#modal-form').find('form').submit()
    return false  
    
  $('.datepicker').datepicker()
  
  $('.datepicker.include_time').datepicker().on 'changeDate', (e) ->
    $(e.target).nextAll(":hidden").each (idx, el) ->
      switch idx
        when 0 then $(el).val(e.date.getFullYear())
        when 1 then $(el).val(e.date.getMonth() + 1)
        when 2 then $(el).val(e.date.getDate())