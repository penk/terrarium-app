import QtQuick 2.0
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import HttpServer 1.0
import QtQuick.LocalStorage 2.0

Window {
    id: root
    width: Screen.width
    height: Screen.height
    visible: true
    title: "Terrarium - Live QML Editor and Viewer"

    property variant httpServer: {}
    property variant httpd: {}
    property bool splitView: true
    property variant os_type: { '0': 'macx', '1': 'ios', '2': 'android', '3': 'linux', '4': 'default' }
    property variant platformSetting: {
        'ios': { 'lineNumberSpacing': 3, 'lineNumberPadding' : 17, 'defaultFont': 'Courier New' },
        'macx': { 'lineNumberSpacing': -1, 'lineNumberPadding' : 20, 'defaultFont': 'Courier New' },
        'android': { 'lineNumberSpacing': 0, 'lineNumberPadding' : 20, 'defaultFont': 'Droid Sans Mono' },
        'linux': { 'lineNumberSpacing': 0, 'lineNumberPadding' : 20, 'defaultFont': 'Droid Sans Mono' },
        'default': { 'lineNumberSpacing': 0, 'lineNumberPadding' : 20, 'defaultFont': 'Droid Sans Mono' },
    }
    property variant lineNumberPadding: platformSetting[os_type[platform]]['lineNumberPadding'] 
    property variant lineNumberSpacing: platformSetting[os_type[platform]]['lineNumberSpacing'] 
    property variant scaleRatio: Screen.pixelDensity.toFixed(0) / 5 

    FontLoader { id: fontAwesome; source: "fontawesome-webfont.ttf" }

    Component.onCompleted: {
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
        reloadView();
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
        viewLoader.setSource('http://127.0.0.1:5000/?'+Math.random()) // workaround for cache
    }

    Item {
        id: view
        state: "splited"
        width: root.width/2
        height: root.height
        anchors { top: parent.top; right: parent.right; bottom: parent.bottom }

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
                    errorMessage.text = viewLoader.errorString().replace(/http:\/\/127.0.0.1:5000\/\?.*?:/g, "Line: ");

                    // restart http server when connection refused 
                    var connectionRefused = /Connection refused/;
                    if (connectionRefused.test(errorMessage.text)) {
                        httpd.destroy();
                        httpd = httpServer.createObject(root, {'id': 'httpd'});
                        saveContent();
                        reloadView();
                    }
                } else { 
                    errorMessage.text = ""; 
                }
            }
        }

        states: [
            State{
                name: "splited"
                PropertyChanges { target: view; width: root.width/2 }
                PropertyChanges { target: background; opacity: 1 }
                PropertyChanges { target: background; visible: true }
            },
            State {
                name: "fullscreen"
                PropertyChanges { target: view; width: root.width }
                PropertyChanges { target: background; opacity: 0 }
                PropertyChanges { target: background; visible: false }
            }
        ]
        transitions: [
            Transition {
                to: "*"
                NumberAnimation { target: view; properties: "width"; duration: 300; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: background; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
            }
        ]
    }

    Rectangle { 
        id: background
        width: root.width/2
        height: root.height
        anchors { top: parent.top; left: parent.left; bottom: parent.bottom }
        color: '#1d1f21'

        TextEdit {
            id: editor
            visible: false
        }
        Loader { 
            id: webViewLoader
            anchors { fill: parent; } //bottomMargin: bottomBar.height } 
            source: "QtWebView.qml"
            onStatusChanged: {
                if (status == Loader.Error) {
                    source = "QtWebKit.qml"
                }
                else if (status == Loader.Ready)
                    load()
            }
            function load() {
                // "http://ajaxorg.github.io/ace-builds/editor.html"
                item.url = "http://127.0.0.1:5000/ace/ace.html"
            }
        }
    }
    // FIXME: QtWebView overlay doesn't work 
    /*
    BottomBar {
        id: bottomBar
    }
    */

}
