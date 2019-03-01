$ ->
  $('form').on 'submit',(e)->
    alert 'referrer is:' + window.document.referrer 
    $('input.hide').val '/' 
    $('input').each (index,ele)->
      if $(ele).val().length is 0
        alert 'should not be empty.'
        e.preventDefault()
        e.stopPropagation()
       
