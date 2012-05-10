@Reports = {}
@Reports.Form =
  init: ->
    $(document).bind "idle.idleTimer", ->
      $('#edit-report').submit()
      
    idle_time = 30 # seconds
    $.idleTimer(1000 * idle_time)  
    
    $('#preview').click ->
      $('#submit-to-preview').trigger('click')
      return false
