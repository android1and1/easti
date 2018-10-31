// Generated by CoffeeScript 2.3.1
(function() {
  // first check if redis-server is running,if at macbook air,it is not running as a service
  // we should manually start it,
  // in this standalone test,we can run "redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"
  var assert, nohm, pgrep, redis, schema, spawn;

  ({spawn} = require('child_process'));

  pgrep = spawn('/usr/bin/pgrep', ['redis-server', '-l']);

  pgrep.on('close', function(code) {
    if (code !== 0) {
      console.log('should start redis-server ./redisdb/redis.conf first(special for apple macbook air user).');
      console.log('alternatively,can run this:');
      console.log('\t\t"redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"');
      return process.exit(1);
    }
  });

  assert = require('assert');

  redis = require('redis').createClient();

  nohm = require('nohm').Nohm;

  schema = nohm.model('trythem', {
    idGenerator: 'increment',
    properties: {
      tryabout: {
        type: 'string',
        validations: ['notEmpty'],
        unique: true
      },
      trycontent: {
        type: 'string',
        validations: ['notEmpty']
      },
      trymoment: {
        type: 'timestamp',
        defaultValue: Date.parse(new Date)
      },
      tryvisits: {
        type: 'integer',
        index: true,
        defaultValue: 0
      }
    }
  });

  describe('custom function try test::', function() {
    before(async function() {
      var db, error;
      nohm.setPrefix('tryNohm');
      nohm.setClient(redis);
      db = (await nohm.factory('trythem'));
      db.property('tryabout', 'story1');
      db.property('trycontent', 'long long ago\nthere was a ..\n');
      db.property('tryvisits', 2222);
      try {
        return db.save();
      } catch (error1) {
        error = error1;
        return Promise.resolved('be catched:::' + error);
      }
    });
    after(function() {
      // clean all,via node-redis
      return redis.keys('tryNohm*', function(err, keylist) {
        var i, key, len, results;
        results = [];
        for (i = 0, len = keylist.length; i < len; i++) {
          key = keylist[i];
          results.push(redis.del(key));
        }
        return results;
      });
    });
    it('should create 1 item::', async function() {
      var db, ids;
      // find() will list all items.
      db = (await nohm.factory('trythem'));
      ids = (await db.find());
      return assert.equal(ids.length, 1);
    });
    it('should correct attribute of saved object::', async function() {
      var db;
      db = (await nohm.factory('trythem'));
      return db.load(1).then(function(something) {
        return assert.equal(something.tryvisits, 2222);
      });
    });
    // or
    //assert.equal db.allProperties().tryvisits,2222
    it('should create 2nd item::', function() {
      var db;
      db = new schema;
      db.property({
        tryabout: 'story2',
        trycontent: 'same story,from\nlong long ago...\n',
        tryvisits: 1200
      });
      return db.save().then(function() {
        return db.find().then(function(list) {
          return assert.equal(list.length, 2);
        });
      });
    });
    return it('should find story2 item::', async function() {
      var db, idlist, obj, theid;
      db = (await nohm.factory('trythem'));
      idlist = (await db.find({
        tryvisits: {
          max: 2000
        }
      }));
      theid = idlist[0];
      obj = (await db.load(theid));
      return assert.equal(obj.tryabout, 'story2');
    });
  });

}).call(this);