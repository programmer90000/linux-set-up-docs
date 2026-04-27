import QtQuick
import QtQuick.Controls

Rectangle {
    id: userListRoot
    width: 200
    height: 300
    color: "transparent"
    
    property string selectedUsername: ""
    
    signal userSelected(string username)
    
    // DEBUG: Component initialization
    Component.onCompleted: {
        // Try to access the model directly
        if (sddm.users) {
            console.log("Model exists:", sddm.users)
            console.log("Count in real-time:", sddm.users.count)
            
            // Try to read the first user as a backup verification
            try {
                var firstUser = sddm.users.data(sddm.users.index(0,0), 257)
                console.log("First user data:", firstUser)
            } catch(e) { console.log("Read error:", e) }
        } else {
            console.log("Model is null!")
        }
    }
    
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