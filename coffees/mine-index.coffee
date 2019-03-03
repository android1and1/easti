$ ->
  # 2019-3-3,at Petit Paris.
  $login = $('button#login')
  $logout = $('button#logout')
  $logout.on 'click',(e)->
    $.ajax 
      url:'/user/logout'
      method:'PUT'
      responseType:'json'
    .done (json)->
      alert json.status 
    .fail (one,two,three)->
      console.log two
      console.log three
