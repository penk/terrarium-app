import QtQuick 2.0

Rectangle {
    anchors {
        bottom: parent.bottom
        left: background.left
        right: background.right
    }
    height: 44
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#EAEAEA" }
        GradientStop { position: 1.0; color: "#AAAAAA" }
    }
    Item {
        id: exportButton
        width: 30; height: 30; 
        anchors { right: parent.right; margins: 10; top: parent.top; }
        Text {
            id: exportButtonIcon
            text: (fontAwesome.status === FontLoader.Ready) ? "\uF08e" : "";
            font { family: fontAwesome.name; pointSize: 28 }
            color: Qt.darker("darkgray")
            style: Text.Sunken; styleColor: "darkgray"
        }
        MouseArea {
            anchors.fill: parent;
            anchors.margins: -5 
            onPressed: {
                exportButtonIcon.color = "#FED164";
                //dialog.state == "closed" ? dialog.state = "opened" : dialog.state = "closed";
            }
            onReleased: exportButtonIcon.color = Qt.darker("darkgray");
        }
    }
}
