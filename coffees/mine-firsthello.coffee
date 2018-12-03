$ ->
  socket = io.connect 'http://127.0.0.1:1118/'
  socket.on 'news',(data)->
    console.log 'Received:',data
    socket.emit 'my other event',{'client-status':'client is ok.'}
    socket.emit 'mynameis','Tobi Willamos',(data)->
      window.createModal $('body'),{titleText:data,bodyText:'when received this message box means your name is loging successfully.'}
      $('#myModal').modal() 
  socket.on 'message',(data)->
    console.log 'received server side message:' + data
  
