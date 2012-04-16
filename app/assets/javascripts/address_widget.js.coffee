@AddressWidget =
  init: ->
    
    # SELECT STORAGE CLICK HANDLER
    # ----------------------------
    $('#addresses').on 'click', '.select-storage', ->
      widget = $(this).closest('.address-widget')
      
      # toggle controls
      $(this).removeClass('show').addClass('hide')
      widget.find('.enter-address').removeClass('hide').addClass('show')
      
      # toggle fields
      widget.find('.to-address').removeClass('show').addClass('hide')#.find('input, select').val('')
      widget.find('.storage-field').removeClass('hide').addClass('show')
      return false
    
    # ENTER ADDRESS CLICK HANDLER
    # ----------------------------
    $('#addresses').on 'click', '.enter-address', ->
      widget = $(this).closest('.address-widget')
      
      # toggle controls
      $(this).removeClass('show').addClass('hide')
      widget.find('.select-storage').removeClass('hide').addClass('show')
      
      # toggle fields
      widget.find('.to-address').removeClass('hide').addClass('show')
      widget.find('.storage-field').removeClass('show').addClass('hide').find('select').val('')
      return false
      
