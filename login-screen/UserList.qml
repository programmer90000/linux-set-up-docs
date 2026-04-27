import QtQuick
import QtQuick.Controls

Rectangle {
    id: userListRoot
    width: 200
    height: Math.min(listView.contentHeight + 20, 300)
    color: "transparent"
    
    property string selectedUsername: ""
    signal userSelected(string username)
    
    ListView {
        id: listView
        anchors.fill: parent
        spacing: 10
        
        model: userModel || []
        
        delegate: Rectangle {
            width: parent.width
            height: 45
            color: mouseArea.containsMouse ? "#2a2a2a" : "#1e1e1e"
            radius: 5
            border.color: "#3a3a3a"
            border.width: 1
            
            Text {
                text: {
                    if (typeof model === 'string') return model
                    if (model && model.name) return model.name
                    if (model && model.userName) return model.userName
                    return "User " + index
                }
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - 10
                wrapMode: Text.WordWrap
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var username = (typeof model === 'string') ? model : 
                                  (model && model.name) ? model.name : 
                                  "user" + index
                    userListRoot.selectedUsername = username
                    userListRoot.userSelected(username)
                }
            }
        }
        
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }
}