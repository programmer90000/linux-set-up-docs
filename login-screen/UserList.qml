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
            
            Item {
                id: userIconContainer
                width: 30
                height: 30
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                
                Image {
                    id: userIcon
                    source: {
                        if (model && model.avatarPath) return model.avatarPath
                        return "/usr/share/sddm/themes/login-screen/profile-picture.jpg"
                    }
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    visible: false
                    
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            visible = true
                        } else if (status === Image.Error) {
                            visible = false
                            console.log("Failed to load image:", source)
                        }
                    }
                }
                
                // Fallback to username initial
                Rectangle {
                    id: fallbackRect
                    anchors.fill: parent
                    radius: 15
                    color: "#3a3a3a"
                    visible: !userIcon.visible
                    
                    Text {
                        anchors.centerIn: parent
                        text: {
                            // Extract first letter from username
                            var username = ""
                            if (typeof model === 'string') {
                                username = model
                            } else if (model && model.name) {
                                username = model.name
                            } else if (model && model.userName) {
                                username = model.userName
                            } else {
                                username = "User " + index
                            }
                            return username ? username.charAt(0).toUpperCase() : "?"
                        }
                        color: "#cccccc"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }
            
            // Username text next to the image
            Text {
                id: usernameText
                text: {
                    if (typeof model === 'string') return model
                    if (model && model.name) return model.name
                    if (model && model.userName) return model.userName
                    return "User " + index
                }
                anchors {
                    left: userIconContainer.right
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                color: "white"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
            
            // Mouse area for click handling
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var username = (typeof model === 'string') ? model : 
                                  (model && model.name) ? model.name : 
                                  (model && model.userName) ? model.userName :
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