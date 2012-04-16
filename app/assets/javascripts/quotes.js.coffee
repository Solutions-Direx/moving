# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@Quote = {}
@Quote.Form = 
  init: ->
    $("#quote-form .chzn").chosen()
    # $(".chzn-deselectable").chosen({allow_single_deselect: true})
    
    $('#quote_from_address_attributes_city').autocomplete
      source: $('#quote_from_address_attributes_city').data('autocomplete-source')
    
    # HANDLE CLIENT SELECT  
    clients = $('#clients').data('url')
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
      
  update_room_number: ->
    $('#quote-form .room:visible').each (index, room) ->
      $(room).find('.room-number').text("Room #{index + 1}")
      
  fill_client_info: (client) ->
    $('#quote_phone1').val(client.phone1)
    $('#quote_phone2').val(client.phone2)
    $('#quote_from_address_attributes_address_attributes_address').val(client.address.address)
    $('#quote_from_address_attributes_address_attributes_city').val(client.address.city)
    $('#quote_from_address_attributes_address_attributes_province').val(client.address.province)
    $('#quote_from_address_attributes_address_attributes_postal_code').val(client.address.postal_code)
    $('#quote_from_address_attributes_address_attributes_country').val(client.address.country)    
    