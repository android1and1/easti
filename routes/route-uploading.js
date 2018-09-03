// Generated by CoffeeScript 2.2.2
(function() {
  var express, formidable, router;

  express = require('express');

  router = express.Router();

  formidable = require('formidable');

  router.get('/iphone-uploading', function(req, res, next) {
    return res.render('uploading/iphone-uploading');
  });

  router.post('/iphone-uploading', function(req, res, next) {
    var form, ifred;
    form = new formidable.IncomingForm;
    ifred = false;
    form.on('field', function(name, value) {
      if (name === 'ifenc' && value === 'on') {
        ifred = true;
      }
      return console.log('field name', name, ':', value);
    });
    form.on('file', function(name, value) {
      return console.log('FILE name', name, ':', value);
    });
    return form.parse(req, function() {
      if (ifred) {
        return res.redirect(302, '/uploading/successfully'); // 302 is default code.
      } else {
        return res.json({
          'server-said': 'upload success'
        });
      }
    });
  });

  router.get('/successfully', function(req, res, next) {
    return res.render('uploading/successfully', {
      title: 'iphone-uploading-success'
    });
  });

  module.exports = router;

}).call(this);
