# dependies jq
# Usage: user-page include it by <script src="/path/to/this/file.js"),then in page javascript
# write: ... createModal $('body'),{options}
# now we have a '#myModal',at last:
# $('#myModal').show()
# funcBuffton be includes in options.
window.createModal = (parent,options)->
  titleText = options?.titleText or 'Default Title Of Modal Dialog'
  bodyText = options?.bodyText or 'Default content text.'
  # funcButton sample : $('<button />',{id:'hereisid',text:'here is label',type:'button',
  #   class='btn btn-default btn-md',data-dismiss='modal'})
  funcButton = options?.funcButton or undefined 

  # container>dialog>content
  # and
  # content=header+body+footer

  # outter container - class is .modal 
  container = $('<div/>'
    ,
      'class':'modal fade'
      'id': 'myModal'
      'tabindex':'-1'
      'role': 'dialog'
    )

  # dialog
  dialog = $('<div class="modal-dialog" role="document" />')

  # modal-content
  content = $('<div class="modal-content" />')

  # modal-header :create single components then assemble them for  header part
  header = $('<div class="modal-header" />')
  toprightclose = $('<button />'
    ,
      'class':'close'
      'data-dismiss': 'modal'
      'aria-label': 'Close'
      'html':'<span aria-hidden="true"> &times;</span>'
    )
  headerTitle = $('<h4/>'
    ,
      'class':'modal-title'
      'id': 'myModalLabel'
      'text': titleText
    )
  header.append toprightclose
  header.append headerTitle

  
  # body of dialog
  body = $('<div/>',{'class':'modal-body','text':bodyText})


  # footer of dialog contains:1) close button 2)dismissable,at last assembly them.
  # only while 'funcButton' is passed,and it is effiective,assemble it.
  footer = $('<div class="modal-footer" />')
  closeButton = $('<button/>'
    ,
      'class':'btn btn-default'
      'data-dismiss':'modal'
      'type':'button'
      'text':'Close'
    )
  footer.append closeButton
  if (funcButton isnt undefined ) and (funcButton[0].tagName is 'BUTTON') and (funcButton?.data) and (funcButton.data('dismiss') is 'modal')
    footer.append funcButton
 
  # at last, assemble all components.
  container.append dialog
  dialog.append content
  content.append header
  content.append body
  content.append footer
  # parent (always document.body) as HTML insert point.
  parent.append container
  null
