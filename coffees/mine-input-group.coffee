$ ->
  $('button').on 'click',(e)->
    old = $('#license-plate-number').val()
    butval = $(@).data('mean')
    $('#license-plate-number').val(old + butval)
    
     
