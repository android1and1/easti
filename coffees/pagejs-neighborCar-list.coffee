# 2019-1-8
$ ->
  $('#search-form').on 'submit',(evt)->
    keyword = $('[name=keyword-for]:checked').val()
    alert 'your choice:' + keyword
    $(@).attr 'action','/neighborCar/' + keyword
     
    # evt.preventDefault()
    # evt.stopPropagation()
