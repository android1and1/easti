# 2019-1-14
# depends jQuery
# function arguments:
# parent is the container (jQuery obj) of new create html elements
# the 'id' is bootstrap suit 'tabs' id,
# opts example 
# {
#   'salary': '<input type="number" defaultValue="10000" id="salary" name="salary">'
# } 
# so,in the function inner,'for k,v of opts',k means field-name,v means <input> element(string)
window.neighborCarTabs = (parent,id,opts) ->
  $tabs = $('<ul/>',{'class':'nav nav-tabs','id':id})
  $divs = $('<div/>',{'class':'tab-content'})
  for k,v of opts
    $tabs.append '<li><a href="#' + k + '">' + k   + '</a></li>'
    $divs.append '<div class="tab-pane" id="' + k + '"><label>' + k + '</label>' + v
  parent.append $tabs
  parent.append $divs
  # initial nav-tabs
  $tabs.find 'li a:first'
  .tab 'show'
  $tabs.find 'li a'
  .on 'click',(evt)->
    $(@).tab 'show'
  null 
