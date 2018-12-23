$ ->
  $('button').one 'click',(evt)->
    evt.preventDefault()
    evt.stopPropagation()
    window.createModal $('body'),{
        boxid:'double-check-modal'
        titleText: 'Are You Sure To Purge This DB?'
        bodyText: '当按下确认按钮后，服务器将会永入性删除当前APP的底层数据，并无法恢复，是否要这 样做。是，请按ENSURE按钮，否，按CANCEL按钮。'
        funcButton : $('<button/>',{text:'ENSURE','data-dismiss':'modal',type:'button',id:'double-check-button',class:'btn btn-md btn-danger'})
      }

    $('#double-check-modal').modal()

    $('#double-check-button').on 'click',(e2)->
      $.ajax {
          url:'/neighborCar/purge-db'
          method:'DELETE'
          dataType:'text'
        }
      .done (text)->
        $msg = $('<div/>',{id:'youknow'})
        $('.jumbotron').before $msg
        window.createAlertBox $msg,text
      .fail (one,two,three)->
        console.log one,two,three
      return true
