const $ = require('cheerio');
const puppeteer = require('puppeteer');
const url = 'https://juejin.im/books';
//打开一个浏览器
let browser;
async function run(params) {
    // 打开一个页面
    for(let i=0; i<3; i++){
        const page = await browser.newPage();
        await page.goto(url);
        const html = await page.content();
        await page.close();
        console.log(html);
    }
}
async function f() {
    browser = await puppeteer.launch();
    await run();
    browser.close();
}
f();