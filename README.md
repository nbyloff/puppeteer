# puppeteer

Short example showing how building a PDF with puppeteer in a Docker container will timeout if using the paged.js library
Checkout this project and follow steps below

1. Build image
````shell
docker build --build-arg UID=$(id -u) -t bugs_node .
````
2.  Run the docker-compose.yml
````shell
docker-compose up -d
````

Once up, you should be able to view the working demo in your browser here: http://demo.test:8080/demo.html

The Dockerfile we just built is running the `demo.js` script to build the PDF. You can watch the progress here:

````shell
docker logs -f demo_node
````
You should see it timeout after 30 seconds.

In tracing the issue, I came to this function in https://unpkg.com/pagedjs@0.4.3/dist/paged.polyfill.js

````javascript
/**
 * Creates a new pending promise and provides methods to resolve or reject it.
 * From: https://developer.mozilla.org/en-US/docs/Mozilla/JavaScript_code_modules/Promise.jsm/Deferred#backwards_forwards_compatible
 * @returns {object} defered
 */
function defer() {
        this.resolve = null;
        this.reject = null;
        console.log('started UUID');
        this.id = UUID();
        console.log('finished UUID'); // IT NEVER PRINTS THIS, so it doesn't get passed UUID in Docker
        this.promise = new Promise((resolve, reject) => {
            this.resolve = resolve;
            this.reject = reject;
        });
        Object.freeze(this);
    }
````

So I looked at the `UUID` function
````javascript
/**
 * Generates a UUID
 * based on: http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript
 * @returns {string} uuid
 */
function UUID() {
    var d = new Date().getTime();
    if (typeof performance !== "undefined" && typeof performance.now === "function") {
        d += performance.now(); //use high-precision timer if available
    }
    var id = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
        var r = (d + Math.random() * 16) % 16 | 0;
        d = Math.floor(d / 16);
        return (c === "x" ? r : (r & 0x3 | 0x8)).toString(16);
    });
    return id;
}
````

I checked that stackoverflow thread in the function comments and found this UUID function
````javascript
function uuidv4() {
  return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, c =>
    (+c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> +c / 4).toString(16)
  );
}
````

When I replace the paged.js `UUID` function with this one, everything magically works. But I cannot figure out why...

There is a local copy of paged.polyfill.js in this project under `html/demo` folder to test changes instead of using the CDN version.