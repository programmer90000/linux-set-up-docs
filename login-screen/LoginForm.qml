import QtQuick
import QtQuick.Controls

Column {
    id: root
    spacing: 15
    width: 300
    
    property string selectedUsername: ""
    property string selectedAvatarPath: ""
    property alias passwordInput: passwordField
    
    signal loginRequested(string username, string password)
    
    Item {
        id: avatarContainer
        width: 80
        height: 80
        anchors.horizontalCenter: parent.horizontalCenter
        
        Image {
            id: avatarImage
            anchors.fill: parent
            source: root.selectedAvatarPath
            fillMode: Image.PreserveAspectFit
            visible: false
            cache: false // Disable cache to ensure reload when user changes
            
            onStatusChanged: {
                if (status === Image.Ready) {
                    visible = true
                    fallbackRect.visible = false
                } else if (status === Image.Error) {
                    visible = false
                    fallbackRect.visible = true
                    console.log("Login form: Avatar not found at:", source)
                }
            }
        }
        
        // Fallback circle with initial
        Rectangle {
            id: fallbackRect
            anchors.fill: parent
            radius: 40
            color: "#3a6ea5"
            visible: true
            
            Text {
                anchors.centerIn: parent
                text: root.selectedUsername !== "" ? root.selectedUsername.charAt(0).toUpperCase() : "?"
                color: "white"
                font.pixelSize: 36
                font.bold: true
            }
        }
    }
    
    // Spacing between avatar and username
    Item { height: 5 }
    
    Text {
        id: usernameLabel
        width: parent.width
        text: root.selectedUsername !== "" ? root.selectedUsername : "Select a user"
        font.pixelSize: 14
        font.bold: root.selectedUsername !== ""
        color: root.selectedUsername !== "" ? "#3a6ea5" : "#999999"
        horizontalAlignment: Text.AlignHCenter
    }
    
    // Spacing between username and password field
    Item { height: 10 }
    
    TextField {
        id: passwordField
        width: parent.width
        height: 45
        placeholderText: "Password"
        echoMode: TextField.Password
        font.pixelSize: 16
        
        background: Rectangle {
            color: root.selectedUsername !== "" ? "white" : "#f0f0f0"
            radius: 5
            border.color: root.selectedUsername !== "" ? "#cccccc" : "#e0e0e0"
            border.width: 1
        }
        
        enabled: root.selectedUsername !== ""
        
        onAccepted: {
            if (root.selectedUsername !== "" && passwordField.text !== "") {
                root.loginRequested(root.selectedUsername, passwordField.text)
            }
        }
    }
    
    function setUsername(username, avatarPath) {
        root.selectedUsername = username
        
        if (avatarPath && avatarPath !== "") {
            root.selectedAvatarPath = avatarPath
        } else {
            var constructedPath = "/usr/share/sddm/themes/login-screen/" + username + "/profile-picture.jpg"
            root.selectedAvatarPath = constructedPath
        }
        
        // Reset avatar visibility to trigger reload
        avatarImage.visible = false
        fallbackRect.visible = true
        
        // Reload the image
        avatarImage.source = ""
        avatarImage.source = root.selectedAvatarPath
        
        // Clear password and focus
        passwordField.text = ""
        passwordField.forceActiveFocus()
    }
}