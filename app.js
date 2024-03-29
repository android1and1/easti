// Generated by CoffeeScript 2.3.2
(function() {
  // first of first check if 'redis-server' is running.
  var PROJECT_ROOT, app, express, http, path, pgrep, server, spawn, static_root;

  ({spawn} = require('child_process'));

  pgrep = spawn('/usr/bin/pgrep', ['redis-server']);

  pgrep.on('close', function(code) {
    if (code !== 0) {
      console.log('should run redis-server first.');
      return process.exit(1);
    }
  });

  path = require('path');

  http = require('http');

  express = require('express');

  app = express();

  PROJECT_ROOT = process.env.HOME + '/easti';

  app.set('view engine', 'pug');

  //static root directory setup
  static_root = path.join(PROJECT_ROOT, 'public');

  app.use(express.static(static_root));

  
  // enable the variable - "req.body".like the old middware - "bodyParser"
  app.use(express.urlencoded({
    extended: false
  }));

  app.get('/', function(req, res) {
    return res.render('index', {
      title: 'Welcome!'
    });
  });

  app.use(function(req, res) {
    res.status(404);
    return res.render('404');
  });

  app.use(function(err, req, res, next) {
    console.error('occurs 500 error. [[ ' + err.stack + '  ]]');
    res.type('text/plain');
    res.status(500);
    return res.send('500 - Server Error!');
  });

  if (require.main === module) {
    server = http.Server(app);
    server.listen(3003, function() {
      return console.log('server running at port 3003;press Ctrl-C to terminate.');
    });
  } else {
    module.exports = app;
  }

}).call(this);
