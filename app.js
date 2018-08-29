// Generated by CoffeeScript 2.2.2
(function() {
  var app, express, http, path, project_root, server, static_root, tools;

  path = require('path');

  http = require('http');

  express = require('express');

  app = express();

  project_root = process.env.HOME + '/easti';

  app.set('view engine', 'pug');

  static_root = path.join(project_root, 'public');

  app.use(express.static(static_root));

  
  // include all customise router
  tools = require('./routes/route-tools.js');

  app.use('/tools', tools);

  app.get('/', function(req, res) {
    return res.render('index', {
      title: 'I see You',
      name: 'wang!'
    });
  });

  app.get('/show-widget', function(req, res) {
    return res.render('widgets/show-widget');
  });

  app.get('/iphone-upload', function(req, res) {
    return res.render('iphone-upload');
  });

  app.use(function(req, res) {
    return res.render('404');
  });

  app.use(function(err, req, res, next) {
    console.error(err.stack);
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
