count = 0
fs = require 'fs'
request = require 'request'

#request 'http://127.0.0.1:3003/download-audio-ok'
tasks = []
list =  [
  'http://telechargement.rfi.fr/rfi/chinois/audio/modules/actu/201906/1ere_tranche_180619_soir.mp3'
  'http://telechargement.rfi.fr/rfi/chinois/audio/modules/actu/201906/2eme_tranche_180619.mp3'
  'http://telechargement.rfi.fr/rfi/mandarin/audio/magazines/r001/19_00_-_19_15_20190618.mp3'
]
for i in list
  tasks.push request(i)
Promise.all tasks
  .then (streams)->
     for s in streams
       s.pipe (fs.createWriteStream('downloads/ok' + count++ + '.mp3'))
  
