$ ->
  $('textarea').one 'click',(evt)->
    $(this).val $(this).data('old')

  $('form').on 'submit',(evt)->
    $('.required').each (ind,ele)->
      if $(ele).val().length is 0
        
        alert 'textarea is empty.'
        evt.preventDefault()
        evt.stopPropagation()
      else
        true
