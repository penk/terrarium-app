import QtQuick 2.0

Rectangle {
    anchors {
        bottom: parent.bottom
        left: background.left
        margins: splitView ? 0 : 5
    }
    radius: 3 * scaleRatio
    height: (os_type[platform]=='android' ? 53 : 44 ) * scaleRatio
    width: splitView ? background.width : 44 * scaleRatio
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#EAEAEA" }
        GradientStop { position: 1.0; color: "#AAAAAA" }
    }
    CustomButton {
        id: viewSwitchButton
        anchors { top: parent.top; left: parent.left }
        icon.text: "\uf0db"
        defaultColor: splitView ? "#286CE9" : Qt.darker("darkgray")
        onClicked: { 
            splitView = !splitView; icon.color = "#FED164"; 
            if (splitView) view.state = "splited"
            else view.state = "fullscreen"
        } 
    }
    CustomButton {
        id: exportButton
        visible: splitView ? true : false 
        anchors { top: parent.top; right: parent.right; }
        icon.text: "\uf1d8"
        defaultColor: Qt.darker("darkgray")
        onClicked: { 
            defaultColor = Qt.darker("darkgray");
            Qt.openUrlExternally("mailto:?subject=Terrarium project&body="+editor.text); 
        }
    }
}
