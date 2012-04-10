# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@Quote = {}
@Quote.Form = 
  init: ->
    $(".chzn").chosen()
    $(".chzn-deselectable").chosen({allow_single_deselect: true})
    
    $('#quote_from_address_attributes_city').autocomplete
      source: $('#quote_from_address_attributes_city').data('autocomplete-source')
    
    # handle client select  
    clients = $('#clients').data('url')
    $('#quote_client_id').chosen().change ->
      $.getJSON "/clients/#{$(this).val()}.json", (client) ->
        $('#quote_phone1').val(client.phone1)
        $('#quote_phone2').val(client.phone2)
        $('#quote_from_address_attributes_address_attributes_address').val(client.address.address)
        $('#quote_from_address_attributes_address_attributes_city').val(client.address.city)
        $('#quote_from_address_attributes_address_attributes_province').val(client.address.province)
        $('#quote_from_address_attributes_address_attributes_postal_code').val(client.address.postal_code)
        $('#quote_from_address_attributes_address_attributes_country').val(client.address.country)
        
    $('#quote-form').bind "nested:fieldAdded:rooms", (e) =>
      this.update_room_number()
      
    $('#quote-form').bind "nested:fieldRemoved", (e) =>
      this.update_room_number()
      
    $('#holder').click ->
      if $('#add-address2').is(":visible")
        $('#add-address2').click()
      
    $('#add-address2').click ->
      $('#holder').removeClass('holder').addClass('well')
      $('#to-address2').show()
      $(this).hide()
      return false
    
    $('#remove-address2').click ->
      $('#holder').removeClass('well').addClass('holder')
      $('#to-address2').hide()
      $('#add-address2').css('display', 'block')
      $('#to-address2').find('input, select').val('')
      return false
      
      
  update_room_number: ->
    $('#quote-form .room:visible').each (index, room) ->
      $(room).find('.room-number').text("Room #{index + 1}")
    