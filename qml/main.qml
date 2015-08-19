import QtQuick 2.0
import QtQuick.Window 2.0

import HttpServer 1.0
import QtQuick.LocalStorage 2.0
import DocumentHandler 1.0

Window {
    id: root
    width: Screen.width
    height: Screen.height
    visible: true
    title: "Terrarium - UI Prototyping Tool for Coders"

    property variant httpServer: {}
    property variant httpd: {}
    property string splitState: (root.width * scaleRatio > 600) ? 'splitted' : 'editor'
    property variant os_type: { '0': 'macx', '1': 'ios', '2': 'android', '3': 'linux', '4': 'default' }
    property variant platformSetting: {
        'ios': { 'lineNumberSpacing': -1, 'lineNumberPadding' : 20, 'defaultFont': 'Courier New' },
        'macx': { 'lineNumberSpacing': -1, 'lineNumberPadding' : 20, 'defaultFont': 'Menlo' },
        'android': { 'lineNumberSpacing': 0, 'lineNumberPadding' : 20, 'defaultFont': 'Droid Sans Mono' },
        'linux': { 'lineNumberSpacing': 0, 'lineNumberPadding' : 20, 'defaultFont': 'Droid Sans Mono' },
        'default': { 'lineNumberSpacing': 0, 'lineNumberPadding' : 20, 'defaultFont': 'Droid Sans Mono' },
    }
    property variant lineNumberPadding: platformSetting[os_type[platform]]['lineNumberPadding']
    property variant lineNumberSpacing: platformSetting[os_type[platform]]['lineNumberSpacing']
    property variant scaleRatio: Screen.pixelDensity.toFixed(0) / 5

    FontLoader { id: fontAwesome; source: "fontawesome-webfont.ttf" }

    Component.onCompleted: {

        // FIXME: workaround for Ubuntu Phone
        if ((scaleRatio < 1) && (os_type[platform]==='linux')) scaleRatio = 2;

        httpServer = Qt.createComponent("HttpServer.qml");
        if (httpServer.status == Component.Ready) {
            httpd = httpServer.createObject(root, {'id': 'httpd'});
            timer.running = true;
        } else {
            console.log('error loading http server')
        }
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
        saveContent();
    }

    function saveContent() {
        var db = getDatabase();
        db.transaction(
            function(tx) { tx.executeSql('insert into previous values (?);', editor.text); }
        );
    }

    function getDatabase() {
        var db = LocalStorage.openDatabaseSync("terrarium", "1.0", "file saving db", 100000);
        db.transaction(function(tx) {tx.executeSql('CREATE TABLE IF NOT EXISTS previous (editor TEXT)'); });
        return db;
    }

    Timer {
        id: timer
        interval: 500; running: false; repeat: false
        onTriggered: reloadView()
    }

    function reloadView() {
        viewLoader.setSource('http://'+platformIP+':5000/?'+Math.random()) // workaround for cache
    }

    NaviBar {
        state: "view"
        id: navibar
        z: 2
    }

    Item {
        id: view
        state: root.splitState
        width: root.width/2
        height: root.height
        anchors { top: parent.top; right: parent.right; bottom: navibar.top; }
        visible: opacity > 0 ? true : false

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
                    errorMessage.text = viewLoader.errorString().replace(/http:\/\/.*:5000\/\?.*?:/g, "Line: ");

                    // restart http server when connection refused
                    var connectionRefused = /Connection refused/;
                    if (connectionRefused.test(errorMessage.text)) {
                        httpd.destroy();
                        httpd = httpServer.createObject(root, {'id': 'httpd'});
                        saveContent();
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

        states: [
            State {
                name: "splitted"
                PropertyChanges { target: view; width: root.width/2 }
                PropertyChanges { target: view; opacity: 1 }
                PropertyChanges { target: background; width: root.width/2 }
                PropertyChanges { target: background; opacity: 1 }
            },
            State {
                name: "editor"
                PropertyChanges { target: view; width: 0 }
                PropertyChanges { target: view; opacity: 0 }
                PropertyChanges { target: background; width: root.width }
                PropertyChanges { target: background; opacity: 1 }
            },
            State {
                name: "viewer"
                PropertyChanges { target: view; width: root.width }
                PropertyChanges { target: view; opacity: 1 }
                PropertyChanges { target: background; width: 0 }
                PropertyChanges { target: background; opacity: 0 }
            }
        ]
        transitions: [
            Transition {
                to: "*"
                NumberAnimation { target: view; properties: "width"; duration: 300; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: background; properties: "width"; duration: 300; easing.type: Easing.InOutQuad; }
            }
        ]
    }

    Rectangle {
        id: background
        width: root.width/2
        height: root.height
        anchors { top: parent.top; left: parent.left; bottom: navibar.top}
        color: '#1d1f21'
        visible: opacity > 0 ? true : false

        Flickable {
            id: flickable
            anchors { fill: parent; }
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.DragOverBounds
            contentWidth: parent.width
            contentHeight: editor.height
            clip: true

            Column {
                id: lineNumber
                anchors { margins: 20; left: parent.left; top: parent.top }
                spacing: lineNumberSpacing
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

                onSelectedTextChanged: {
                    if (editor.selectedText === "") {
                        navibar.state = 'view'
                    }
                }
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
                selectionColor: '#0C75BC'
                selectByMouse: true
                font { pointSize: 18; family: platformSetting[os_type[platform]]['defaultFont'] }

                text: documentHandler.text
                inputMethodHints: Qt.ImhNoPredictiveText

                DocumentHandler {
                    id: documentHandler
                    target: editor
                    Component.onCompleted: {
                        documentHandler.text = "import QtQuick 2.0\n\nRectangle { \n    color: '#FEEB75'" +
                            "\n    Text { \n        anchors.centerIn: parent" +
                            "\n        text: 'Hello, World!' \n    } \n}"
                    }
                }

                // FIXME: add selection / copy / paste popup
                MouseArea {
                    id: handler
                    // FIXME: disable on desktop
                    enabled: os_type[platform] != 'macx'
                    anchors.fill: parent
                    propagateComposedEvents: true
                    onPressed: {
                        editor.cursorPosition = parent.positionAt(mouse.x, mouse.y);
                        editor.focus = true
                        navibar.state = 'view'
                        Qt.inputMethod.show();
                    }
                    onPressAndHold: {
                        navibar.state = 'selection'
                        Qt.inputMethod.hide();
                    }
                    onDoubleClicked: {
                        editor.selectWord()
                        navibar.state = 'selection'
                    }
                }
            } // end of editor

        }
    }
    Image {
        fillMode: Image.TileHorizontally
        source: "shadow.png"
        width: navibar.width
        anchors.bottom: navibar.top
        height: 6
    }
}
