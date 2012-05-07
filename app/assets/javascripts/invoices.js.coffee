@Invoices = {}
@Invoices.Form =
  init: ->
    $(document).bind "idle.idleTimer", ->
      $('#edit-invoice').submit()

    idle_time = 30 # seconds
    $.idleTimer(1000 * idle_time)
    
    $("#edit-invoice .supply").livequery ->
      $(this).chosen()
    