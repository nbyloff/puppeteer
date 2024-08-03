import puppeteer from "puppeteer";

async function main() {
    const browser = await puppeteer.launch({
        headless: 'new',
        timeout: 0,
        ignoreHTTPSErrors: true,
        executablePath: '/usr/bin/chromium',
    });

    const page = await browser.newPage();
    await page.goto('http://demo.test:8080/');

    await page.content();
    await page.waitForFunction('window.report == "ready"');
    //await page.screenshot({path: 'screenshot.png'});

    const requestOptions = {};
    requestOptions.path = '/Users/nathanbyloff/code/puppeteer/pdf/bugs2.pdf';
    requestOptions.waitUntil = 'networkIdle2';
    requestOptions.printBackground = true;
    requestOptions.format = 'A4';
    const result = await page.pdf(requestOptions);

    await page.close();
    await browser.close();

}

main();
