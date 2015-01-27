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
        // "\uf121" : fa-code, to editor
        // "\uf0db" : fa-columns, to splitted view
        // "\uf144" : fa-play-circle, to viewer 
        icon.text: 
            if (splitState=='viewer' && root.width * scaleRatio > 600) { "\uf0db" } 
            else if (splitState=='viewer') { "\uf121" } 
            else if (splitState=='editor') { "\uf144" } 
            else if (splitState=='splitted') { "\uf121" }
            else "\uf144"
        defaultColor: "#CAD8E5"
        onClicked: {
            // splitted -> editor -> viewer 
            if (splitState == 'editor')
                splitState = 'viewer';
            else if (splitState == 'viewer' && root.width * scaleRatio > 600)
                splitState = 'splitted';
            else 
                splitState = 'editor';

            view.state = splitState;
        }
    }
}
