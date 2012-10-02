@Reports = {}
@Reports.Form =
  init: (invoice_hours) ->
    $(document).bind "idle.idleTimer", ->
      $('#edit-report').submit()
      
    idle_time = 30 # seconds
    $.idleTimer(1000 * idle_time)  
    
    $('#preview').click ->
      $('#submit-to-preview').trigger('click')
      return false

    date = new Date();
    d = date.getDate();
    m = date.getMonth();
    y = date.getFullYear();

    start_time = new Date(y, m, d, $('#report_start_time_hour').val(), $('#report_start_time_minute').val(), 0, 0);
    end_time = new Date(y, m, d, $('#report_end_time_hour').val(), $('#report_end_time_minute').val(), 0, 0);

    $('#report_start_time_hour').change ->
      start_time.setHours($(this).val())
      Reports.Form.checkTime(invoice_hours, start_time, end_time)

    $('#report_end_time_hour').change ->
      end_time.setHours($(this).val())
      Reports.Form.checkTime(invoice_hours, start_time, end_time)  

    $('#report_start_time_minute').change ->
      start_time.setMinutes($(this).val())
      Reports.Form.checkTime(invoice_hours, start_time, end_time)

    $('#report_end_time_minute').change ->
      end_time.setMinutes($(this).val())
      Reports.Form.checkTime(invoice_hours, start_time, end_time)  

  timeMinuteDifference: (endDate, startDate) ->
    difference = endDate.getTime() - startDate.getTime()
    return (Math.floor(difference/1000/60))

  checkTime: (hours, start_time, end_time) ->
    console.log Reports.Form.timeMinuteDifference(end_time, start_time)
    if hours && Reports.Form.timeMinuteDifference(end_time, start_time) != hours * 60
      alert(I18n.t('hour_not_match'))