$ ->
  # be compiled,then put into url: /pagejs/readingjournals/pagejs-readingjournals-index.js
  $('button.nohm-delete').on 'click',(evt)->
    deleteButton = $(@)
    itemid=$(evt.target).data('itemid')
    postbuttonid = 'postButton' + itemid
    postButton = $('<button/>',{'data-dismiss':'modal','class':'btn btn-danger','text':'Delete','id':postbuttonid})
    titleText = 'Are You Sure For Delete One Item?' 
    bodyText = 'click delete button will purge data forever,if you want to cancel this execute,you can click cancel or close button on the right side.'
    createModal $('#modalBox')
      ,
        funcButton:postButton
        titleText:titleText
        bodyText:bodyText
    # i remember,below .on is my first use bootstrap suit's event.
    $('#myModal').on 'hidden.bs.modal',(e)->
      $(@).remove()
    $('#myModal').modal()
    $('#'+ postbuttonid).on 'click',(evt)->
      $.ajax 
        url:'/reading-journals/delete/' + itemid 
        type:'POST'
        dataType:'json'
      .done (json)->
        $('#log').append $('<h4/>',{text:'Response of execute deleting of item id:' + itemid})
        $('#log').append $('<p/>',{text:k+':'+v}) for k,v of json 
        $('#log').append $('<br/>')
        deleteButton.attr 'disabled','disabled'
        deleteButton.button 'deleted'
       
