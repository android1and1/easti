// Generated by CoffeeScript 2.3.2
(function() {
  // first of first check if 'redis-server' is running.
  var Account, Daka, Nohm, Session, Store, accountModel, app, crypto, dakaModel, express, hashise, http, path, pgrep, qr_image, redis, server, spawn, static_root;

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

  qr_image = require('qr-image');

  crypto = require('crypto');

  ({Nohm} = require('nohm'));

  Account = require('./modules/md-account');

  Daka = require('./modules/md-daka');

  dakaModel = void 0;

  accountModel = void 0;

  redis = (require('redis')).createClient();

  redis.on('error', function(err) {
    return console.log('Heard that:', err);
  });

  redis.on('connect', function() {
    Nohm.setClient(this);
    Nohm.setPrefix('DaKa'); // the main api name.
    // register the 2 models.
    dakaModel = Nohm.register(Daka);
    return accountModel = Nohm.register(Account);
  });

  express = require('express');

  app = express();

  app.set('view engine', 'pug');

  static_root = path.join(__dirname, 'public');

  app.use(express.static(static_root));

  
  // enable "req.body",like the old middware - "bodyParser"
  app.use(express.urlencoded({
    extended: false
  }));

  // session
  Session = require('express-session');

  Store = (require('connect-redis'))(Session);

  app.use(Session({
    cookie: {
      maxAge: 86400 * 1000, // one day. 
      httpOnly: true,
      path: '/' // 似乎太过宽泛，之后有机会会琢磨这个
    },
    secret: 'youkNoW.',
    store: new Store,
    resave: false,
    saveUninitialized: true
  }));

  app.get('/', function(req, res) {
    var auth, ref;
    auth = void 0;
    if (req != null ? (ref = req.session) != null ? ref.auth : void 0 : void 0) {
      auth = req.session.auth;
    }
    return res.render('index', {
      title: 'Welcome!',
      auth: auth
    });
  });

  app.get('/daka', function(req, res) {
    return res.render('daka', {
      title: 'Welcome Daka!'
    });
  });

  app.get('/create-qrcode', function(req, res) {
    var text;
    text = req.query.text;
    
    // templary solid 
    text = 'http://192.168.5.2:3003/login-success?text=' + text;
    res.type('png');
    return qr_image.image(text).pipe(res);
  });

  app.get('/login-success', function(req, res) {
    var status, text;
    text = req.query.text;
    if (text === 'you are beautiful.') {
      status = '打卡成功';
    } else {
      status = '验证失败 打卡未完成';
    }
    return res.render('login-success', {
      title: 'login Result',
      status: status
    });
  });

  // user account initialize.
  app.all('/fill-account', async function(req, res) {
    var code, error, ins, name, password;
    if (req.method === 'GET') {
      return res.render('user-account-form', {
        title: 'User Account Form'
      });
    } else if (req.method === 'POST') {
      // prepare crypto method
      ({name, code, password} = req.body);
      ins = (await Nohm.factory('account'));
      ins.property({
        name: name,
        code: code,
        password: hashise(password),
        initial_timestamp: Date.parse(new Date()) // milion secs,integer
      });
      try {
        await ins.save();
        return res.render('save-success', {
          itemid: ins.id
        });
      } catch (error1) {
        error = error1;
        return res.render('save-fail', {
          reason: ins.errors
        });
      }
    }
  });

  app.get('/admin/list-accounts', async function(req, res) {
    var inss, results;
    inss = (await accountModel.findAndLoad());
    results = [];
    inss.forEach(function(one) {
      var obj;
      obj = {};
      obj.name = one.property('name');
      obj.code = one.property('code');
      obj.initial_timestamp = one.property('initial_timestamp');
      obj.password = one.property('password');
      obj.id = one.id;
      return results.push(obj);
    });
    return res.render('list-accounts', {
      title: 'Admin:List Accounts',
      accounts: results
    });
  });

  app.get('/admin/login', function(req, res) {
    // pagejs= /mine/mine-admin-login.js
    return res.render('admin-login', {
      title: 'Fill Authentication Form'
    });
  });

  app.post('/admin/login', async function(req, res) {
    var counter, dbpassword, error, error_reason, ins, inss, name, password, timestamp;
    if (req.session.auth === void 0) {
      req.session.auth = {
        tries: [],
        matches: [],
        alive: false, // the target-attribute which all route will check if it is true. 
        counter: 0
      };
    }
    ({name, password} = req.body);
    password = hashise(password);
    try {
      // create a instance
      inss = (await accountModel.findAndLoad({
        name: name
      }));
      ins = inss[0];
      dbpassword = ins.property('password');
    } catch (error1) {
      error = error1;
      req.session.auth.alive = false;
      timestamp = new Date;
      counter = req.session.auth.counter++;
      req.session.auth.tries.push('try#' + counter + ' at ' + timestamp);
      req.session.auth.matches.push('*NOT* matche try#' + counter + ' .');
      error_reason = error.message;
      return res.json({
        status: 'db error',
        reason: error_reason
      });
    }
    if (dbpassword === password) {
      req.session.auth.alive = true;
      timestamp = new Date;
      counter = req.session.auth.counter++;
      req.session.auth.tries.push('try#' + counter + ' at ' + timestamp);
      req.session.auth.matches.push('Matches try#' + counter + ' .');
      return res.render('login-success', {
        title: 'test if administrator',
        auth_data: {
          name: name,
          password: dbpassword
        }
      });
    } else {
      req.session.auth.alive = false;
      timestamp = new Date;
      counter = req.session.auth.counter++;
      req.session.auth.tries.push('try#' + counter + ' at ' + timestamp);
      req.session.auth.matches.push('*NOT* matche try#' + counter + ' .');
      return res.json({
        status: 'authenticate error',
        reason: 'user account name/password peer  not match stored.'
      });
    }
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

  hashise = function(plain) {
    var hash;
    hash = crypto.createHash('sha256');
    hash.update(plain);
    return hash.digest('hex');
  };

}).call(this);
