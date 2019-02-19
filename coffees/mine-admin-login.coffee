$ ->
  admin = io('/admin')
  admin.on 'connect',->
    alert 'connected.'
  admin.on 'message',(msg)->
    alert 'Server Said:' + msg
