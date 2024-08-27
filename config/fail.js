import puppeteer from "puppeteer";


async function main() {
    const browser = await puppeteer.launch({
        headless: 'new',
        timeout: 0,
        ignoreHTTPSErrors: true,
        args: [
            //'--remote-debugging-port=9222',
            //'--remote-debugging-address=0.0.0.0',
            '--no-sandbox',
            '--disable-web-security',   // maybe fixes issues related to cors, etc
            '--disable-gpu',
            '--disable-setuid-sandbox',
            '--disable-dev-shm-usage',
        ],
    });

    const page = await browser.newPage();
    page.on('console', message =>
        console.log(`${message.type().substr(0, 3).toUpperCase()} ${message.text()}`))
        .on('pageerror', ({message}) => console.log(message))
        .on('response', response =>
            console.log(`${response.status()} ${response.url()}`))
        .on('requestfailed', request =>
            console.log(`${request.failure().errorText} ${request.url()}`))

    await page.goto('http://demo.test:8080/fail.html');

    await page.content();
    //await page.waitForFunction('window.report == "ready"');
    await page.screenshot({path: 'pdf/screenshot.png'});

    const requestOptions = {};
    requestOptions.path = '/home/web/pdf/bugs.pdf';
    requestOptions.waitUntil = 'networkIdle2';
    requestOptions.printBackground = true;
    requestOptions.format = 'A4';
    const result = await page.pdf(requestOptions);

    await page.close();
    await browser.close();

}

main();
