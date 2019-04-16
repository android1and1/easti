$ ->
  # user alias name can get from ol#box element's data-alias attribute 
  # what is socket? 
  # in this page,'user' is a really socket,from it,and to it,message or object be transfered.
  # at server side,has 2 main roles,one is namespace(always confuze with socket),and two is socket.
  $box = $('ol#box')
  alias = $('h1[data-alias]').data 'alias'
  user = io('/user')
  user.on 'connect',()->
    $box.append $ '<li/>',{text: 'client joined socketio,id=' + user.id }
  user.on 'message',(msg)->
    $box.append $ '<li/>',{text:'[Event:message]' + msg }
  user.on 'qr ready',(msg)->
    $box.append $ '<li/>',{text:'[Event:qr ready]' + msg} 
  user.on 'no admin',->
    $box.append $ '<li/>',{text:'No Admin Currently,Need Active It First'}
  user.on 'show form',->
    $li = $('<li/>')
    # create a form dynimacally
    $form = $('<form/>',{'class':'form-inline','action':'/user/daka-response','method':'POST'})
    modeValue = ''
    entry_attr = $('button#entry').attr 'disabled'
    exit_attr = $('button#exit').attr 'disabled' 
    if entry_attr
      modeValue = 'exit' 
    else
      modeValue = 'entry'
      
    $inputmode = $('<input/>',{'class':'hidden','name':'mode','value':modeValue})
    $inputcheckwords = $('<input/>',{'placeholder':'i seen the words is','class':'form-control','name':'check'})
    $submitbutton = $('<button/>',{text:'DaKa!','class':'btn btn-default'}) 

    $form.append $inputcheckwords
    $form.append $inputmode
    $form.append $submitbutton
    $li.append $form
    $box.append $li
    $box.append $('<li/>',{text:'Debug item: value of input element is:' + modeValue})

  ['entry','exit'].forEach (v)->
    elename = 'button#' + v
    $(elename).on 'click',(e)->
      # add 'v' as the 3rd argument,will invokes at route '/user/daka'
      user.emit 'query qr',user.id,alias,v
