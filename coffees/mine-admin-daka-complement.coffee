$ ->
  # 注册所有类型为RADIO的控件，当点击时禁用/解禁相邻的TEXT控件。
  $('body').on 'click','.form-group input[type=radio]',(e)->
    input_entry = $(this).next 'input'
    if e.target.value is 'option 1'
      alert 'y'
       
  $('button.more').on 'click',(e)->
    alert 'Clicked More Button.'
    e.preventDefault()
    e.stopPropagation()
    
