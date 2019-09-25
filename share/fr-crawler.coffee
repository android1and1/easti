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

selector_of_audioes = '.i-download'
request.get 'http://cn.rfi.fr'
.end (err,res)->
  $ = cheerio.load res.text
  audioes = []
  $(selector_of_audioes).each (i,v)->
    href = $(v).attr('href')
    title = $(v).parents("li[data-bo-type=edition]").children("div.news-block-title").text()
    if mode is 'report'
      audioes.push {'title':title,'href':href}
    if mode is 'print'
      audioes.push request.get href
  if mode is 'print'
    Promise.all audioes 
    .then (oRess)->
      for oRes in oRess
        filename = oRes.res.headers['content-disposition']
        filename = filename.replace /^.+=(.*)/,"$1"
          .replace(/"/g,'')
        ws = fs.createWriteStream './voices/rfi-fr-' + filename 
        ws.on 'finish',->
          console.log 'stored one item.'
        ws.write oRes.body
        ws.end()
  if mode is 'report'
    for peer in audioes
      console.log 'title:',peer.title
      console.log 'href:',peer.href
