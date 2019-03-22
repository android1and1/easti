$ ->
  $('button#commit').on 'click',(e)->
    # xhr2 + formData + [key:[]] structor
    # the structor be found in zhongnan hospitol 2019-3-22 evening while
    # A-Pin is ill
    xhr = new XMLHttpRequest
    xhr.open 'POST','/play-version-xhr2'
    xhr.responseType = 'json'
    xhr.onloadend = (e)->
      json = @response
      console.log 'Server Said',json
      for a of json
        alert a + ':' + json[a]
    # collect data
    fd = new FormData
    dataArray = $('form').serializeArray()
    fields = {} 
    for peer in dataArray
      name = peer.name
      value = peer.value
      if name not in Object.keys(fields)
        fields[name] = []
      fields[name].push value
    for n of fields 
      fd.append n,fields[n]
    xhr.send fd 

