$ ->
  # client side
  # wrote it at J602
  # Not Works Smoothly. 
  chat = io.connect 'http://127.0.0.1:8888/chat'
  news = io.connect 'http://127.0.0.1:8888/news'
  news.on 'connect',->
    console.log 'heard channel of news'
  news.on 'news',(data)->
    console.log 'received server give me a data:',data
    news.emit 'woot'
  chat.on 'connect',->
    console.log 'heard channel of chat'
    chat.emit 'hi!'
  null
