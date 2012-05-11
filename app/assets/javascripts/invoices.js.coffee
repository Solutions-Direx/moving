@Invoices = {}
@Invoices.Form =
  init: ->
    $(document).bind "idle.idleTimer", ->
      $('#edit-invoice').submit()

    idle_time = 30 # seconds
    $.idleTimer(1000 * idle_time)
    
    $("#edit-invoice .supply").livequery ->
      $(this).chosen().change ->
        Invoices.Form.calculate_grand_total()
    
    $("#edit-invoice .supply-qty").livequery ->
      $(this).change ->
        Invoices.Form.calculate_grand_total()        
        
    $('#edit-invoice').on "nested:fieldRemoved", ->
      Invoices.Form.calculate_grand_total()
    
    $("#edit-invoice #forfaits").livequery ->
      $(this).chosen().change ->
        Invoices.Form.calculate_grand_total()
      
    $('#preview').click ->
      $('#submit-to-preview').trigger('click')
      return false
      
    $('#invoice_time_spent, #invoice_rate, #invoice_gas, #invoice_overtime, #invoice_overtime_rate').live 'change', ->
      Invoices.Form.calculate_grand_total()
      
  calculate_grand_total: ->
    # time spent
    time_spent = Invoices.Form.to_f($('#invoice_time_spent').val())
    rate = Invoices.Form.to_f($('#invoice_rate').val())
    total_time_spent = Invoices.Form.roundup(time_spent * rate)
    
    gas = Invoices.Form.to_f($('#invoice_gas').val())
    
    # overtime
    overtime = Invoices.Form.to_f($('#invoice_overtime').val())
    overtime_rate = Invoices.Form.to_f($('#invoice_overtime_rate').val())
    total_overtime = Invoices.Form.roundup(overtime * overtime_rate)
    
    # supplies
    supply_list = $('#supply-list').data('supplies')
    total_supplies = 0
    $.each $('#supply-list .supply-item:visible'), (index, item) ->
      supply_id = $(item).find('.supply').val()
      qty = $(item).find('.supply-qty').val()
      qty = 0 if qty == null || qty == ""
      $.each supply_list, (idx, obj) ->
        if parseInt(obj.id) == parseInt(supply_id)
          total_supplies = total_supplies + (parseFloat(obj.price) * qty)
    
    # forfaits
    forfait_list = $('#forfaits').data('forfaits')
    total_forfaits = 0
    if $('#forfaits').val()
      $.each $('#forfaits').val(), (index, forfait_id) ->
        $.each forfait_list, (idx, obj) ->
          if parseInt(obj.id) == parseInt(forfait_id)
            total_forfaits = total_forfaits + parseFloat(obj.price)
    
    # grand total      
    grand_total = total_time_spent + gas + total_overtime + Invoices.Form.roundup(total_forfaits) + Invoices.Form.roundup(total_supplies)
    $('#grand-total').text(Invoices.Form.roundup(grand_total))
    
  roundup: (value) ->  
    Math.round(value * 100) / 100
  
  to_f: (value) ->
    val = parseFloat(value)
    val = 0 if isNaN(val) || val < 0 
    return val
    