$ ->
  $('form').on 'submit',(e)->
    $('input').each (index,ele)->
      if $(ele).val().length is 0
        alert 'should not be empty.'
        e.preventDefault()
        e.stopPropagation()
       
