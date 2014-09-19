import QtQuick 2.0
import HttpServer 1.0

HttpServer {
    id: server
    Component.onCompleted: listen("127.0.0.1", 5000)
    onNewRequest: {
        if (request.url.toString().match(/\/update\?/)) {
            editor.text = decodeURI(request.url.toString().replace(/\/update\?/, "")).replace(/%23/g, '#');
            console.log(editor.text)
            response.writeHead(200)
            response.end()
            reloadView();
        }
        else if (request.url.toString().match(/^\/ace/)) {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "qrc://"+request.path, true);
            xhr.onreadystatechange = function()
            {
                if ( xhr.readyState == xhr.DONE) {
                    response.writeHead(200)
                    response.write(xhr.responseText)
                    response.end()
                }
            }
            xhr.send();
        }
        else if (request.url.toString().match(/^\/\?/)) {
            response.writeHead(200)
            response.write(editor.text)
            response.end()
        }
        else {
            response.writeHead(404)
            response.end()
        }
    }
}
