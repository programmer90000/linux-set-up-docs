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
        
        onUserSelected: loginForm.setUsername(username)
    }

    LoginForm {
        id: loginForm
        anchors.centerIn: parent
        
        onLoginRequested: sddm.login(username, password, 0)
    }
}