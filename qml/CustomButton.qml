import QtQuick 2.0

Item {
    id: button
    width: 30 * scaleRatio; height: 30 * scaleRatio; 
    property alias icon: buttonIcon
    property variant defaultColor: Qt.darker("darkgray")
    signal clicked()
    anchors { margins: 10 }
    Text {
        id: buttonIcon
        anchors.centerIn: parent
        font { family: fontAwesome.name; pointSize: 26 }
        color: defaultColor
        style: Text.Sunken; styleColor: "darkgray"
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 * scaleRatio
            onPressed: { 
                button.clicked()
                buttonIcon.color = "#FED146"
            }
            onReleased: parent.color = defaultColor
        }
    }
}
