$ ->
  if io is undefined
    alert 'ni wei shen me zhe me hao kan!'
  else
    socket = io()
    socket.on 'message',(msg)->
      alert 'Heard From Server Side: [' + msg + ' ].'

