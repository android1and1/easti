$ ->
  $('button#commit').on 'click',(e)->
    xhr = new XMLHttpRequest
    xhr.open 'POST','/play-version-xhr2'
    xhr.responseType = 'text'
    xhr.onloadend = (e)->
      text = $(@).response
      alert text

    # collect data
    dataArray = $('form').serializeArray()
    xhr.send 'nihao' 

