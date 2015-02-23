import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
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
        anchors.fill: repeater
        source: repeater
        maskSource: mask
    }

    Row {
        anchors.centerIn: parent
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
}
