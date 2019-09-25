fs = require 'fs'
origin_request = require 'request'
request = require 'request-promise-native'
cheerio = require 'cheerio'

request.get 'https://www.voachinese.com/z/3637'
.then (body)->
  $ = cheerio.load body
  links = []
  $('.media-block.has-img a[title]').each (i,v)->
    href = $(v).attr('href')
    if /^\/a/.test href
      #console.log 'href=',href
      console.log 'title=',$(v).attr('title')
      links.push request.get 'https://www.voachinese.com' + href
    Promise.all links
    .then (bodies)->
      for thisbody in bodies
        $2= cheerio.load thisbody
        thislink = $2('.media-download a')
        thislink.each (ii,vv)->
          thishref = $(vv).attr('href') 
          if not /hq\.mp3/.test thishref
            console.log thishref
