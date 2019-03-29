$ ->
  $('.deletebutton').on 'click',(e)->
    thisbutton = @
    id = $(@).data 'userid'
    # give a chance for ensure.
    funcButton = $('<button/>',{'id':'deleteensure','class':'btn btn-danger btn-md','text':'yes,i am sure','data-dismiss':'modal'})
    window.createModal $('body'),{'boxid':'ensurefordelete','funcButton':funcButton,'titleText':'Are You Sure To Delete This Account?','bodyText':'Becareful do that,if any doubt,click "Cancel" button.'}
    $('#ensurefordelete').modal()
    $('#deleteensure').on 'click',(e)->  
      # really do ajax.
      $.ajax
        url:'/admin/del-user'
        type:'PUT'
        dataType:'json'
        data:{id:id}
      .done (json)->
        if json.code is 0
          # destory this item from html.
          $panel = $(thisbutton).closest('.panel.panel-default')
          $panel.remove()
        else
          # create an alert-box.
          boxcontent = 'delete failure.reason:' + json.reason
          $panel = $(thisbutton).closest('.panel.panel-default')
          $div = $('<div/>')
          $panel.before $div
          window.createAlertBox $div,boxcontent
  
  $('.disablebutton').on 'click',(e)->
    thisbutton =  @
    id = $(@).data 'userid'
    # give a chance for ensure.
    funcButton = $('<button/>',{'id':'disableensure','class':'btn btn-danger btn-md','text':'yes,i am sure','data-dismiss':'modal'})
    window.createModal $('body'),{'boxid':'ensurefordisable','funcButton':funcButton,'titleText':'Are You Sure To Disable This Account?','bodyText':'after disable,user cannot access its account till admin enable it.'}
    $('#ensurefordisable').modal()
    $('#disableensure').on 'click',(e)->  
      # really do ajax.
      $.ajax
        url:'/admin/disable-user'
        type:'POST'
        dataType:'json'
        data:{id:id}
      .done (json)->
        if json.code is 0
          $(thisbutton).attr 'disabled','1'
          # remember this:button 'disable' first,next is 'enable'
          $(thisbutton).next().removeAttr 'disabled'
          # also,the h3.isActive text need change.
          # $('h3.isActive') is $(thisbutton) parent - '.btn-group' sibling,it is be found via below jQuery travel method.
          target = $(thisbutton).closest('.btn-group').prevAll().filter('.isActive').html('<small>isActive </small> false')
        else
          console.log json.code
          console.log json.reason 
      .fail (one,two,three)->
        console.log 'status code:',two
  $('.enablebutton').on 'click',(e)->
    thisbutton =  @
    id = $(@).data 'userid'
    # give a chance for ensure.
    funcButton = $('<button/>',{'id':'enableensure','class':'btn btn-danger btn-md','text':'yes,i am sure','data-dismiss':'modal'})
    window.createModal $('body'),{'boxid':'ensureforenable','funcButton':funcButton,'titleText':'Are You Sure To Enable This Account?','bodyText':'after executing,user can access its account till admin disable it.'}
    
    $('#ensureforenable').modal()
    # really do ajax.
    $('#enableensure').on 'click',(e)->  
      $.ajax
        url:'/admin/enable-user'
        type:'POST'
        dataType:'json'
        data:{id:id}
      .done (json)->
        if json.code is 0
          $(thisbutton).attr 'disabled','1'
          $(thisbutton).prev().removeAttr 'disabled'       
          $(thisbutton).closest('.btn-group').prevAll().filter('.isActive').html('<small>isActive </small> true')
        else
          console.log json.code
          console.log json.reason 
      .fail (one,two,three)->
        console.log 'status code:',two
