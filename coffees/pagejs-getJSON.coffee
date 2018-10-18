$ ->
  # define a helpful func  - it returns promise.
  get4jsons = (urls)->
     promises = urls.map (url)->getJSON url
     thelastone = Promise.all promises
     thelastone.then (jsons)->
       for json in jsons
         try
           obj = JSON.parse json
           for i,v of obj
             dt = $('<dt/>',{text:i})
             dd = $('<dd/>',{text:' ' + v})
             $('dl#one').append dt
             $('dl#one').append dd
         catch err
           console.dir json 
           console.error err.msg
   
     .catch (err)->
       alert err
  getJSON = (url)->
    promise = new Promise (resolve,reject)->
      xhr = new XMLHttpRequest
      xhr.responseType = 'json'
      xhr.timeout = 2000 #2s
      xhr.onloadend = (evt)->
        resolve evt.target.response
      xhr.onerror = (error)->
        reject error
      
      xhr.open 'POST',url,true
      xhr.send null
    return promise  #getJSON() define end.

  $('#ajaxbutton').on 'click',(evt)->
    get4jsons [ 
      '/alpha/server-side-data/1' 
      '/alpha/server-side-data/2' 
      '/alpha/server-side-data/3' 
      # below is not exists - "da5.json"
      '/alpha/server-side-data/5' 
      ]
