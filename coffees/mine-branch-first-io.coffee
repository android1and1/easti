$ ->
  socket = io()
  socket.on 'message',(msg)->
    $('div#messagebox').append '<u>Server Send:' + msg + '</u>'
  socket.on 'connect',->
    $('div#messagebox').append '<p>hi,socket connected.</p>'
  socket.on 'dare',(msg)->
    alert 'server said:' + msg
  $('button#trigger').on 'click',(e)->
    socket.emit 'wow','you are beautiful.'
    e.stopPropagation()
