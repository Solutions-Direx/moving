# common js runner
$ ->
  $(document).controls()
  
  $('.modal #close').click ->
    $('#modal-form').modal('hide')
    return false
  
  $('.modal #submit-form').click ->
    $('#modal-form').find('form').submit()
    return false  
  
  loc = $("meta[name='locale']").attr("content")
  
  if loc == "fr"
    $('.datepicker').each ->
      $(this).datepicker($.extend($.datepicker.regional["fr"], {altFormat: "yy/mm/dd", altField: $(this).next()}))
  else  
    $('.datepicker').each ->
      $(this).datepicker($.extend($.datepicker.regional["en-GB"], {altFormat: "yy/mm/dd", altField: $(this).next()}))

  $('.clear').click -> 
    $(this).closest('.input-append').find('input').val('')
