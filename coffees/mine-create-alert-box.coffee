window.createAlertBox = (parent,alertContent)->
  container = $('<div/>',{'class':'alert alert-warning'}) 
  buttonPart = $('<button/>',{"type":"button","class":"close","data-dismiss":"alert"})
  h4Part = $('<h4/>',{text:alertContent})
  container.append buttonPart
  buttonPart.append $('<span aria-hidden="true"> &times;</span>')
  container.append h4Part
  parent.append container
  null

