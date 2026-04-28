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
            color: {
                if (userListRoot.selectedUsername === getUsername()) {
                    return "#3a6ea5"  // Highlight selected user
                } else if (mouseArea.containsMouse) {
                    return "#2a2a2a"
                } else {
                    return "#1e1e1e"
                }
            }
            radius: 5
            border.color: {
                if (userListRoot.selectedUsername === getUsername()) {
                    return "#5a8ec5"
                } else {
                    return "#3a3a3a"
                }
            }
            border.width: 1
            
            function getUsername() {
                if (typeof model === 'string') return model
                if (model && model.name) return model.name
                if (model && model.userName) return model.userName
                return "User " + index
            }
            
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
                        if (model && model.avatarPath) {
                            return model.avatarPath
                        }
                        
                        var username = getUsername()
                        return "/usr/share/sddm/themes/login-screen/" + username + "/profile-picture.jpg"
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
                            console.log("Failed to load image for user " + getUsername() + " from:", source)
                        }
                    }
                }
                
                // Fallback to username initial
                Rectangle {
                    id: fallbackRect
                    anchors.fill: parent
                    radius: 15
                    color: {
                        if (userListRoot.selectedUsername === getUsername()) {
                            return "#5a8ec5"
                        } else {
                            return "#3a3a3a"
                        }
                    }
                    visible: !userIcon.visible
                    
                    Text {
                        anchors.centerIn: parent
                        text: {
                            var username = getUsername()
                            return username ? username.charAt(0).toUpperCase() : "?"
                        }
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }
            
            // Username text next to the image
            Text {
                id: usernameText
                text: getUsername()
                anchors {
                    left: userIconContainer.right
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                color: {
                    if (userListRoot.selectedUsername === getUsername()) {
                        return "#ffffff"
                    } else {
                        return "#cccccc"
                    }
                }
                font.pixelSize: 14
                font.bold: userListRoot.selectedUsername === getUsername()
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
                    var username = getUsername()
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