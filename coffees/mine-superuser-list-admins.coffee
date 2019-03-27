$ ->
  $('.remove').on 'click',(evt)->
    id = $(this).data('itemid')
    funcButton = $('<button/>',{'class':"btn btn-warning btn-md",type:"button",'data-dismiss':"modal",text:'Ensure For Deleting This Item',id:'iensure'}) 
    window.createModal($('body'),{titleText:'Do You Want To Delete One Item?',bodyText:'Click Ensure Will Execute Deleting.',boxid:'said','funcButton':funcButton}) 
    $('#said').modal() 
    $('#iensure').on 'click',(evt)->
      $.ajax {dataType:'json',url:'/superuser/del-admin?id=' + id,type:'PUT'}
      .done (json)->
        # use 'flash' skill,global func variable - createAlertBox()
        # is already included.
        window.createAlertBox $('body'),json.gala
      .fail (one,two,three)->
        window.createAlertBox $('body'),json.reason
