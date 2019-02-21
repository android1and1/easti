{Nohm} = require 'nohm'
client = (require 'redis').createClient()
client.on 'connect',->
  console.log 'heard!'
  Nohm.setClient @
  Nohm.setPrefix 'DaKa'
  await Nohm.purgeDb @ 
  console.log 'Clear All Prefix:DaKa Items.'
  client.quit() 
