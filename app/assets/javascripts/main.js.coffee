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

  $(".client").each ->
    i = $(this)
    $(i).bind "mouseenter", ->
      i.popover(
        html: true
        animate: false
        placement: 'top'
        template: '<div class="popover" onmouseover="$(this).mouseleave(function() {$(this).hide(); });"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
        title: i.attr('data-original-title')
        content: "Loading"
      ).popover "show"
      $.ajax
        url: "/quotes/get_info/"
        data:
          quote_id: i.attr('data-qoute-id')
        dataType: "script"
        cache: false
        success: (response) ->
          popover = i.data('popover')
          content = '<p>' + JSON.parse(response)[0].removal_man + '</p>' +
          '<p>' + JSON.parse(response)[1].trucks +  '</p>' +
          '<p>' + '<a href=/quotes/' + i.attr('data-qoute-id') + " class='btn'>Voir</a></p>"
          popover.options.content = content
          i.popover "show"
  $('.phone').mask('(000) 000-0000 x ZZZ',{translation: {'Z': {pattern: /[0-9]/, optional: true}}})

