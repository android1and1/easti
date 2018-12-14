$ ->
  $('textarea').on 'click',(evt)->
    $(this).val $(this).data('old')
  $('form').on 'submit',(evt)->
    evt.preventDefault()
    evt.stopPropagation()
    alert $(evt.target).serialize()
     
