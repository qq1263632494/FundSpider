// Generated by CoffeeScript 2.4.1
(function() {
  var cheerio, count, db, fs, htmlData, htmlDataLength, http, iconv, insert, insert_redis, options, redis, reg, request, sqlite;

  request = require('request');

  cheerio = require('cheerio');

  fs = require('fs');

  iconv = require('iconv-lite');

  http = require('http');

  console.log('dbg0');

  sqlite = require('sqlite3');

  redis = require('redis');

  options = {
    url: 'http://fund.eastmoney.com/allfund.html#0',
    method: 'GET'
  };

  htmlData = [];

  htmlDataLength = 0;

  count = 0;

  reg = /.\d+/;

  db = new sqlite.Database('/home/wang/文档/database/data.db');

  insert = function(ticket, name) {
    return db.serialize(function() {
      var stmt;
      stmt = db.prepare('INSERT INTO fund VALUES(?, ?)');
      stmt.run(ticket, name);
      return stmt.finalize();
    });
  };

  insert_redis = function(ticket, name) {
    var client;
    client = redis.createClient('6379', '127.0.0.1');
    client.set(ticket, name);
    return client.quit();
  };

  http.get('http://fund.eastmoney.com/allfund.html#0', function(res) {
    res.on('data', function(data) {
      htmlData.push(data);
      htmlDataLength += data.length;
      return count++;
    });
    return res.on('end', function() {
      var $, bufferHtmlData, decodeHtmlData;
      bufferHtmlData = Buffer.concat(htmlData, htmlDataLength);
      decodeHtmlData = iconv.decode(bufferHtmlData, 'gb2312');
      $ = cheerio.load(decodeHtmlData);
      return $('ul.num_right').each(function(index, element) {
        return $(element).children().each(function(ind, ele) {
          return $(ele).children().each(function(i, e) {
            return $(e).children().each(function(i_t, e_t) {
              var data, data_name, data_ticket;
              data = e_t.children[0].data;
              if (!data.match('基金吧')) {
                if (!data.match('档案')) {
                  data_name = data.substr(8);
                  data_ticket = reg.exec(data)[0].substr(1);
                  return insert(data_ticket, data_name);
                }
              }
            });
          });
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=spider.js.map
