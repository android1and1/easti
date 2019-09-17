$ ->
  # 2019-09-17 wed
  # filename(pagejs) - public/pagejs-admin-full-tickets.js
  # template - views/admin-full-tickets.pug
  # route - '/admin/admin-full-tickets' 
  $('.cursor').on 'click',(e)->
    # offen,treat 'e' as '@',make many mistakes.
    next = $(@).data('next')
    e.preventDefault()
    e.stopPropagation()
    $.ajax {
        url:'/admin/full-tickets'
        dataType:'json'
        type:'POST'
        data:{'nextCursor':next}
    }   
    .done (json)->
      #alert JSON.stringify(json)
      _display $('#json'),json
    .fail (one,two,three)->
      alert three + ' reason: ' + one.message

  _display = (box,structor)->
    next = structor.next
    box.append '<hr/>'
    box.append '<h2 class="display-3"> next cursor is:' + next + '</h2>'
    for d in structor.items 
      $ul = $ '<ul/>'
      $ul.append '<li>#'+ d.ticket_id + '</li>'
      $ul.append '<li>title:<a alt="detail page" href="/admin/get-ticket-by-id/' + d.ticket_id + '">' + d.title + '</a></li>' 
      $ul.append '<li>visits:' + d.visits + '</li>' 
      box.append $ul 
    if next isnt '0'
      box.append '<a role="button" class="cursor btn btn-primary" data-next="'+ next + '" > More+ </button>'
    
