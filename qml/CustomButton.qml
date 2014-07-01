import QtQuick 2.0

Item {
    id: button
    width: 30; height: 30; 
    property alias icon: buttonIcon
    property variant defaultColor: Qt.darker("darkgray")
    signal clicked()
    anchors { margins: 10; }
    Text {
        id: buttonIcon
        font { family: fontAwesome.name; pointSize: 26 }
        color: defaultColor
        style: Text.Sunken; styleColor: "darkgray"
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 
            onPressed: { 
                button.clicked()
                buttonIcon.color = "#FED146"
            }
            onReleased: parent.color = defaultColor
        }
    }
}
