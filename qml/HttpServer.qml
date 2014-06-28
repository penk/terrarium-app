import QtQuick 2.0
import HttpServer 1.0

HttpServer {
    id: server
    Component.onCompleted: listen("127.0.0.1", 5000)
    onNewRequest: {
        var route = /^\/\?/;
        if ( route.test(request.url) ) {
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
