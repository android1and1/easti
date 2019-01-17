###
module.exports = function(grunt){
  [
    'grunt-mocha-test',
    'grunt-exec',
  ].forEach(function(task){
    grunt.loadNpmTasks(task);
  });
  grunt.initConfig({
      mochaTest: {
        all:{src:'qa/test-*.js'},
        single:{src:'qa/test-grunt-mochaTest-see.js'},
      },
      exec:{
        sample:
          {cmd:'echo twice: hihi'}
      }
  });
  grunt.registerTask('default',['mochaTest','exec']);
};
###
module.exports = (grunt)->
  [
    'grunt-mocha-test'
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
    mochaTest:
      all:
        src:'qa/test-*.js'
    exec:
      runredis:
        cmd:'redis-server ' + conf 
      killserver:
        cmd:'pgrep node | xargs kill -15'
      killredis:
        cmd:'redis-cli shutdown nosave'
      runserver:
        cmd:'sleep 2 && node ./app.js &'
  #grunt.registerTask 'default',['mochaTest','exec']
  grunt.registerTask 'default',['exec:runredis','exec:runserver']
