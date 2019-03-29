$ ->
  $('.disablebutton').on 'click',(e)->
    thisbutton =  @
    id = $(@).data 'userid'
    # give a chance for ensure.
    button = $('<button/>',{'id':'clickensure','class':'btn btn-danger btn-md','text':'Clike To Disable This Account','data-dismiss':'modal'})
    window.createModal $('body'),{'boxid':'ensurefordisable','funcButton':button,'titleText':'Are You Sure To Disable This Account?','bodyText':'after disable,user cannot access its account till admin enable it.'}
    
    $('#ensurefordisable').modal()
    # really do ajax.
    $('#clickensure').on 'click',(e)->  
      $.ajax
        url:'/admin/disable-user'
        type:'POST'
        dataType:'json'
        data:{id:id}
      .done (json)->
        if json.code is 0
          # button give a animal-action. 
          $(thisbutton).hide('slow')
      .fail (one,two,three)->
        console.log 'status code:',two
