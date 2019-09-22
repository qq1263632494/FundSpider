request = require 'request'
cheerio = require 'cheerio'
fs = require 'fs'
iconv = require 'iconv-lite'
http = require 'http'
console.log('dbg0')
sqlite = require 'sqlite3'
redis = require 'redis'


options = {
    url: 'http://fund.eastmoney.com/allfund.html#0',
    method: 'GET'
};

htmlData = []
htmlDataLength = 0
count = 0
reg = /.\d+/
db = new sqlite.Database '/home/wang/文档/database/data.db'
insert = (ticket, name)->
    db.serialize ()->
        stmt = db.prepare 'INSERT INTO fund VALUES(?, ?)'
        stmt.run ticket, name
        stmt.finalize()


insert_redis = (ticket, name)->
    client = redis.createClient('6379', '127.0.0.1')
    client.set ticket, name
    client.quit()


http.get 'http://fund.eastmoney.com/allfund.html#0', (res)->
    res.on 'data', (data)->
        htmlData.push data
        htmlDataLength += data.length
        count++
    res.on 'end', ()->
        bufferHtmlData = Buffer.concat(htmlData, htmlDataLength)
        decodeHtmlData = iconv.decode bufferHtmlData, 'gb2312'
        $ = cheerio.load decodeHtmlData
        $('ul.num_right').each (index, element)->
            $(element).children().each (ind, ele)->
                $(ele).children().each (i, e)->
                    $(e).children().each (i_t, e_t)->
                        data = e_t.children[0].data
                        if not data.match '基金吧'
                            if not data.match '档案'
                                data_name = data.substr 8
                                data_ticket = reg.exec(data)[0].substr 1
                                insert data_ticket, data_name