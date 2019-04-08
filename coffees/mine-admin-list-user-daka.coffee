$ ->
  # 2019 4 8
  $('table.table').on 'click','button.dakadetail',(evt)->
    detail = $(@).data 'detail'
    alert detail
