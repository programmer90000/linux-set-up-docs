import QtQuick
import QtQuick.Controls

Column {
    id: root
    spacing: 15
    width: 300
    
    property string selectedUsername: ""
    property alias passwordInput: passwordField
    
    signal loginRequested(string username, string password)
    
    Text {
        id: usernameLabel
        width: parent.width
        text: root.selectedUsername !== "" ? root.selectedUsername : "Select a user"
        font.pixelSize: 14
        color: root.selectedUsername !== "" ? "#3a6ea5" : "#999999"
        horizontalAlignment: Text.AlignHCenter
        visible: true
    }
    
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
    
    function setUsername(username) {
        root.selectedUsername = username
        passwordField.text = ""
        passwordField.forceActiveFocus()
    }
}