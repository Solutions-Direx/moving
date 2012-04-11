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
    
    # TOGGLE ADDRESS 1
    $('#select-storage').click ->
      $('#to-address1').hide()
      $('#storage-field').show()
      $(this).hide()
      $('#remove-storage').show()
      # hide holder
      $('#remove-address2').click()
      $('#holder').hide()
      $('#to-address1').find('input, select').val('')
      return false
    
    $('#remove-storage').click ->
      $('#to-address1').show()
      $('#storage-field').hide()
      # console.log $('#storage-field .search-choice-close')
      $('#storage-field select').val('')
      $('#storage-field select').trigger("liszt:updated")
      $('#storage-field .search-choice-close').remove()
      $('#storage-field .chzn-single').addClass('chzn-default')
      $(this).hide()
      $('#select-storage').show()
      $('#holder').show()
      return false  
    
    # TOGGLE ADDRESS 2    
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
    