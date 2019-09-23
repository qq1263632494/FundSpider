class Main
    data = [0..10]
    each:(callback)->
        for d in data
            callback(d)
m = new Main()
m.each (d)->
    console.log d
console.log 'fk'
iconv = require 'iconv-lite'
cheerio = require 'cheerio'
puppeteer = require 'puppeteer'
fs = require 'fs'
sqlite = require 'sqlite3'
initPuppeteerPool = require './puppeteer-pool.js'
pool = initPuppeteerPool {
    puppeteerArgs:{
        ignoreHTTPSErrors:true,
        headless:true,
        timeout:0,
        pipe:true
    }
}

tgt = 'table.w782.comm.lsjz'
db = new sqlite.Database '/home/wang/文档/database/data.db'

insert = (t, d, v)->
    db.serialize ()->
        stmt = db.prepare 'INSERT INTO info2 VALUES(?, ?, ?)'
        stmt.run t, d, v, (err)->
        stmt.finalize()

run = (html, tk)->
    $ = await cheerio.load html
    tbody = $(tgt).children()[1]
    $(tbody).children().each (ind, ele)->
        tds = $(ele).children()
            # 日期
        day = $(tds[0]).text()
            # 单位净值
        value = $(tds[1]).text()[0..5]
            # 日增长率
        insert(tk, day, value)


db.serialize ()->
    iter_times = 0
    LIMIT = 5
    db.get "SELECT COUNT(*) AS num FROM fund", (err, res)->
        console.log res
        LIMIT = res.num

    db.each "SELECT ticket FROM fund", (err, row)->
        tk = row.ticket
        await pool.use (instance)->
            page = await instance.newPage()
            url = "http://fundf10.eastmoney.com/jjjz_#{tk}.html"
            await page.goto url
            html = await page.content()
            await page.close()
            await run(html, tk)
            iter_times += 1
            if iter_times is LIMIT
                console.log 'ok'
                pool.drain().then(() => pool.clear())
                console.log 'done'
