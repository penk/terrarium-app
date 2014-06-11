import QtQuick 2.0
import QtQuick.Window 2.0

import HttpServer 1.0
import DocumentHandler 1.0

Window {
    id: root
    width: Screen.width
    height: Screen.height
    visible: true
    title: "QML Playgrounds"

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

    Timer {
        id: timer
        interval: 500; running: true; repeat: false
        onTriggered: viewLoader.setSource('http://localhost:5000/?'+Math.random()) // workaround for cache
    }

    Item {
        width: root.width/2
        height: root.height
        anchors { top: parent.top; left: background.right; bottom: parent.bottom }

        Rectangle {
            color: 'grey'
            visible: errorMessage.text != ""
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: errorMessage.text == "" ? 0 : -height
            width: parent.width
            height: errorMessage.height 

            Behavior on anchors.bottomMargin {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }

            Text {
                id: errorMessage
                anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20; top: parent.top; topMargin: 10 }
                font.pointSize: 20
                wrapMode: Text.WordWrap
                text: ""
            }
        }

        Loader {
            id: viewLoader
            anchors.fill: parent
            onStatusChanged: {
                if (viewLoader.status == Loader.Error) {
                    errorMessage.text = viewLoader.errorString().replace(/http:\/\/localhost:5000\/\?.*?:/g, "Line: ");
                } else { errorMessage.text = "" }
            }
        }
    }

    Rectangle { 
        id: background
        width: root.width/2
        height: root.height
        anchors { top: parent.top; left: parent.left; bottom: parent.bottom }
        color: '#1d1f21'

        Flickable {
            anchors { fill: parent } 
            flickableDirection: Flickable.VerticalFlick
            contentWidth: parent.width
            contentHeight: editor.height
            clip: true

            TextEdit {
                id: editor
                //width: parent.width
                anchors { margins: 20; left: parent.left; right: parent.right; top: parent.top } 
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere;
                renderType: Text.NativeRendering
                onTextChanged: timer.restart(); 

                // FIXME: stupid workaround for indent
                Keys.onPressed: {
                    if (event.key == Qt.Key_BraceRight) {
                        editor.select(0, cursorPosition)
                        var previousContent = editor.selectedText.split(/\r\n|\r|\n/)
                        editor.deselect()
                        var currentLine = previousContent[previousContent.length - 1]
                        var leftBrace = /{/, rightBrace = /}/;
                        if (!leftBrace.test(currentLine)) {
                            editor.remove(cursorPosition, cursorPosition - currentLine.length);
                            currentLine = currentLine.toString().replace(/ {1,4}$/, "");
                            editor.insert(cursorPosition, currentLine);
                        }
                    }
                }
                Keys.onReturnPressed: {
                    editor.select(0, cursorPosition)
                    var previousContent = editor.selectedText.split(/\r\n|\r|\n/)
                    editor.deselect()
                    var currentLine = previousContent[previousContent.length - 1]
                    var leftBrace = /{/, rightBrace = /}/;
                    editor.insert(cursorPosition, "\n")
                    var whitespaceAppend = currentLine.match(new RegExp(/^[ \t]*/))  // whitespace
                    if (leftBrace.test(currentLine)) // indent
                        whitespaceAppend += "    "; 
                    editor.insert(cursorPosition, whitespaceAppend)
                }

                // style from Atom dark theme: 
                // https://github.com/atom/atom-dark-syntax/blob/master/stylesheets/syntax-variables.less
                color: '#c5c8c6'
                selectionColor: '#444444'
                selectByMouse: true
                font { pointSize: 18; family: 'Courier New' }

                text: documentHandler.text

                DocumentHandler {
                    id: documentHandler
                    target: editor
                    Component.onCompleted: { 
                        documentHandler.text = "import QtQuick 2.0\n\nRectangle { \n    color: '#FEEB75'" + 
                            "\n    Text { \n        anchors.centerIn: parent" + 
                            "\n        text: 'Hello, World!' \n    } \n}"
                    }
                }
            }
        }
    }
}
