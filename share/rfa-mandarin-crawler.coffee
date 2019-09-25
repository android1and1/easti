# 2019 07-12 insprit from "the-fourth-cheerio'"
if process.argv.length isnt 3
  console.log 'need 3 arguments.'
  process.exit 1
mode = process.argv[2].toLowerCase()

if mode isnt 'print' and mode isnt 'report'
  console.log 'mode is invalid.'
  process.exit 1

request = require 'superagent'
cheerio = require 'cheerio'
start_time = new Date()
fs = require 'fs'
audioes = []
request.get 'https://www.rfa.org/mandarin/audio'
.end (err,res)->
  $ = cheerio.load res.text
  h2s = $ '.audioarchivetext > h2'
  for i in h2s 
    title =  $(i).text()
    href =  $(i).parent().next().children().last().attr('href')
    if mode is 'report'
      audioes.push {'title':title,'href':href}
    if mode is 'print'
      # here is the correctly way limit audioes. 
      #(limit via length of array)if audioes.length < 7 
      if /2019\/07\/14/.test title 
        audioes.push request.get href
  if mode is 'print'
    Promise.all audioes 
    .then (oRess)->
      for oRes in oRess
        filename = oRes.req.path
        filename = filename.replace /.*\/(.+)/,"$1"
        ws = fs.createWriteStream './voices/' + 'rfa-mandarin-' + filename 
        ws.on 'finish',->
          console.log 'stored one item.'
        ws.write oRes.body
        ws.end()
  if mode is 'report'
    for peer in audioes
      console.log 'title:',peer.title
      console.log 'href:',peer.href
