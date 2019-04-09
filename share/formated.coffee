format = (num)->
  str = num + ''
  if str.length is 1
    str = '0' + str
  str
now = new Date
year = now.getFullYear()
month = format(now.getMonth() + 1)
day = format(now.getDate())
hour = format(now.getHours())
minute = format(now.getMinutes())
secs = format(now.getSeconds())
milliseconds = now.getMilliseconds()
datestring = [year,month,day].join('-') 
timestring = 'T'+hour+':'+minute+':'+secs+'.'+milliseconds+'Z' 
console.log datestring+timestring
#console.log now.toGMTString()
console.log now.toISOString()

