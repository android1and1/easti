$ ->
  $('button#commit').on 'click',(e)->
    xhr = new XMLHttpRequest
    xhr.open 'POST','/play-version-xhr2'
    xhr.responseType = 'json'
    xhr.onload = (e)->
      json = @response
      console.log 'Server Said',json
      for a of json
        alert a + ':' + json[a]
    # collect data
    fd = new FormData
    dataArray = $('form').serializeArray()
    for peer in dataArray
      console.log peer.name,peer.value
      fd.append peer.name,peer.value
    xhr.send fd 

