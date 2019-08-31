$ ->
  # 2019 9 1
  # new FileReader()
  # FileReader.onload=
  # file = this.files[0]
  # FileReader.readAsDataURL(file)
  $('form input[type=file]').on 'change',->
    # file api.buffer api. 
    fr = new FileReader()
    fr.onload = (e)->
      $('figure#figure img').attr 'src',e.target.result 
    fr.readAsDataURL this.files[0]
