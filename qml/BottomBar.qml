import QtQuick 2.0

Rectangle {
    anchors {
        bottom: parent.bottom
        left: background.left
        margins: splitState=='viewer' ? 5 : 0
    }
    radius: 3 * scaleRatio
    height: (os_type[platform]=='android' ? 53 : 44 ) * scaleRatio
    width: splitState=='viewer' ? 50 * scaleRatio : background.width
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#70787F" }
        GradientStop { position: 1.0; color: "#383C40" }
    }
    CustomButton {
        id: viewSwitchButton
        anchors { top: parent.top; left: parent.left }
        icon.text: "\uf0db"
        defaultColor: splitState =='splitted' ? "#FED146" : "#CAD8E5"
        onClicked: {
            if (splitState == 'splitted')
                splitState = 'viewer';
            else if (splitState == 'viewer')
                splitState = 'editor';
            else
                splitState = 'splitted';
            view.state = splitState;
        }
    }
    CustomButton {
        id: exportButton
        visible: splitState != 'viewer'
        anchors { top: parent.top; right: parent.right; }
        icon.text: "\uf1d8"
        onClicked: {
            Qt.openUrlExternally("mailto:?subject=Terrarium project&body="+editor.text);
        }
    }
}
