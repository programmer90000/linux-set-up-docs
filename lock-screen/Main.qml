import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    width: 640
    height: 480

    // Background
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    // Login Form
    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: username
            placeholderText: "Username"
        }

        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
        }

        Button {
            text: "Login"
            onClicked: sddm.login(username.text, password.text, 0)
        }
    }
}