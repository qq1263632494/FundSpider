iconv = require 'iconv-lite'
cheerio = require 'cheerio'
puppeteer = require 'puppeteer'
fs = require 'fs'
sqlite = require 'sqlite3'



tgt = 'table.w782.comm.lsjz'
reg = /d/
db = new sqlite.Database '/home/wang/文档/database/data.db'

insert = (t, d, v, r)->
    db.serialize ()->
        stmt = db.prepare 'INSERT INTO info VALUES(?, ?, ?, ?)'
        stmt.run t, d, v, r, (err)->
            fs.writeFile 'bug.log', err, {'flag':'a'}, (er)->
        stmt.finalize()
run = (tk)->
    url = "http://fundf10.eastmoney.com/jjjz_#{tk}.html"
    browser = await puppeteer.launch()
    page = await browser.newPage()
    await page.goto url
    html = await page.content()
    await browser.close()
    $ = await cheerio.load html
    tbody = $(tgt).children()[1]
    $(tbody).children().each (ind, ele)->
        tds = $(ele).children()
        # 日期
        day = $(tds[0]).text()
        # 单位净值
        value = $(tds[1]).text()[0..5]
        # 日增长率
        rate = $(tds[3]).text()
        insert(tk, day, value, rate)

db.serialize ()->
    db.each "SELECT ticket FROM fund LIMIT 51 OFFSET 150", (err, row)->
        ticket = row.ticket
        run(ticket)