import QtQuick 2.0
import QtQuick.Window 2.0
import HttpServer 1.0
//import QtQuick.LocalStorage 2.0
import DocumentHandler 1.0

Window {
    id: root
    width: Screen.width
    height: Screen.height
    visible: true
    title: "Terrarium - Live QML Editor and Viewer"

    // FIXME: build flag and detection 
    property bool iOS: (Screen.width == 1024 || Screen.width == 768)
    property variant lineNumberPadding: iOS ? 17 : 20 
    property variant httpServer: {}
    property variant httpd: {}

    Component.onCompleted: {
        httpServer = Qt.createComponent("HttpServer.qml");
        if (httpServer.status == Component.Ready) {
            httpd = httpServer.createObject(root, {'id': 'httpd'});
            timer.running = true;
        } else { 
            console.log('error loading http server')
        }

    }

    /*
    Component.onCompleted: {
        var db = getDatabase();
        db.transaction(
                function(tx) {
                    var result = tx.executeSql("SELECT * FROM previous");
                    for (var i=0; i < result.rows.length; i++) {
                        editor.text = result.rows.item(i).editor
                    }
                    tx.executeSql("DROP TABLE IF EXISTS previous");
                }
        );
    }

    Component.onDestruction: {
        var db = getDatabase();
        db.transaction(
            function(tx) { tx.executeSql('insert into previous values (?);', editor.text); }
        );
    }

    function getDatabase() {
        var db = LocalStorage.openDatabaseSync("terrarium-app", "0.1", "history db", 100000);
        db.transaction(function(tx) {tx.executeSql('CREATE TABLE IF NOT EXISTS previous (editor TEXT)'); });
        return db;
    }
    */

    Timer {
        id: timer
        interval: 500; running: false; repeat: false
        onTriggered: reloadView() 


    }

    function reloadView() {
        viewLoader.setSource('http://localhost:5000/?'+Math.random()) // workaround for cache
    }

    Item {
        width: root.width/2
        height: root.height
        anchors { top: parent.top; left: background.right; bottom: parent.bottom }

        Rectangle {
            color: 'grey'
            visible: errorMessage.text != ""
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: Screen.top
            anchors.bottomMargin: errorMessage.text == "" ? 0 : -height
            width: parent.width
            height: errorMessage.height 

            Behavior on anchors.bottomMargin {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }

            Text {
                id: errorMessage
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20; topMargin: 10 }
                font.pointSize: 20
                wrapMode: Text.WordWrap
                text: ""
            }
        }

        Loader {
            id: viewLoader
            anchors.fill: parent
            property variant errorLineNumber: 0
            onStatusChanged: {
                if (viewLoader.status == Loader.Error) {
                    errorMessage.text = viewLoader.errorString().replace(/http:\/\/localhost:5000\/\?.*?:/g, "Line: ");

                    // restart http server when connection refused 
                    var connectionRefused = /Connection refused/;
                    if (connectionRefused.test(errorMessage.text)) {
                        httpd.destroy();
                        httpd = httpServer.createObject(root, {'id': 'httpd'});
                        reloadView();
                    }

                    errorLineNumber = errorMessage.text.match(/^Line: (.*?) /)[1];
                    lineNumberRepeater.itemAt(errorLineNumber - 1).bgcolor = 'red'
                } else { 
                    errorMessage.text = ""; 
                    if (errorLineNumber > 0)
                    lineNumberRepeater.itemAt(errorLineNumber - 1).bgcolor = 'transparent'
                }
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

            Column {
                id: lineNumber
                anchors { margins: 20; left: parent.left; top: parent.top } 
                spacing: iOS ? 3 : -1 
                Repeater { 
                    id: lineNumberRepeater
                    model: editor.lineCount
                    Text { 
                        property alias bgcolor: rect.color
                        width: 20
                        text: index + 1
                        color: 'lightgray'
                        font.pointSize: editor.font.pointSize 
                        horizontalAlignment: TextEdit.AlignHCenter
                        Rectangle {
                            id: rect
                            color: 'transparent'
                            anchors.fill: parent
                            opacity: 0.5
                        }
                    }
                }
            }

            Rectangle {
                id: editorCurrentLineHighlight
                anchors {
                    left: lineNumber.right
                    margins: lineNumberPadding 
                }
                visible: editor.focus
                width: editor.width
                height: editor.cursorRectangle.height
                y: editor.cursorRectangle.y + lineNumberPadding
                color: '#454545'
            }

            TextEdit {
                id: editor
                anchors { 
                    margins: lineNumberPadding
                    left: lineNumber.right; right: parent.right; top: parent.top 
                } 
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
            } // end of editor

        }
    }
}
