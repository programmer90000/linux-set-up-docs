import QtQuick
import QtQuick.Controls
import "./"

Rectangle {
    width: 1920
    height: 1080
    color: "#1a1a1a"

    UserList {
        id: userList
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
    }

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
            
            // Update list when user is selected from the list
            Connections {
                target: userList
                function onUserSelected(username) {
                    usernameInput.text = username
                    passwordInput.forceActiveFocus()
                }
            }
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
