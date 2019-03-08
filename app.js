// Generated by CoffeeScript 2.3.2
(function() {
  // first of first check if 'redis-server' is running.
  var Account, Daka, Nohm, Session, Store, accountModel, app, credential, crypto, dakaModel, expireAsync, express, filter, fs, getAsync, hashise, http, initSession, matchDB, path, pgrep, promisify, qr_image, redis, server, setAsync, sha256, spawn, static_root, superpass, updateAuthSession;

  ({spawn} = require('child_process'));

  // this for redis promisify(client.get),the way inpirit from npm-redis.
  ({promisify} = require('util'));

  pgrep = spawn('/usr/bin/pgrep', ['redis-server']);

  pgrep.on('close', function(code) {
    if (code !== 0) {
      console.log('should run redis-server first.');
      return process.exit(1);
    }
  });

  path = require('path');

  fs = require('fs');

  http = require('http');

  qr_image = require('qr-image');

  crypto = require('crypto');

  // super-user's credential
  fs.stat('./credentials/super-user.js', function(err, stats) {
    if (err) {
      console.log('Credential File Not Exists,Fix It.');
      return process.exit(1);
    }
  });

  credential = require('./credentials/super-user.js');

  superpass = credential.password;

  ({Nohm} = require('nohm'));

  Account = require('./modules/md-account');

  Daka = require('./modules/md-daka');

  dakaModel = void 0;

  accountModel = void 0;

  redis = (require('redis')).createClient();

  setAsync = promisify(redis.set).bind(redis);

  getAsync = promisify(redis.get).bind(redis);

  expireAsync = promisify(redis.expire).bind(redis);

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

  app.use(function(req, res, next) {
    res.locals.referrer = req.session.referrer;
    delete req.session.referrer; // then,delete() really harmless
    return next();
  });

  app.get('/', function(req, res) {
    var alias, ref, ref1, ref2, ref3, role;
    role = (ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0;
    alias = (ref2 = req.session) != null ? (ref3 = ref2.auth) != null ? ref3.alias : void 0 : void 0;
    if (role === 'unknown' && alias === 'noname') {
      [role, alias] = ['visitor', 'hi'];
    }
    return res.render('index', {
      title: 'welcome-daka',
      role: role,
      alias: alias
    });
  });

  app.get('/user/daka', function(req, res) {
    var ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'user') {
      req.session.referrer = '/user/daka';
      return res.redirect(303, '/user/login');
    } else {
      return res.render('user-daka', {
        alias: req.session.auth.alias,
        title: 'User DaKa Console'
      });
    }
  });

  app.get('/user/login', function(req, res) {
    return res.render('user-login', {
      title: 'Fill User Login Form'
    });
  });

  app.post('/user/login', async function(req, res) {
    var alias, isInvalidation, itisreferrer, mobj, password;
    // reference line#163
    ({itisreferrer, alias, password} = req.body);
    itisreferrer = itisreferrer || '/user/login-success';
    // filter these 2 strings for anti-injecting
    isInvalidation = !filter(alias || !filter(password));
    if (isInvalidation) {
      return res.render('user-login-failure', {
        reason: '含有非法字符（只允许ASCII字符和数字)!',
        title: 'User-Login-Failure'
      });
    }
    // auth initialize
    initSession(req);
    // first check if exists this alias name?
    // mobj is 'match stats object'
    mobj = (await matchDB(accountModel, alias, 'user', password));
    if (mobj.match_result) {
      
      // till here,login data is matches.
      updateAuthSession(req, 'user', alias);
      return res.redirect(303, itisreferrer);
    } else {
      updateAuthSession(req, 'unknown', 'noname');
      return res.render('user-login-failure', {
        reason: '帐户不存在或者账户/口令不匹配!',
        title: 'User-Login-Failure'
      });
    }
  });

  app.put('/user/logout', function(req, res) {
    var role;
    // check if current role is correctly
    role = req.session.auth.role;
    if (role === 'user') {
      req.session.auth.role = 'unknown';
      req.session.auth.alias = 'noname';
      return res.json({
        reason: '',
        status: 'logout success'
      });
    } else {
      return res.json({
        reason: 'No This Account Or Role Isnt User.',
        status: 'logout failure'
      });
    }
  });

  app.put('/admin/logout', function(req, res) {
    var role;
    // check if current role is correctly
    role = req.session.auth.role;
    if (role === 'admin') {
      req.session.auth.role = 'unknown';
      req.session.auth.alias = 'noname';
      return res.json({
        reason: '',
        status: 'logout success'
      });
    } else {
      return res.json({
        reason: 'no this account or role isnt admin.',
        status: 'logout failure'
      });
    }
  });

  app.get('/user/login-success', function(req, res) {
    return res.render('user-login-success', {
      title: 'User Role Validation:successfully'
    });
  });

  app.get('/create-qrcode', async function(req, res) {
    var fulltext, text;
    // the query string from user-daka js code(img.src=url+'....')
    // query string include socketid,timestamp,and alias
    text = [req.query.socketid, req.query.timestamp].join('-');
    await setAsync('important', text);
    await expireAsync('important', 60);
    // templary solid ,original mode is j602 
    fulltext = 'http://192.168.5.2:3003/user/daka-response?alias=' + req.query.alias + '&&check=' + text;
    res.type('png');
    return qr_image.image(fulltext).pipe(res);
  });

  app.get('/user/daka-response', async function(req, res) {
    var dbkeep, desc, error, ins, ms, obj, ref, ref1, text;
    // user-daka upload 'text' via scan-qrcode-then-goto-url.
    text = req.query.check;
    dbkeep = (await getAsync('important'));
    if (req.query.alias !== ((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.alias : void 0 : void 0)) {
      return res.json('you should requery daka and visit this page via only one browser');
    }
    if (dbkeep !== '' && text !== '' && dbkeep === text) {
      try {
        // save this daka-item
        obj = new Date;
        desc = obj.toString();
        ms = Date.parse(obj);
        ins = (await Nohm.factory('daily'));
        ins.property({
          // if client has 2 difference browser,one for socketio,and one for qrcode-parser.how the 'alias' value is fit?
          alias: req.query.alias, // or req.session.auth.alias 
          utc_ms: ms,
          whatistime: desc,
          browser: req.headers["user-agent"]
        });
        await ins.save();
        return res.render('user-daka-response', {
          title: 'login Result',
          status: '打卡成功'
        });
      } catch (error1) {
        error = error1;
        console.log('error', error);
        // show db errors
        return res.json(ins.error);
      }
    } else {
      return res.render('user-daka-response', {
        title: 'login Result',
        status: '打卡失败'
      });
    }
  });

  app.get('/admin/daka', function(req, res) {
    var ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/daka';
      return res.redirect(303, '/admin/login');
    } else {
      return res.render('admin-daka', {
        title: 'Admin Console'
      });
    }
  });

  app.get('/admin/login', function(req, res) {
    // pagejs= /mine/mine-admin-login.js
    return res.render('admin-login', {
      title: 'Fill Authentication Form'
    });
  });

  app.get('/admin/admin-update-password', function(req, res) {
    return res.render('admin-update-password', {
      title: 'Admin-Update-Password'
    });
  });

  app.post('/admin/admin-update-password', async function(req, res) {
    var alias, dbkeep, error, item, items, newpassword, oldpassword;
    ({oldpassword, newpassword, alias} = req.body);
    items = (await accountModel.findAndLoad({
      alias: alias
    }));
    if (items.length === 0) {
      return res.json('no found!');
    } else {
      item = items[0];
      dbkeep = item.property('password');
      if (dbkeep === hashise(oldpassword)) {
        // update this item's password part
        item.property('password', hashise(newpassword));
        try {
          item.save();
        } catch (error1) {
          error = error1;
          return res.json(item.error);
        }
        return res.json('Update Password For Admin.'); //password is mismatches.
      } else {
        return res.json('Mismatch your oldpassword,check it.');
      }
    }
  });

  app.get('/admin/register-user', function(req, res) {
    var ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      return res.redirect(302, '/admin/login');
    } else {
      return res.render('admin-register-user', {
        title: 'Admin-Register-User'
      });
    }
  });

  app.post('/admin/register-user', async function(req, res) {
    var alias, error, ins, password;
    ({alias, password} = req.body);
    if (!filter(alias || !filter(password))) {
      return res.json('Wrong:User Name(alias) contains invalid character(s).');
    }
    ins = (await Nohm.factory('account'));
    ins.property({
      alias: alias,
      role: 'user',
      initial_timestamp: Date.parse(new Date),
      // always remember:hashise!!
      password: hashise(password)
    });
    try {
      await ins.save();
      return res.json('Register User - ' + alias);
    } catch (error1) {
      error = error1;
      return res.json(ins.errors);
    }
  });

  app.post('/admin/login', async function(req, res) {
    var alias, isInvalid, itisreferrer, mobj, password;
    ({itisreferrer, alias, password} = req.body);
    itisreferrer = itisreferrer || '/admin/login-success';
    
    // filter alias,and password
    isInvalid = !filter(alias || !filter(password));
    if (isInvalid) {
      return res.render('admin-login-failure', {
        title: 'Login-Failure',
        reason: 'contains invalid char(s).'
      });
    }
    
    // initial session.auth
    initSession(req);
    // first check if exists this alias name?
    // mobj is 'match stats object'
    mobj = (await matchDB(accountModel, alias, 'admin', password));
    if (mobj.match_result) {
      
      // till here,login data is matches.
      updateAuthSession(req, 'admin', alias);
      return res.redirect(303, itisreferrer);
    } else {
      updateAuthSession(req, 'unknown', 'noname');
      return res.render('admin-login-failure', {
        title: 'Login-Failure',
        reason: 'account/password peer dismatches.'
      });
    }
  });

  app.get('/admin/login-success', function(req, res) {
    return res.render('admin-login-success.pug', {
      title: 'Administrator Role Entablished'
    });
  });

  app.get('/admin/list-accounts', async function(req, res) {
    var inss, results;
    if (req.session.auth.alive === false) {
      return res.redirect(302, '/admin/login');
    }
    inss = (await accountModel.findAndLoad());
    results = [];
    inss.forEach(function(one) {
      var obj;
      obj = {};
      obj.alias = one.property('alias');
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

  app.get('/superuser/login', function(req, res) {
    return res.render('superuser-login.pug', {
      title: 'Are You A Super?'
    });
  });

  app.post('/superuser/login', function(req, res) {
    var hash, password, superkey;
    // initial sesson.auth
    initSession(req);
    superkey = (require('./credentials/super-user.js')).password;
    ({password} = req.body);
    hash = sha256(password);
    if (hash === superkey) {
      updateAuthSession(req, 'superuser', 'superuser');
      return res.json({
        staus: 'super user login success.'
      });
    } else {
      updateAuthSession(req, 'unknown', 'noname');
      return res.json({
        staus: 'super user login failurre.'
      });
    }
  });

  app.get('/superuser/register-admin', function(req, res) {
    var ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'superuser') {
      return res.redirect(302, '/superuser/login');
    } else {
      return res.render('superuser-register-admin', {
        defaultValue: '1234567',
        title: 'Superuser-register-admin'
      });
    }
  });

  app.post('/superuser/register-admin', async function(req, res) {
    var adminname, error, ins;
    ({adminname} = req.body);
    if (!filter(adminname)) {
      return res.json('Wrong:Admin Name(alias) contains invalid character(s).');
    }
    ins = (await Nohm.factory('account'));
    ins.property({
      alias: adminname,
      role: 'admin',
      initial_timestamp: Date.parse(new Date),
      password: hashise('1234567') // default password. 
    });
    try {
      await ins.save();
      return res.json('Saved.');
    } catch (error1) {
      error = error1;
      return res.json(ins.errors);
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

  
  // initSession is a help function
  initSession = function(req) {
    var ref;
    if (!((ref = req.session) != null ? ref.auth : void 0)) {
      req.session.auth = {
        alias: 'noname',
        counter: 0,
        tries: [],
        matches: [],
        role: 'unknown'
      };
    }
    return null;
  };

  // hashise is a help function.
  hashise = function(plain) {
    var hash;
    hash = crypto.createHash('sha256');
    hash.update(plain);
    return hash.digest('hex');
  };

  
  // filter is a help function
  filter = function(be_dealt_with) {
    // return true is safe,return false means injectable.
    return !/\W/.test(be_dealt_with);
  };

  // matchDB is a help function 
  // *Notice that* invoke this method via "await <this>"
  matchDB = async function(db, alias, role, password) {
    var dbpassword, dbrole, item, items, match_result, warning;
    // db example 'accountModel'
    items = (await db.findAndLoad({
      'alias': alias
    }));
    if (items.length === 0) { // means no found.
      return false;
    } else {
      item = items[0];
      dbpassword = item.property('password');
      dbrole = item.property('role');
      warning = '';
      if (dbpassword === '8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414') {
        warning = 'should change this simple/initial/templory password immediately.';
      }
      match_result = (hashise(password)) === dbpassword && dbrole === role;
      return {
        match_result: match_result,
        warning: warning
      };
    }
  };

  // updateAuthSession is a help function
  updateAuthSession = function(req, role, alias) {
    var counter, timestamp;
    timestamp = new Date;
    counter = req.session.auth.counter++;
    req.session.auth.tries.push('counter#' + counter + ':user try to login at ' + timestamp);
    req.session.auth.role = role;
    req.session.auth.alias = alias;
    if (role === 'unknown') {
      return req.session.auth.matches.push('*Not* Matches counter#' + counter + ' .');
    } else {
      return req.session.auth.matches.push('Matches counter#' + counter + ' .');
    }
  };

  
  // for authenticate super user password.
  sha256 = function(plain) {
    return crypto.createHash('sha256').update(plain).digest('hex');
  };

}).call(this);
