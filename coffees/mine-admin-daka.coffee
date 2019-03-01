$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  if io
    socket = io('/admin')
    socket.on 'message',(msg)->
      alert 'Headed From ChannelAdmin - ' + msg

