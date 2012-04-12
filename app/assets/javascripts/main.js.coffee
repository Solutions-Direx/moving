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