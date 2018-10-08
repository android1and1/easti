$ ->
  # version1 is default.
  if ! window.indexedDB
    alert 'Your Browser Dont Support Html5-IndexedDB functionation.'
  else
    idb = window.indexedDB
    obj = 
      name:'testone'
      version:6
      db:null

    #request = idb.open obj.name,obj.version
    request = idb.open obj.name
    request.onupgradeneeded = (evt)->
      obj.db = @result
      console.log 'on upgrade needed event triggered.'
    request.onerror = (evt)->

      #console.error 'got error,code:',request.errorCode 
      console.error 'got error,code:',@errorCode 
  
    request.onsuccess=(evt)->
      #obj.db = evt.target.result
      #obj.db = request.result
      #obj.db = @result
      console.log 'on sucess event triggered.'
    setTimeout ()->
        obj.db.close()
        idb.deleteDatabase obj.name
        console.log 'bye.'
      ,
      1000
