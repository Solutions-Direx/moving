@Quote = {}
@Quote.Form = 
  init: (client) ->
    $("#quote-form .chzn").chosen()
    # $(".chzn-deselectable").chosen({allow_single_deselect: true})
    
    $('#quote_from_address_attributes_city').autocomplete
      source: $('#quote_from_address_attributes_city').data('autocomplete-source')
    
    # HANDLE CLIENT SELECT
    if client
      Quote.Form.fill_client_info(client)
      
    $('#select-clients').chosen().change ->
      $.getJSON "/clients/#{$(this).val()}.json", (client) ->
        Quote.Form.fill_client_info(client)
    
    $('#select-clients').on "client:added", (e) ->
      $("#select-clients").trigger("liszt:updated")
      Quote.Form.fill_client_info(e.client)
    
    $('#quote-form').on "nested:fieldAdded:rooms", (e) =>
      this.update_room_number()
    
    $('#quote-form').on "nested:fieldRemoved", (e) =>
      this.update_room_number()
    
    $('#quote-form').on "nested:fieldAdded:quote_supplies", (e) ->
      $(e.field).find(".chzn").chosen()
    
    AddressWidget.init()
    
    # RATING
    $('.rating').click ->
      $('#quote_rating').val($(this).text())
      
    $('#quote_pm').click ->
      if $(this).is(":checked")
        $('#removal_at_comment').slideDown()
      else
        $('#removal_at_comment').slideUp()
        
    $('.internal_link').click ->
      # is internal
      if $('#quote_internal_address').val() == '0'
        $('#quote_internal_address').val('1')
        $('.to').hide()
        $(this).text('not internal')
      else
        $('#quote_internal_address').val('0')
        $('.to').show()
        $(this).text('internal')
      return false  
      
  update_room_number: ->
    $('#quote-form .room:visible').each (index, room) ->
      $(room).find('.room-number').text("Room #{index + 1}")
      
  fill_client_info: (client) ->
    if client.commercial
      $('#quote_contact').closest('.control-group').slideDown()
    else
      $('#quote_contact').closest('.control-group').slideUp()
    $('#quote_phone1').val(client.phone1)
    $('#quote_phone2').val(client.phone2)
    $('#quote_from_address_attributes_address_attributes_address').val(client.address.address)
    $('#quote_from_address_attributes_address_attributes_city').val(client.address.city)
    $('#quote_from_address_attributes_address_attributes_province').val(client.address.province)
    $('#quote_from_address_attributes_address_attributes_postal_code').val(client.address.postal_code)
    $('#quote_from_address_attributes_address_attributes_country').val(client.address.country)    
    
@Quote.Terms = 
  init: ->
    # signatepad
    $('.sigPad').signaturePad({drawOnly:true, lineTop: 120})
    
    # submit signature
    $('#submit-quote').click ->
      $('#frm-quote').submit()
      return false
    
    # document flows
    $('.mark-read').click ->
      $document = $(this).closest('.document')
      if $(this).is(":checked")
        if $document.hasClass('last')
          $document.find('.approve').show()
        else
          $document.find('.next').removeClass("disabled")
      else
        $document.find('.next').addClass("disabled")
        $document.find('.approve').hide()
        
    $('.next').click ->
      $document = $(this).closest('.document')    
      $check_box = $document.find('.mark-read')
      if $check_box.is(":checked")
        $next_document = $document.next()
        $next_document.show()
        $document.hide()
        if $next_document.hasClass("last")
          $next_document.find('.next').hide()
        return false
      else
        return false
    