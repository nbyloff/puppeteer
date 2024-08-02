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
3. Wait for process to complete and view `pdf/bugs.pdf`

Click the first table of contents link on page 2 in the PDF. It no longer takes you to the correct position in the document.

Test HTML located in `html/demo.html`


When viewing the PDF output with a text editor, references found related to H4 section tags have a negative number. 
If they are changed to positive, the document at least goes to the correct page, but not the exact position. 
````
43 0 obj
<</section1 [11 0 R /XYZ 72 -700.08002 0]
/section2 [38 0 R /XYZ 72 -8977.8301 0]>>
endobj
````
