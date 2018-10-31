// Generated by CoffeeScript 2.1.1
(function() {
  var PROJECT_ROOT, alpha, app, express, http, path, pgrep, spawn, static_root, tools, tricks, uploading;

  path = require('path');

  http = require('http');

  ({spawn} = require('child_process'));

  express = require('express');

  app = express();

  PROJECT_ROOT = process.env.HOME + '/easti';

  app.set('view engine', 'pug');

  //static root directory setup
  static_root = path.join(PROJECT_ROOT, 'public');

  app.use(express.static(static_root));

  
  //bodyParser as
  app.use(express.urlencoded({
    extended: false
  }));

  // include all customise router
  tools = require('./routes/route-tools.js');

  alpha = require('./routes/route-alpha.js');

  tricks = require('./routes/route-tricks.js');

  uploading = require('./routes/route-uploading.js');

  app.use('/tools', tools);

  app.use('/alpha', alpha);

  app.use('/uploading', uploading);

  app.use('/tricks', tricks);

  app.get('/', function(req, res) {
    return res.render('index', {
      title: 'I see You',
      name: 'wang!'
    });
  });

  app.get('/show-widget', function(req, res) {
    return res.render('widgets/show-widget');
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
    // it is main's responsible to starting redis-server
    pgrep = spawn('pgrep', ['redis-server']);
    pgrep.on('close', function(code1) {
      var conf, redisservice, server;
      if ((parseInt(code1)) !== 0) { //means no found
        console.log('start redis-server.');
        if (process.platform === 'linux') {
          conf = './redisdb/linux.redis.conf';
        } else if (process.platform === 'darwin') {
          conf = './redisdb/darwin.redis.conf';
        } else {
          conf = '';
        }
        redisservice = spawn('redis-server', [conf, '--loglevel', 'verbose']);
        redisservice.on('error', function(err) {
          console.error('debug info::: ' + err.message);
          return process.exit(1);
        });
        redisservice.on('data', function(da) {
          console.log('spawn output:');
          return console.log(da.toString('utf-8'));
        });
        return process.nextTick(function() {
          var server;
          server = http.Server(app);
          return server.listen(3003, function() {
            return console.log('server running at port 3003;press Ctrl-C to terminate.');
          });
        });
      } else {
        // code1=0,means found progress of redis-server,no need restart.
        console.log('redis-server started already.');
        server = http.Server(app);
        return server.listen(3003, function() {
          return console.log('server running at port 3003;press Ctrl-C to terminate.');
        });
      }
    });
  } else {
    module.exports = app;
  }

}).call(this);
