import QtQuick 2.0

Item {
    id: button
    width: 30 * scaleRatio; height: 30 * scaleRatio; 
    property alias icon: buttonIcon
    property variant defaultColor: "#CAD8E5"
    signal clicked()
    anchors { margins: 10 }
    Text {
        id: buttonIcon
        anchors.centerIn: parent
        font { family: fontAwesome.name; pointSize: 26 }
        color: defaultColor
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 * scaleRatio
            onPressed: button.clicked()
        }
    }
}
