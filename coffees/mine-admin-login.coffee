$ ->
  $('form').on 'submit',(e)->
    if $('input[name=alias]').val().length is 0 or $('input[name=password]').val().length is 0
        alert 'should not be empty.'
        e.preventDefault()
        e.stopPropagation()
       
