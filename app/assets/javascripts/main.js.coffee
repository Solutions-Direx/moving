# common js runner
$ ->
  $(document).controls()
  
  $('.modal #close').click ->
    $('#modal-form').modal('hide')
    return false
  
  $('.modal #submit-form').click ->
    $('#modal-form').find('form').submit()
    return false  
  
  locale = <%= I18n.locale.to_s %>
  if locale == "fr"
    $('.datepicker').each ->
      $(this).datepicker($.extend($.datepicker.regional["fr"], {altFormat: "yy/mm/dd", altField: $(this).next()}))
  else  
    $('.datepicker').each ->
      $(this).datepicker($.extend($.datepicker.regional["en-GB"], {altFormat: "yy/mm/dd", altField: $(this).next()}))
