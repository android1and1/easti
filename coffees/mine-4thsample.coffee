$ ->
  chat = io.connect 'http://127.0.0.1:8111/chat'
  chat.on 'connect',->
    chat.emit 'user.register','Wang Yong'
  chat.on 'user.registered',(msg)->
    alert msg

  chat.on 'message',(msg)->
    $('ul#box').append '<li>' + msg + '</li>'

  $('#onlyform').on 'submit',(evt)->
    evt.preventDefault()
    evt.stopPropagation()
    # towho,youtoo
    $towho = $('#towho').val()
    $youtoo = $('#youtoo').val()
    chat.emit 'private message',$towho,$youtoo
    
