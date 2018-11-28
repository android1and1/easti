$ ->
  # client side
  # wrote it at J602
  # rewrote at 2018 11 27? today. after leaving zhongnan hospital
  # Port 1800

  chat = io.connect 'http://127.0.0.1:1800/chat'
  news = io.connect 'http://127.0.0.1:1800/news'
  news.on 'news',(data)->
    console.log 'received server give me a data:',data
    news.emit 'woot'
  chat.on 'connect',->
    console.log 'heard channel of chat'
    chat.emit 'hi!'
  null
