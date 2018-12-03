$ ->
  # learn socket.io -- lesson2:websocket send,broadcast.
  socket = io()
  socket.on 'message',(msg)->
    $('#messages').append '<div class="well">' + (msg.replace '\n','<br>') + '</div>' 
  $('form').on 'submit',(evt)->
    evt.preventDefault()
    message = $('#message').val() 
    $('#message').val ''
    socket.send message
