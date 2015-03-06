import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: navigationBar
    width: parent.width
    height: 44 * scaleRatio
    anchors {
        top: parent.top
        left: parent.left
    }
    color: "white"

    Rectangle {
        id: repeater
        border.color: "#007edf"
        width: 270
        height: 29
        anchors.centerIn: parent 
        radius: 5
        smooth: true
        visible: false
        Row {
            Rectangle {
                width: 90; height: 29
                color: splitState == 'editor' ? "#007edf" : "transparent"
                Text {
                    text: "Editor"
                    color: splitState == 'editor' ? "white" : '#007edf'
                    anchors.centerIn: parent
                    font.pointSize: 15
                }
            }
            Rectangle {
                width: 90; height: 29
                border.width: 1
                border.color: "#007edf"
                color: splitState == 'splitted' ? "#007edf" : "transparent"
                Text {
                    text: "Split"
                    color: splitState == 'splitted' ? "white" : "#007edf"
                    anchors.centerIn: parent
                    font.pointSize: 15
                }
            }
            Rectangle {
                width: 90; height: 29
                color: splitState == 'viewer' ? "#007edf" : "transparent"
                Text {
                    text: "Viewer"
                    color: splitState == 'viewer' ? "white" : "#007edf"
                    anchors.centerIn: parent
                    font.pointSize: 15
                }
            }
        }

    }
    Rectangle {
        id: mask
        width: repeater.width
        height: repeater.height
        anchors.fill: repeater
        radius: 5
    }
    OpacityMask {
        visible: (parent.state === 'view')
        anchors.fill: repeater
        source: repeater
        maskSource: mask
    }

    Row {
        anchors.centerIn: parent
        visible: (parent.state === 'view')
        MouseArea {
            width: 90
            height: 29
            onPressed: splitState = 'editor'
        }
        MouseArea {
            width: 90
            height: 29
            onPressed: splitState = 'splitted'
        }
        MouseArea {
            width: 90
            height: 29
            onPressed: splitState = 'viewer'
        }
    }

    Text {
        visible: (parent.state == 'selection')
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10
        }
        font { family: fontAwesome.name; pointSize: 26 }
        text: "\uf057"
        color: 'grey'
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 
            onPressed: { 
                navigationBar.state = 'view'; 
                editor.deselect();
            }
        }
    }

    Row {
        anchors.centerIn: parent
        visible: (parent.state === 'selection')
        spacing: 30
        Text {
            visible: (editor.selectionStart !== editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 17
            text: "Cut"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                onPressed: editor.cut()
            }
        }
        Text {
            visible: (editor.selectionStart !== editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 17
            text: "Copy"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                onPressed: editor.copy()
            }
        }
        Text {
            visible: (editor.selectionStart === editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 17
            text: "Select"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                onPressed: editor.selectWord()
            }
        }
        Text {
            visible: (editor.selectionStart === editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 17
            text: "Select All"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                onPressed: editor.selectAll()
            }
        }
        Text {
            visible: (editor.canPaste === true)
            color: "#007edf"
            font.pointSize: 17
            text: "Paste"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                onPressed: editor.paste()
            }
        }
    }

    states: [
        State { 
            name: "view"
        },
        State {
            name: "selection"
        }
    ]
}
