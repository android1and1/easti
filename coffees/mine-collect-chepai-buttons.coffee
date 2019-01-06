$ ->
  $('button').on 'click',(evt)->
    if not $(@).hasClass('yesido')
      alert 'your input is ' + evt.target.value
      evt.preventDefault()
      evt.stopPropagation()
  $('a[type=button]').on 'click',(evt)->
    alert 'link of ' + $(@).text()
