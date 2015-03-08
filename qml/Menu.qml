import QtQuick 2.0

Item {
        id: menu
        width: root.width
        height: root.height
        state: "show"
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: - root.width
        }
        Rectangle {
            anchors.fill: parent
            color: '#F2F2F2'
            ListView {
                id: menuListView
                model: menuModel
                delegate: menuDelegate
                header: Rectangle {
                    width: parent.width
                    height: 70 * scaleRatio
                    color: "transparent"
                    Text {
                        text: "\uF067"; font.family: fontAwesome.name; color: "#424242"; font.pointSize: 16
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 20 * scaleRatio
                        }
                    }
                    Text {
                        text: "<b>Create New Project</b>"
                        color: "#242527"
                        font.pointSize: 15
                        anchors { 
                            verticalCenter: parent.verticalCenter; 
                            verticalCenterOffset: -2 * scaleRatio; 
                            left: parent.left; 
                            leftMargin: 45 * scaleRatio 
                        }
                    }
                    MouseArea {
                        anchors.fill: parent;
                        onPressed: { // TODO: create project
                            menuModel.insert(0, { content: 'new project' });
                        }
                    }
                }
                anchors.fill: parent
                anchors.topMargin: 10 * scaleRatio
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                }
                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
                }
            }
            Component {
                id: menuDelegate
                Rectangle {
                    color: 'transparent'
                    width: parent.width
                    height: 150 * scaleRatio
                    Rectangle {
                        width: parent.width - 20 * scaleRatio
                        height: parent.height - 20 * scaleRatio
                        anchors {
                            left: parent.left
                            horizontalCenter: parent.horizontalCenter
                            margins: 10 * scaleRatio
                        }
                        color: 'white'
                        Text {
                            text: model.content
                            font.pointSize: 16 
                            font.family: platformSetting[os_type[platform]]['defaultFont']
                            anchors {
                                verticalCenter: parent.verticalCenter
                                margins: 10
                                left: parent.left
                            }
                            color: '#464646'
                        }
                        Image {
                            id: thumbnail
                            source: "http://placehold.it/350x350"
                            height: parent.height
                            width: parent.width * 0.6
                            clip: true
                            fillMode: Image.PreserveAspectCrop
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { // TODO: load project
                            menu.state = 'hide' 
                        }
                    }
                }
            }
        }

        states: [
            State {
                name: "show"
                PropertyChanges { target: menu; anchors.leftMargin: 0 }
            },
            State {
                name: "hide"
                PropertyChanges { target: menu; anchors.leftMargin: - root.width }
            }
        ]
        transitions: [
            Transition {
                to: "*"
                NumberAnimation { target: menu; properties: "anchors.leftMargin"; duration: 300; easing.type: Easing.InOutQuad; }
            }
        ]
    }
