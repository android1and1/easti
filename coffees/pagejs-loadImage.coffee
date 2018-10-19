$ ->
  # define an aync func
  loadimage = (url)->
    return new Promise (onresolved,onrejected)->
      img = new Image
      img.onload = onresolved
      img.onerror = onrejected
      img.src = url

  #loadimage '/images/flops-thumb.jpg'
  loadimage '/images/no-this.jpg'
  .then ->console.log 'load complete.'
  .catch (reason)->console.log 'catched:',reason
   
