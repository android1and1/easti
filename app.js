// Generated by CoffeeScript 2.2.2
(function() {
  var alpha, app, express, http, path, project_root, server, static_root, tools, uploading;

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

  alpha = require('./routes/route-alpha.js');

  uploading = require('./routes/route-uploading.js');

  app.use('/tools', tools);

  app.use('/alpha', alpha);

  app.use('/uploading', uploading);

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
