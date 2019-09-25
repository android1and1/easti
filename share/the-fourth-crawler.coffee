# it is a stand along script,useage:coffee <this> <report | print>
# 2016 06 26 first sucess
# 2016 07 06 let this became a reporter.
# Note that,if mode is print(download),audioes stores into <project./voices/

# check argument,if invalide?
if process.argv.length isnt 3
  console.log 'need 3 arguments.'
  process.exit 1
mode = process.argv[2].toLowerCase()

if mode isnt 'print' and mode isnt 'report'
  console.log 'mode is invalid.'
  process.exit 1

counter = 0
request = require 'superagent'
cheerio = require 'cheerio'
start_time = new Date()
fs = require 'fs'
EventEmitter = (require 'events').EventEmitter

event = new EventEmitter
event.on 'print now',(given)->
  ###
    filter .mp4 and nonsense things.
  ###
  needs = []
  for i in given
    if /\.mp3\?download=1/.test i
      needs.push i 
  tasks = []
  for need in needs
    tasks.push request.get need
  Promise.all tasks 
  .then (oo)->
    for o in oo
      # report .mp3 filename
      # console.log o.res.headers['content-disposition']
      filename = o.res.headers['content-disposition']
      filename = filename.replace /^.+=(.*)/,"$1"
      ws = fs.createWriteStream './voices/' + filename 
      ws.on 'finish',->
        console.log 'stored one item.'
      ws.write o.body
      ws.end()

selector_of_pages = '.media-block.has-img a[title]'
selector_of_audioes = '.media-download a'
request.get 'https://www.voachinese.com/z/3637'
.end (err,res)->
  $1 = cheerio.load res.text
  links = []
  audioes = []
  top10 = []
  $1(selector_of_pages).each (i,v)->
    href = $1(v).attr('href')
    title = $1(v).attr('title')
    if /^\/a/.test href
      if mode is 'report'
        # only retrieves 10 newest items
        if top10.length < 10
          top10.push {'title':title,'href':href}
      if mode is 'print'
        # only retrieves 10 newest items
        if links.length < 10 
          links.push request.get 'https://www.voachinese.com' + href
  if mode is 'print'
    Promise.all links
    .then (oRess)->
      for oRes in oRess
        $2 = cheerio.load oRes.text
        href = $2(selector_of_audioes).last().attr('href')
        audioes.push href
    .then ->
      event.emit 'print now',audioes
  if mode is 'report'
    for peer in top10
      console.log 'title:',peer.title
      console.log 'href:',peer.href
