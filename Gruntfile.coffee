auth_pass = require './configs/redis/auth_pass.js'
module.exports = (grunt)->
  [
    'grunt-simple-mocha'
    'grunt-exec'
  ].forEach (task)->
    grunt.loadNpmTasks task
  #check which platform is now
  if process.platform is 'linux'
    conf = './redisdb/linux.redis.conf'
  else if process.platform is 'darwin'
    conf = './redisdb/darwin.redis.conf'
  else
    conf=''
  
  grunt.initConfig
    simplemocha:
      all:
        src:'qa/test-*.js'
    exec:
      runredis:
        cmd:'redis-server ' + conf 
      killserver:
        cmd:'pgrep node | xargs kill -15'
      killredis:
        cmd:'redis-cli -a ' + auth_pass + ' shutdown nosave 2> /dev/null'
      runserver:
        cmd:'sleep 2 && node ./bin/www.js &'
  #grunt.registerTask 'default',['simplemocha','exec']
  grunt.registerTask 'default',['exec:runredis','exec:runserver']
  grunt.registerTask 'killAll',['exec:killserver','exec:killredis']
