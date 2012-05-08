@Invoices = {}
@Invoices.Form =
  init: ->
    $(document).bind "idle.idleTimer", ->
      $('#edit-invoice').submit()

    idle_time = 30 # seconds
    $.idleTimer(1000 * idle_time)
    
    $("#edit-invoice .chzn").livequery ->
      $(this).chosen()
      
    $('#preview').click ->
      $('#submit-to-preview').trigger('click')
      return false
    