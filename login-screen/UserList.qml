import QtQuick
import QtQuick.Controls

Rectangle {
    id: userListRoot
    width: 200
    height: 300
    color: "transparent"
    
    property string selectedUsername: ""
    
    signal userSelected(string username)
    
    // DEBUG: Show model count
    Text {
        text: "Users found: " + (sddm.users ? sddm.users.count : 0)
        color: "red"
        z: 10
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    ListView {
        id: listView
        anchors.fill: parent
        spacing: 10
        
        model: sddm.users
        
        delegate: Rectangle {
            width: parent ? parent.width : 200
            height: 45
            color: mouseArea.containsMouse ? "#2a2a2a" : "#1e1e1e"
            radius: 5
            border.color: "#3a3a3a"
            border.width: 1
            
            Text {
                text: model.name
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 14
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    userListRoot.selectedUsername = model.name
                    userListRoot.userSelected(model.name)
                }
            }
        }
        
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }
}
