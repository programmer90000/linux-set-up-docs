import QtQuick
import QtQuick.Controls

Column {
    id: root
    spacing: 15
    width: 300
    
    property alias usernameInput: usernameField
    property alias passwordInput: passwordField
    
    signal loginRequested(string username, string password)
    
    TextField {
        id: usernameField
        width: parent.width
        height: 45
        placeholderText: "Username"
        font.pixelSize: 16
        background: Rectangle { color: "white"; radius: 5 }
        onAccepted: passwordField.forceActiveFocus()
    }
    
    TextField {
        id: passwordField
        width: parent.width
        height: 45
        placeholderText: "Password"
        echoMode: TextField.Password
        font.pixelSize: 16
        background: Rectangle { color: "white"; radius: 5 }
        onAccepted: root.loginRequested(usernameField.text, passwordField.text)
    }
    
    function setUsername(username) {
        usernameField.text = username
        passwordField.forceActiveFocus()
    }
}
