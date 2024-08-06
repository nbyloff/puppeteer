# puppeteer

Short example showing how internal anchor tags no longer move the user to the correct page in the HTML-->PDF created
with puppeteer.

1. Build image
````shell
docker build --build-arg UID=$(id -u) -t bugs_node .
````
2.  Run the docker-compose.yml
````shell
docker-compose up -d
````

There are two `console.log` statements in a <script> tag in the `html/index.html` file that is loaded. "loading" when 
it enters the script tag, and "loaded" when paged.js is finished rendering the page. "loaded" is never called when 
using docker & puppeteer, but if you load the page in your browser, it works perfectly.

If I comment out the `paged.polyfill.js` script, the `demo.js` builds as expected, producting a `pdf/bugs.pdf` document.

Open this page to see what the final result should be.
http://demo.test:8080