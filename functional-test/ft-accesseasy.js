// Generated by CoffeeScript 2.3.1
(function() {
  var Browser, app, browser, http, server;

  Browser = require('zombie');

  Browser.localhost('example.com', 4140);

  browser = new Browser;

  app = require('../app');

  http = require('http');

  server = http.Server(app);

  server.listen(4140);

  server.on('error', function(err) {
    return console.error(err);
  });

  // sometimes it will help(below line)
  //browser.waitDuration = '30s'
  describe('zombie ability display::', function() {
    after(function() {
      return server.close();
    });
    describe('access index page should success::', function() {
      before(function() {
        return browser.visit('http://example.com');
      });
      it('should access page successfully::', function() {
        return browser.assert.success();
      });
      //No Need This Time
      //console.log browser.html()
      it('should has 2 h4 tags::', function() {
        return browser.assert.elements('h4', 2);
      });
      return it('page title is "I see You"::', function() {
        return browser.assert.text('title', 'I see You');
      });
    });
    return describe('access alpha route test page(alpha-1) should success::', function() {
      before(function() {
        return browser.visit('http://example.com/alpha/alpha-1');
      });
      return it('should access access successfully::', function() {
        browser.assert.success();
        return browser.assert.status(200);
      });
    });
  });

}).call(this);
