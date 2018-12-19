$ ->
  $('form#search').on 'submit',(e)->
    e.preventDefault()
    e.stopPropagation()
    # do some validation
    $.ajax {
        url:'/glossary/search'
        type:'POST'
        data: $(@).serialize()
        dataType:'json'
      }
    .done (json)->
      $h2 = $('<h4/>',{text:json.servertime})
      $ul = $('<ul/>')
      $4sp = '&nbsp;'.repeat 4
      for k,v of json.detail
        $ul.append '<li><h4>' + k + '</h4>' +  $4sp + v + '</li>'
      # component all.
      $('form#search').before $h2
      $('form#search').before $ul
    .fail (one,two,three)->console.log one;console.log two;console.log three
  
  # trigger
  $('button.glossary-delete').on 'click',(e)->
    e.preventDefault()
    e.stopPropagation()
    # trigger server side delete event. via ajax.
    triggerid = $(@).data('id')
    $button = $(@)
    $.ajax 
      url:'/glossary/delete'
      type:'POST'
      dataType:'json'
      data: {id: parseInt triggerid }
    .done (json)->
      $('#delete-response').append $('<h4/>',{text:json.status})
      # delete table-tr too.
      $button.parents('tr').remove() 
    .fail (one,two,three)->console.log one,two,three
