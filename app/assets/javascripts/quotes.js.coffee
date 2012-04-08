# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@Quote = {}
@Quote.Form = 
  init: ->
    $(".chzn").chosen()
    $('#quote_from_address_attributes_city').autocomplete
      source: $('#quote_from_address_attributes_city').data('autocomplete-source')
    
    # handle client select  
    clients = $('#clients').data('url')
    $('#quote_client_id').chosen().change ->
      $.getJSON "/clients/#{$(this).val()}.json", (client) ->
        $('#quote_phone1').val(client.phone1)
        $('#quote_phone2').val(client.phone2)
        $('#quote_from_address_attributes_address').val(client.address.address)
        $('#quote_from_address_attributes_city').val(client.address.city)
        $('#quote_from_address_attributes_province').val(client.address.province)
        $('#quote_from_address_attributes_postal_code').val(client.address.postal_code)
        $('#quote_from_address_attributes_country').val(client.address.country)
        
    $('#quote-form').bind "nested:fieldAdded:rooms", (e) =>
      this.update_room_number()
      
    $('#quote-form').bind "nested:fieldRemoved", (e) =>
      this.update_room_number()  
      
  update_room_number: ->
    $('#quote-form .room:visible').each (index, room) ->
      $(room).find('.room-number').text("Room #{index + 1}")
    