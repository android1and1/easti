$ ->
  formData = new FormData
  # init form data
  $('input.car_field').each (ind,ele)->
    # ele = this = @
    formData.set $(@).attr('name'),$(@).val()

  .on 'change',(evt)->
    formData.set $(@).attr('name'),$(@).val()

  $('.nav.nav-tabs a').on 'click',(e)->
    e.preventDefault()
    $(@).tab 'show'
  $('.nav.nav-tabs a').eq(0).tab 'show'

  $('#commit').on 'click',(e)->
    iterator = formData.entries()
    while (entry = iterator.next()) && !entry.done
      alert entry.value
