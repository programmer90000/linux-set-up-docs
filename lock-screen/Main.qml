import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    width: 640
    height: 480

    // Background
    Image {
        anchors.fill: parent
        source: "./assets/background.jpg"  // Path to your image
        fillMode: Image.PreserveAspectCrop  // Ensures full coverage without stretching
        smooth: true  // Anti-aliasing
    }

    // Login Form
    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: username
            placeholderText: "Username"
            focus: true  // Set initial focus to username field
            Keys.onReturnPressed: password.forceActiveFocus()
        }

        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
            Keys.onReturnPressed: loginButton.clicked()
        }

        Button {
            id: loginButton
            text: "Login"
            onClicked: sddm.login(username.text, password.text, 0)
        }
    }
}