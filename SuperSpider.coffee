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

insert = (t, d, v, r)->
    db.serialize ()->
        stmt = db.prepare 'INSERT INTO info VALUES(?, ?, ?, ?)'
        stmt.run t, d, v, r, (err)->
        stmt.finalize()

db.each "SELECT ticket FROM fund", (err, row)->
    tk = row.ticket
    await pool.use (instance)->
        page = await instance.newPage()
        url = "http://fundf10.eastmoney.com/jjjz_#{tk}.html"
        await page.goto url
        html = await page.content()
        await page.close()
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
                #if i is LIMIT_TIMES
                    # pool.drain().then(() => pool.clear())