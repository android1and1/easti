// Generated by CoffeeScript 2.1.1
(function() {
  var PREFIX, Redis, express, formidable, fs, nohm, path, router, schema;

  fs = require('fs');

  path = require('path');

  express = require('express');

  router = express.Router();

  formidable = require('formidable');

  Redis = require('redis');

  nohm = (require('nohm')).Nohm;

  schema = require('../modules/sche-tricks.js');

  PREFIX = 'EastI';

  // the first time,express working with nohm - redis orm library
  router.get('/', function(req, res, next) {
    var redis;
    redis = Redis.createClient();
    redis.on('error', function(err) {
      return console.log('debug info::route-tricks::', err.message);
    });
    return redis.on('connect', async function() {
      var i, ids, item, items, j, len;
      nohm.setClient(redis);
      nohm.setPrefix(PREFIX);
      ids = (await schema.find());
      items = [];
      if (ids.length > 0) {
        for (j = 0, len = ids.length; j < len; j++) {
          i = ids[j];
          item = (await schema.load(i));
          items.push(item.allProperties());
        }
        return res.render('tricks/index.pug', {
          length: items.length,
          items: items
        });
      } else {
        return res.render('tricks/index.pug', {
          idle: true
        });
      }
    });
  });

  router.get('/add1', function(req, res, next) {
    var redis;
    redis = Redis.createClient();
    redis.on('error', function(err) {
      return console.log('debug info::route-tricks::', err.message);
    });
    redis.on('connect', async function() {
      var ids;
      nohm.setClient(redis);
      nohm.setPrefix(PREFIX);
      return ids = (await schema.find());
    });
    return res.render('tricks/add1.pug');
  });

  router.post('/add1', function(req, res, next) {
    return res.render('tricks/successfully.pug', {
      title: 'tricks-successfully',
      status: 'ok'
    });
  });

  module.exports = router;

}).call(this);
