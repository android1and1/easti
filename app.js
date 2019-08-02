// Generated by CoffeeScript 2.3.2
(function() {
  // first of first check if 'redis-server' is running.
  var ACCOUNT_WILDCARD, Account, DAKA_WILDCARD, Daka, Nohm, Session, Store, TICKET_MEDIA_ROOT, TICKET_PREFIX, accountModel, app, complement_save, convert, credential, crypto, dakaModel, delAsync, ensure, expireAsync, express, filter, formidable, fs, getAsync, hashise, hgetallAsync, hostname, http, initSession, matchDB, path, pgrep, promisify, qr_image, redis, ruler, server, setAsync, sha256, spawn, static_root, superpass, updateAuthSession,
    indexOf = [].indexOf;

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

  formidable = require('formidable');

  crypto = require('crypto');

  // super-user's credential
  fs.stat('./configs/credentials/super-user.js', function(err, stats) {
    if (err) {
      console.log('Credential File Not Exists,Fix It.');
      return process.exit(1);
    }
  });

  credential = require('./configs/credentials/super-user.js');

  hostname = require('./configs/hostname.js');

  superpass = credential.password;

  // ruler for daka app am:7:30 pm:18:00
  ruler = require('./configs/ruler-of-daka.js');

  ({Nohm} = require('nohm'));

  Account = require('./modules/md-account');

  Daka = require('./modules/md-daka');

  dakaModel = void 0;

  accountModel = void 0;

  TICKET_PREFIX = 'ticket';

  TICKET_MEDIA_ROOT = path.join(__dirname, 'public', 'tickets');

  DAKA_WILDCARD = 'DaKa*daily*';

  ACCOUNT_WILDCARD = 'DaKa*account*';

  redis = (require('redis')).createClient();

  setAsync = promisify(redis.set).bind(redis);

  getAsync = promisify(redis.get).bind(redis);

  expireAsync = promisify(redis.expire).bind(redis);

  delAsync = function(key) {
    return new Promise(function(resolve, reject) {
      return redis.del(key, function(err) {
        if (err) {
          return reject(err);
        } else {
          return resolve();
        }
      });
    });
  };

  hgetallAsync = function(key) {
    return new Promise(function(resolve, reject) {
      return redis.hgetall(key, function(err, record) {
        if (err) {
          return reject(err);
        } else {
          return resolve(record);
        }
      });
    });
  };

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

  app.get('/create-check-words', async function(req, res) {
    var _, alpha, chars, digits, index, random, ref, round, words;
    // 如果用户选择了填表单方式来打卡。
    digits = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57];
    alpha = (function() {
      var results1 = [];
      for (var j = 97, ref = 97 + 26; 97 <= ref ? j < ref : j > ref; 97 <= ref ? j++ : j--){ results1.push(j); }
      return results1;
    }).apply(this);
    chars = digits.concat(alpha).concat(digits).concat(alpha);
    // total 72 chars,so index max is 72-1=71
    ({round, random} = Math);
    words = (function() {
      var j, results1;
// make length=5 words
      results1 = [];
      for (_ = j = 1; j <= 5; _ = ++j) {
        index = round(random() * 71);
        results1.push(String.fromCharCode(chars[index]));
      }
      return results1;
    })();
    words = words.join('');
    // 存储check words到redis数据库，并设置超时条件。
    await setAsync('important', words);
    await expireAsync('important', 60);
    return res.json(words);
  });

  app.get('/create-qrcode', async function(req, res) {
    var fulltext, text;
    // the query string from user-daka js code(img.src=url+'....')
    // query string include socketid,timestamp,and alias
    text = [req.query.socketid, req.query.timestamp].join('-');
    await setAsync('important', text);
    await expireAsync('important', 60);
    // templary solid ,original mode is j602 
    fulltext = hostname + '/user/daka-response?mode=' + req.query.mode + '&&alias=' + req.query.alias + '&&check=' + text;
    res.type('png');
    return qr_image.image(fulltext).pipe(res);
  });

  
  // maniuate new func or new mind.
  app.get('/user/daka', async function(req, res) {
    var ids, ref, ref1, today, user;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'user') {
      req.session.referrer = '/user/daka';
      return res.redirect(303, '/user/login');
    } else {
      // check which scene the user now in?
      user = req.session.auth.alias;
      // ruler object 
      today = new Date;
      today.setHours(ruler.am.hours);
      today.setMinutes(ruler.am.minutes);
      today.setSeconds(0);
      ids = (await dakaModel.find({
        alias: user,
        utc_ms: {
          min: Date.parse(today)
        }
      }));
      // mode变量值为0提示“入场”待打卡状态，1则为“出场”待打卡状态。
      return res.render('user-daka', {
        mode: ids.length,
        alias: user,
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
        reason: '用户登录失败，原因：帐户不存在／帐户被临时禁用／账户口令不匹配。',
        title: 'User-Login-Failure'
      });
    }
  });

  app.put('/user/logout', function(req, res) {
    var ref, ref1, role;
    role = (ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0;
    if (role === 'user') {
      req.session.auth.role = 'unknown';
      req.session.auth.alias = 'noname';
      return res.json({
        code: 0,
        reason: '',
        status: 'logout success'
      });
    } else {
      return res.json({
        code: -1,
        reason: 'No This Account Or Role Isnt User.',
        status: 'logout failure'
      });
    }
  });

  app.get('/user/login-success', function(req, res) {
    return res.render('user-login-success', {
      title: 'User Role Validation:successfully'
    });
  });

  // user choiced alternatively way to daka
  app.post('/user/daka-response', async function(req, res) {
    var check, desc, error, ins, ms, obj, ref, ref1, session_alias, words;
    check = req.body.check;
    // get from redis db
    words = (await getAsync('important'));
    session_alias = (ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.alias : void 0 : void 0;
    if (words === check) {
      try {
        
        // save this daka-item
        obj = new Date;
        desc = obj.toString();
        ms = Date.parse(obj);
        ins = (await Nohm.factory('daily'));
        ins.property({
          alias: session_alias,
          utc_ms: ms,
          whatistime: desc,
          browser: req.headers["user-agent"],
          category: req.body.mode // 'entry' or 'exit' mode
        });
        await ins.save();
        // notice admin with user's success.
        // the .js file include socket,if code=0,socket.emit 'code','0'
        return res.render('user-daka-response-success', {
          code: '0',
          title: 'login Result',
          status: '打卡成功',
          user: session_alias
        });
      } catch (error1) {
        error = error1;
        // notice admin with user's failure.
        // js file include socket,if code=-1,socket.emit 'code','-1'
        // show db errors
        console.dir(ins.errors);
        return res.render('user-daka-response-failure', {
          title: 'daka failure',
          'reason': ins.errors,
          code: '-1',
          user: session_alias,
          status: '数据库错误，打卡失败。'
        });
      }
    } else {
      return res.render('user-daka-response-failure', {
        title: 'daka failure',
        status: '打卡失败',
        code: '-1',
        reason: '超时或验证无效',
        user: session_alias
      });
    }
  });

  // user daka via QR code (scan software)
  app.get('/user/daka-response', async function(req, res) {
    var dbkeep, desc, error, ins, ms, obj, ref, ref1, session_alias, text;
    session_alias = (ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.alias : void 0 : void 0;
    if (session_alias === void 0) {
      req.session.referrer = '/user/daka-response';
      return res.redirect(303, '/user/login');
    }
    if (req.query.alias !== session_alias) {
      return res.json({
        status: 'alias inconsistent',
        warning: 'you should requery daka and visit this page via only one browser',
        session: session_alias,
        querystring: req.query.alias
      });
    }
    // user-daka upload 'text' via scan-qrcode-then-goto-url.
    text = req.query.check;
    dbkeep = (await getAsync('important'));
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
          browser: req.headers["user-agent"],
          category: req.query.mode // 'entry' or 'exit' mode
        });
        await ins.save();
        // notice admin with user's success.
        // the .js file include socket,if code=0,socket.emit 'code','0'
        return res.render('user-daka-response-success', {
          code: '0',
          title: 'login Result',
          status: '打卡成功',
          user: req.query.alias
        });
      } catch (error1) {
        error = error1;
        console.log('error', error);
        // notice admin with user's failure.
        // the .js file include socket,if code=-1,socket.emit 'code','-1'
        // show db errors
        return res.render('user-daka-response-failure', {
          title: 'daka failure',
          'reason': ins.errors,
          code: '-1',
          user: req.query.alias,
          status: '数据库错误，打卡失败。'
        });
      }
    } else {
      return res.render('user-daka-response-failure', {
        title: 'daka failure',
        status: '打卡失败',
        code: '-1',
        reason: '超时或身份验证无效',
        user: req.query.alias
      });
    }
  });

  
  // start-point-admin 
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

  app.put('/admin/logout', function(req, res) {
    var ref, ref1, role;
    role = (ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0;
    if (role === 'admin') {
      req.session.auth.role = 'unknown';
      req.session.auth.alias = 'noname';
      return res.json({
        reason: '',
        status: 'logout success'
      });
    } else {
      // notice that,if client logout failure,not change its role and alias
      return res.json({
        reason: 'no this account or role isnt admin.',
        status: 'logout failure'
      });
    }
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

  
  // db operator:DELETE
  // db operator:UPDATE(admin urging,super user resolved,use these way,a delicate case is,a ticket(always category is 'tool' want keep long time,superuser or admin can update ticket let ticket ttl longer,each click will auto-increment 10 days,for example)
  // db operator:FIND(superuser,admin are need list all tickets)
  // db operator:ADD
  app.all('/admin/create-new-ticket', function(req, res) {
    var formid, ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/create-new-ticket';
      return res.redirect(303, '/admin/login');
    }
    // redis instance already exists - 'redis'
    if (req.method === 'GET') {
      return res.render('admin-create-new-ticket', {
        alias: req.session.auth.alias,
        title: 'Admin-Create-New-Ticket' // POST
      });
    } else {
      // let npm-formidable handles
      formid = new formidable.IncomingForm;
      formid.uploadDir = TICKET_MEDIA_ROOT;
      formid.keepExtensions = true;
      // keep small size.if handle with video,rewrite below,let it bigger.
      formid.maxFileSize = 20 * 1024 * 1024;
      formid.on('error', function(formid_err) {
        return res.json(formid_err);
      });
      return formid.parse(req, function(formid_err, fields, files) {
        var k, media_url, options, v;
        if (formid_err) {
          return res.json(formid_err);
        }
        options = ['urge', '0', 'resolved', 'false'];
        for (k in fields) {
          v = fields[k];
          options = options.concat([k, v]);
        }
        if (files.media.size !== 0) {
          console.log('::' + files.media.type);
          media_url = files.media.path;
          media_url = '/tickets/' + media_url.replace(/.*\/(.+)$/, "$1");
          options = options.concat(['media', media_url, 'media_type', files.media.type]);
        }
        // store this ticket
        return redis.incr(TICKET_PREFIX + ':counter', function(err, number) {
          var keyname;
          if (err !== null) { // occurs error.
            return res.json(err);
          }
          keyname = [TICKET_PREFIX, 'hash', fields.category, number].join(':');
          options = options.concat(['ticket_id', number]);
          return redis.hmset(keyname, options, function(err, reply) {
            if (err) {
              return res.json(err);
            } else {
              return res.json(reply); // successfully
            }
          });
        });
      });
    }
  });

  app.delete('/admin/del-one-ticket/:id', function(req, res) {
    var id, ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/del-all-tickets';
      return res.redirect(303, '/admin/login');
    } else {
      // check if has 'with-media' flag.
      id = req.params.id;
      return res.send('params.id is - ' + id);
    }
  });

  app.get('/admin/del-all-tickets', function(req, res) {
    var ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/del-all-tickets';
      return res.redirect(303, '/admin/login');
    } else {
      return redis.keys(TICKET_PREFIX + ':hash:*', async function(err, list) {
        var item, j, len;
        for (j = 0, len = list.length; j < len; j++) {
          item = list[j];
          await delAsync(item);
        }
        // at last ,report to client.
        return res.render('admin-del-all-tickets');
      });
    }
  });

  app.get('/admin/newest-ticket', function(req, res) {
    var ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/newest-ticket';
      return res.redirect(303, '/admin/login');
    } else {
      return redis.keys(TICKET_PREFIX + ':hash:*', async function(err, list) {
        var item, items, j, len, record, records;
        // Example:give 3 items to client 
        // items = list[0...3]
        items = list;
        records = [];
        for (j = 0, len = items.length; j < len; j++) {
          item = items[j];
          record = (await hgetallAsync(item));
          record.keyname = item;
          records.push(record);
        }
        // sorting before output to client.
        records.sort(function(a, b) {
          return b.ticket_id - a.ticket_id;
        });
        return res.render('admin-newest-ticket.pug', {
          'title': 'list top 10 items.',
          records: records
        });
      });
    }
  });

  app.post('/admin/enable-user', async function(req, res) {
    var error, id, ins, reason;
    id = req.body.id;
    try {
      ins = (await Nohm.factory('account', id));
      ins.property('isActive', true);
      await ins.save();
      return res.json({
        code: 0,
        message: 'update user,now user in active-status.'
      });
    } catch (error1) {
      error = error1;
      reason = {
        thrown: error,
        nohm_said: ins.errors
      };
      return res.json({
        code: -1,
        reason: reason
      });
    }
  });

  app.post('/admin/disable-user', async function(req, res) {
    var error, id, ins, reason;
    id = req.body.id;
    try {
      ins = (await Nohm.factory('account', id));
      ins.property('isActive', false);
      await ins.save();
      return res.json({
        code: 0,
        message: 'update user,now user in disable-status.'
      });
    } catch (error1) {
      error = error1;
      reason = {
        thrown: error,
        nohm_said: ins.errors
      };
      return res.json({
        code: -1,
        reason: reason
      });
    }
  });

  app.put('/admin/del-user', async function(req, res) {
    var error, id, ins;
    ins = (await Nohm.factory('account'));
    // req.query.id be transimit from '/admin/list-users' page.  
    id = req.body.id;
    ins.id = id;
    try {
      await ins.remove();
    } catch (error1) {
      error = error1;
      return res.json({
        code: -1,
        'reason': JSON.stringify(ins.errors)
      });
    }
    return res.json({
      code: 0,
      'gala': 'remove #' + id + ' success.'
    });
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
        reason: '表单中含有非法字符.'
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
        reason: '管理员登录失败，原因：帐户不存在或者帐户被临时禁用或者帐户名与口令不匹配。'
      });
    }
  });

  app.get('/admin/login-success', function(req, res) {
    return res.render('admin-login-success.pug', {
      title: 'Administrator Role Entablished'
    });
  });

  app.get('/admin/checkout-daka', async function(req, res) {
    var aliases, ins, inss, ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/checkout-daka';
      return res.redirect(303, '/admin/login');
    }
    // query all user's name
    inss = (await accountModel.findAndLoad({
      role: 'user'
    }));
    aliases = (function() {
      var j, len, results1;
      results1 = [];
      for (j = 0, len = inss.length; j < len; j++) {
        ins = inss[j];
        results1.push(ins.property('alias'));
      }
      return results1;
    })();
    return res.render('admin-checkout-daka', {
      aliases: aliases,
      title: 'Checkout-One-User-DaKa'
    });
  });

  // route /daka database interaction
  app.get('/daka/one', async function(req, res) {
    var hashes, id, ids, ins, j, len, range, sorted, user;
    ({user, range} = req.query);
    ids = (await dakaModel.find({
      alias: user,
      utc_ms: {
        min: 0
      }
    }));
    sorted = (await dakaModel.sort({
      'field': 'utc_ms'
    }, ids));
    hashes = [];
    for (j = 0, len = sorted.length; j < len; j++) {
      id = sorted[j];
      ins = (await dakaModel.load(id));
      hashes.push(ins.allProperties());
    }
    return res.json(hashes);
  });

  app.get('/admin/list-user-daka', async function(req, res) {
    var alias, ins, inss, j, len, obj, ref, ref1, result;
    alias = req.query.alias;
    if (!alias) {
      return res.json('no special user,check and redo.');
    }
    if (!filter(alias)) {
      return res.json('has invalid char(s).');
    }
    // first,check role if is admin
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/list-user-daka?alias=' + alias;
      return res.redirect(303, '/admin/login');
    }
    inss = (await dakaModel.findAndLoad({
      alias: alias
    }));
    result = [];
    for (j = 0, len = inss.length; j < len; j++) {
      ins = inss[j];
      obj = ins.allProperties();
      result.push(obj);
    }
    return res.render('admin-list-user-daka', {
      alias: alias,
      title: 'List User DaKa Items',
      data: result
    });
  });

  app.get('/admin/list-users', async function(req, res) {
    var inss, ref, ref1, results;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'admin') {
      req.session.referrer = '/admin/list-users';
      return res.redirect(303, '/admin/login');
    }
    inss = (await accountModel.findAndLoad({
      'role': 'user'
    }));
    results = [];
    inss.forEach(function(one) {
      var obj;
      obj = {};
      obj.alias = one.property('alias');
      obj.role = one.property('role');
      obj.initial_timestamp = one.property('initial_timestamp');
      obj.password = one.property('password');
      obj.isActive = one.property('isActive');
      obj.id = one.id;
      return results.push(obj);
    });
    return res.render('admin-list-users', {
      title: 'Admin:List-Users',
      accounts: results
    });
  });

  app.get('/superuser/list-admins', async function(req, res) {
    var inss, ref, ref1, results;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'superuser') {
      req.session.referrer = '/superuser/list-admins';
      return res.redirect(303, '/superuser/login');
    }
    inss = (await accountModel.findAndLoad({
      'role': 'admin'
    }));
    results = [];
    inss.forEach(function(one) {
      var obj;
      obj = {};
      obj.alias = one.property('alias');
      obj.role = one.property('role');
      obj.initial_timestamp = one.property('initial_timestamp');
      obj.password = one.property('password');
      obj.id = one.id;
      return results.push(obj);
    });
    return res.render('superuser-list-admins', {
      title: 'List-Administrators',
      accounts: results
    });
  });

  app.get('/superuser/list-tickets/:category', function(req, res) {
    var pattern;
    pattern = [TICKET_PREFIX, 'hash', req.params.category, '*'].join(':');
    return redis.keys(pattern, function(err, keys) {
      var j, key, len, list;
      list = redis.multi();
      for (j = 0, len = keys.length; j < len; j++) {
        key = keys[j];
        list.hgetall(key);
      }
      return list.exec(function(err, replies) {
        if (err) {
          return res.json(err);
        } else {
          return res.render('superuser-list-tickets', {
            title: 'list tickets',
            tickets: replies
          });
        }
      });
    });
  });

  app.put('/superuser/del-admin', async function(req, res) {
    var error, id, ins;
    ins = (await Nohm.factory('account'));
    // req.query.id be transimit from '/superuser/list-admins' page.  
    id = req.query.id;
    ins.id = id;
    try {
      await ins.remove();
    } catch (error1) {
      error = error1;
      return res.json({
        code: -1,
        'reason': JSON.stringify(ins.errors)
      });
    }
    return res.json({
      code: 0,
      'gala': 'remove #' + id + ' success.'
    });
  });

  app.all('/superuser/daka-complement', function(req, res) {
    var formid, ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'superuser') {
      req.session.referrer = '/superuser/daka-complement';
      return res.redirect(303, '/superuser/login');
    }
    if (req.method === 'POST') {
      // client post via xhr,so server side use 'formidable' module
      formid = new formidable.IncomingForm;
      return formid.parse(req, async function(err, fields, files) {
        var j, len, obj, objs, response, responses;
        if (err) {
          return res.json({
            code: -1
          });
        } else {
          // store
          objs = convert(fields);
          responses = [];
//objs is an array,elements be made by one object
          for (j = 0, len = objs.length; j < len; j++) {
            obj = objs[j];
            response = (await complement_save(obj['combo'], obj));
            responses.push(response);
          }
          // responses example:[{},[{},{}],{}...]
          return res.json(responses);
        }
      });
    } else {
      return res.render('superuser-daka-complement', {
        title: 'Super User Daka-Complement'
      });
    }
  });

  app.get('/superuser/login', function(req, res) {
    // referrer will received from middle ware
    return res.render('superuser-login.pug', {
      title: 'Are You A Super?'
    });
  });

  app.get('/superuser/login-success', function(req, res) {
    return res.render('superuser-login-success.pug', {
      title: 'Super User Login!'
    });
  });

  app.post('/superuser/login', function(req, res) {
    var hash, itisreferrer, password;
    // initial sesson.auth
    initSession(req);
    ({password, itisreferrer} = req.body);
    hash = sha256(password);
    if (hash === superpass) {
      updateAuthSession(req, 'superuser', 'superuser');
      if (itisreferrer) {
        return res.redirect(303, itisreferrer);
      } else {
        return res.redirect(301, '/superuser/login-success');
      }
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

  app.get('/superuser/delete-all-daka-items', function(req, res) {
    var multi, ref, ref1;
    if (((ref = req.session) != null ? (ref1 = ref.auth) != null ? ref1.role : void 0 : void 0) !== 'superuser') {
      return res.json('wrong:must role is superuser.');
    }
    // delete all daka items,be cafeful.
    multi = redis.multi();
    return redis.keys(DAKA_WILDCARD, function(err, keys) {
      var j, key, len;
      for (j = 0, len = keys.length; j < len; j++) {
        key = keys[j];
        multi.del(key);
      }
      return multi.exec(function(err, replies) {
        return res.json(replies);
      });
    });
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

  
  // during learn css3,svg..,use this route for convient.
  app.use('/staticify/:viewname', function(req, res) {
    return res.render('staticify/' + req.params.viewname, {
      title: 'it is staticify page'
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

  // updateAuthSession is a help function
  // this method be invoked by {user|admin|superuser}/login (post request)
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
    var dbpassword, dbrole, isActive, item, items, match_result, warning;
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
      isActive = item.property('isActive');
      warning = '';
      if (dbpassword === '8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414') {
        warning = 'should change this simple/initial/templory password immediately.';
      }
      match_result = isActive && ((hashise(password)) === dbpassword) && (dbrole === role);
      return {
        match_result: match_result,
        warning: warning
      };
    }
  };

  // for authenticate super user password.
  sha256 = function(plain) {
    return crypto.createHash('sha256').update(plain).digest('hex');
  };

  // help func convert,can convert formidable's fields object to an object arrary(for iterator store in redis).
  convert = function(fields) {
    var i, matched, post, pre, results, v;
    results = [];
    for (i in fields) {
      v = fields[i];
      matched = i.match(/(\D*)(\d*)$/);
      pre = matched[1];
      post = matched[2];
      if ((indexOf.call(Object.keys(results), post) >= 0) === false) {
        results[post] = {};
      }
      results[post][pre] = v;
    }
    return results;
  };

  // help function - complement_save()
  // complement_save handle single object(one form in client side).
  complement_save = async function(option, fieldobj) {
    var response, response1, response2, single_save, standard, standard1, standard2;
    // option always is uploaded object's field - option
    response = void 0;
    
    // inner help function - single_save()
    single_save = async function(standard) {
      var error, ins;
      ins = (await Nohm.factory('daily'));
      ins.property(standard);
      try {
        await ins.save();
      } catch (error1) {
        error = error1;
        console.dir(error);
        return {
          'item-id': ins.id,
          'saved': false,
          reason: ins.errors
        };
      }
      return {
        'item-id': ins.id,
        'saved': true
      };
    };
    switch (option) {
      case 'option1':
        standard = {
          alias: fieldobj.alias,
          utc_ms: Date.parse(fieldobj['first-half-']),
          whatistime: fieldobj['first-half-'],
          dakaer: 'superuser',
          category: 'entry',
          browser: req.headers['user-agent']
        };
        response = (await single_save(standard));
        break;
      case 'option2':
        standard = {
          alias: fieldobj.alias,
          utc_ms: Date.parse(fieldobj['second-half-']),
          whatistime: fieldobj['second-half-'],
          dakaer: 'superuser',
          category: 'exit',
          browser: req.headers['user-agent']
        };
        response = (await single_save(standard));
        break;
      case 'option3':
        standard1 = {
          alias: fieldobj.alias,
          utc_ms: Date.parse(fieldobj['first-half-']),
          whatistime: fieldobj['first-half-'],
          dakaer: 'superuser',
          browser: req.headers['user-agent'],
          category: 'entry'
        };
        standard2 = {
          alias: fieldobj.alias,
          utc_ms: Date.parse(fieldobj['second-half-']),
          whatistime: fieldobj['second-half-'],
          dakaer: 'superuser',
          browser: req.headers['user-agent'],
          category: 'exit'
        };
        
        // save 2 instances.
        response1 = (await single_save(standard1));
        response2 = (await single_save(standard2));
        response = [response1, response2];
        break;
      default:
        response = {
          code: -1,
          reason: 'unknow status.'
        };
    }
    return response;
  };

  // help function - 'ensure'
  ensure = function(req, who) {
    return req.session.auth;
  };

}).call(this);
