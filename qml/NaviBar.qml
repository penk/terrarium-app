import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: navigationBar
    width: parent.width
    height: 44 * scaleRatio
    anchors {
        bottom: parent.bottom
        left: parent.left
    }
    color: "white"

    Rectangle {
        id: repeater
        border.color: "#007edf"
        width: 240 * scaleRatio
        height: 29 * scaleRatio 
        anchors.centerIn: parent 
        radius: 5 * scaleRatio
        smooth: true
        visible: false
        Row {
            Rectangle {
                width: 80 *scaleRatio ; height: 29 * scaleRatio
                color: splitState == 'editor' ? "#007edf" : "transparent"
                Text {
                    text: "Editor"
                    color: splitState == 'editor' ? "white" : '#007edf'
                    anchors.centerIn: parent
                    font.pointSize: 15
                }
            }
            Rectangle {
                width: 80 * scaleRatio; height: 29 * scaleRatio
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
                width: 80 * scaleRatio; height: 29 * scaleRatio
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
        radius: 5 * scaleRatio
    }
    OpacityMask {
        visible: (parent.state === 'view' && menu.state !== 'show' )
        anchors.fill: repeater
        source: repeater
        maskSource: mask
    }

    Row {
        anchors.centerIn: parent
        visible: (parent.state === 'view' && menu.state !== 'show')
        MouseArea {
            width: 80 * scaleRatio
            height: 29 * scaleRatio
            onPressed: splitState = 'editor'
        }
        MouseArea {
            width: 80 * scaleRatio
            height: 29 * scaleRatio
            onPressed: splitState = 'splitted'
        }
        MouseArea {
            width: 80 * scaleRatio
            height: 29 * scaleRatio
            onPressed: splitState = 'viewer'
        }
    }

    Text {
        id: backButton
        visible: (parent.state != 'selection' && menu.state !== 'show')
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10 * scaleRatio
        }
        font { family: fontAwesome.name; pointSize: 26 }
        text: "\uf053"
        color: 'grey'
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 * scaleRatio
            onPressed: { // TODO: save project 
                menu.state = "show"
            }
        }
    } 

    Text {
        visible: (parent.state == 'selection')
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10 * scaleRatio 
        }
        font { family: fontAwesome.name; pointSize: 26 }
        text: "\uf057"
        color: 'grey'
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 * scaleRatio
            onPressed: { 
                navigationBar.state = 'view'; 
                editor.deselect();
            }
        }
    }

    Row {
        anchors.centerIn: parent
        visible: (parent.state === 'selection')
        spacing: 20 * scaleRatio
        Text {
            visible: (editor.selectionStart !== editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 17
            text: "Cut"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
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
                anchors.margins: -5 * scaleRatio
                onPressed: { 
                    editor.copy()
                    editor.deselect()
                }
            }
        }
        Text {
            visible: (editor.selectionStart === editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 17
            text: "Select"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
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
                anchors.margins: -5 * scaleRatio
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
                anchors.margins: -5 * scaleRatio
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
