import QtQuick
import QtQuick.Controls

Rectangle {
    width: 1920
    height: 1080
    color: "#1a1a1a"
    
    Column {
        anchors.centerIn: parent
        spacing: 15
        width: 300
        
        TextField {
            id: usernameInput
            width: parent.width
            height: 45
            placeholderText: "Username"
            font.pixelSize: 16
            background: Rectangle { color: "white"; radius: 5 }
            onAccepted: passwordInput.forceActiveFocus()
        }
        
        TextField {
            id: passwordInput
            width: parent.width
            height: 45
            placeholderText: "Password"
            echoMode: TextField.Password
            font.pixelSize: 16
            background: Rectangle { color: "white"; radius: 5 }
            onAccepted: sddm.login(usernameInput.text, passwordInput.text, 0)
        }
    }
}
