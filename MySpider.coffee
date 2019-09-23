cheerio = require 'cheerio'
initPuppeteerPool = require './puppeteer-pool.js'
pool = initPuppeteerPool {
    puppeteerArgs:{
        ignoreHTTPSErrors:true,
        headless:true,
        timeout:0,
        pipe:true
    }
}
spyfun = (url, callback)->
    await pool.use (instance)->
        page = await instance.newPage()
        await page.goto url
        html = await page.content()
        await page.close()
        callback(html)

module.exports = spyfun