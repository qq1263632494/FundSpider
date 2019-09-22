const $ = require('cheerio');
const puppeteer = require('puppeteer');
const url = 'https://juejin.im/books';

async function run(params) {
    //打开一个浏览器
    const browser = await puppeteer.launch();
    // 打开一个页面
    const page = await browser.newPage();
    await page.goto(url);
    const html = await page.content();
    const data = $('table.w782.comm.lsjz', html);
}
run();