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
      },
      exec:{
        sample:
          {cmd:'echo twice: hihi'}
      }
  });
  grunt.registerTask('default',['mochaTest','exec']);
};
