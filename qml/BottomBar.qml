import QtQuick 2.0

Rectangle {
    anchors {
        bottom: parent.bottom
        left: background.left
        margins: 5 * scaleRatio 
    }
    radius: 0.5 * height
    height: 50 * scaleRatio
    width: height 
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#70787F" }
        GradientStop { position: 1.0; color: "#383C40" }
    }
    CustomButton {
        id: viewSwitchButton
        anchors { top: parent.top; left: parent.left }
        icon.text: if (splitState=='viewer') { "\uf121" } else if (splitState=='editor') { "\uf0db" } else { "\uf144" }
        defaultColor: "#CAD8E5"
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
}
