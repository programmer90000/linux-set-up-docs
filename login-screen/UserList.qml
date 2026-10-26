import QtQuick
import QtQuick.Controls

Rectangle {
    id: userListRoot
    width: 200
    height: Math.min(listView.contentHeight + 20, 300)
    color: "transparent"
    
    property string selectedUserName: ""
    signal userSelected(string username, string avatarPath)

    function focusList() {
        listView.forceActiveFocus()
    }
    
    function selectFirstUser() {
        if (listView.count > 0) {
            listView.currentIndex = 0
            var item = listView.itemAtIndex(0)
            if (item) {
                var username = item.getUsername()
                var avatarPath = item.getAvatarPath()
                userListRoot.selectedUserName = username
                userListRoot.userSelected(username, avatarPath)
            }
        }
    }
    
    ListView {
        id: listView
        anchors.fill: parent
        spacing: 10
        
        model: userModel || []
        
        activeFocusOnTab: true
        focus: true
        
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0 && count > 0) {
                    var item = itemAtIndex(currentIndex)
                    if (item) {
                        var username = item.getUsername()
                        var avatarPath = item.getAvatarPath()
                        userListRoot.selectedUserName = username
                        userListRoot.userSelected(username, avatarPath)
                    }
                }
                event.accepted = true
            }
        }
        
        delegate: Rectangle {
            id: delegateRoot
            width: parent.width
            height: 45
            
            property bool isSelected: userListRoot.selectedUserName === getUsername()
            property bool isKeyboardFocused: listView.currentIndex === index && listView.activeFocus
            
            color: {
                if (isSelected) {
                    return "#3a6ea5"
                } else if (isKeyboardFocused) {
                    return "#2a3a4a" // Highlight focused item via keyboard
                } else if (mouseArea.containsMouse) {
                    return "#2a2a2a"
                } else {
                    return "#1e1e1e"
                }
            }
            radius: 5
            border.color: (isSelected || isKeyboardFocused) ? "#5a8ec5" : "#3a3a3a"
            border.width: isKeyboardFocused ? 2 : 1
           
            function getUsername() {
                if (typeof model === 'string') return model
                if (model && model.name) return model.name
                if (model && model.userName) return model.userName
                return ""
            }
            
            function getAvatarPath() {
                var username = getUsername()
                var avatarPath = "/usr/share/sddm/themes/login-screen/" + username + "/profile-picture.png"
                return avatarPath
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
                    source: getAvatarPath()
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    visible: false
                    
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            visible = true
                        } else if (status === Image.Error) {
                            visible = false
                            console.log("Avatar not found for:", getUsername(), "at:", source)
                        }
                    }
                }
                
                // Fallback to username initial
                Rectangle {
                    id: fallbackRect
                    anchors.fill: parent
                    radius: 15
                    color: isSelected ? "#5a8ec5" : "#3a3a3a"
                    visible: !userIcon.visible
                    
                    Text {
                        anchors.centerIn: parent
                        text: {
                            var username = delegateRoot.getUsername()
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
                text: delegateRoot.getUsername() || ""
                anchors {
                    left: userIconContainer.right
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                color: isSelected ? "#ffffff" : "#cccccc"
                font.pixelSize: 14
                font.bold: isSelected
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
                    listView.currentIndex = index // Sync keyboard index with mouse selection
                    var username = delegateRoot.getUsername()
                    var avatarPath = delegateRoot.getAvatarPath()
                    userListRoot.selectedUserName = username
                    userListRoot.userSelected(username, avatarPath)
                }
            }
        }
        
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }
}
