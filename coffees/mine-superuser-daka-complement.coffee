$ ->
  # after window.loaded,create a form -- form0
  counter = 0
  (new_form(counter++)).insertBefore $('#total-submit') 
  # the first form should disable 'delete' button
  $('button.btn-danger').attr 'disabled',1 
  # 注册所有类型为RADIO的控件，当点击时禁用/解禁相邻的TEXT控件。
  $('#container').on 'click','input[type=radio]',(e)->
    $input_entry = $(this).closest('.form-group').next().find 'input'
    $input_exit = $input_entry.parentsUntil('form.form-horizontal').next().find 'input'
    switch $(@).val()
      when 'option1' 
        $input_entry.removeAttr 'disabled'
        $input_exit.attr 'disabled',1
      when 'option2' 
        $input_entry.attr 'disabled',1
        $input_exit.removeAttr 'disabled'
      when 'option3' 
        $input_exit.removeAttr 'disabled'
        $input_entry.removeAttr 'disabled'

  $('#container').on 'click','button.more',(e)->
    # create a new form
    $form = new_form(counter)
    $form.insertBefore $('#total-submit') 
    e.preventDefault()
    e.stopPropagation()
    counter++

  $('#container').on 'click','button.btn-danger',(e)->
    theform = $(@).closest('form')
    theform.remove()
    e.preventDefault()
    e.stopPropagation()

  $('#total-submit').on 'click',(e)->
    array = $('form').serializeArray()
    fd = new FormData
    # if multiple forms has same field name,need a map object
    #mapobj = {} 
    for item in array
      #if item.name not in Object.keys(mapobj)
      #  mapobj[item.name]=[] # initialize 
      #mapobj[item.name].push item.value
      fd.append item.name,item.value  
    #for item of mapobj
    #  fd.append item,mapobj[item]
    xhr = new XMLHttpRequest
    # if no below line,response will be 'text'(string)
    xhr.responseType = 'json'
    xhr.ontimeout = 3000 # 3 secs. 
    xhr.onloadend = (evt)->
      # createAlertBox() included already
      window.createAlertBox $('#msg'),JSON.stringify(xhr.response)
    xhr.open 'POST',''
    xhr.send fd
    e.preventDefault()
    e.stopPropagation()
