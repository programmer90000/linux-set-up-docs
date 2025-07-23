import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    width: 640
    height: 480

    // Background
    Image {
        anchors.fill: parent
        source: "./assets/background.jpg" // Path to your image
        fillMode: Image.PreserveAspectCrop // Ensures full coverage without stretching
        smooth: true // Anti-aliasing
    }

    // Login Form
    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
            Keys.onReturnPressed: loginButton.clicked()
        }

        Button {
            id: loginButton
            text: "Login"
            onClicked: {
                if (userListView.currentItem) {
                    sddm.login(userListView.currentItem.text, password.text, 0);
                }
            }
        }
    }

    // User List
    Rectangle {
        id: userListContainer
        width: 200
        height: Math.min(300, userListView.contentHeight)
        color: "#40000000"
        radius: 5
        anchors {
            right: parent.left
            bottom: parent.bottom
            margins: 20
        }

        ListView {
            id: userListView
            anchors.fill: parent
            clip: true
            model: userModel // SDDM's built-in user model
            currentIndex: 0 // Select first user by default
            delegate: Button {
                width: ListView.view.width
                text: model.name
                flat: true
                highlighted: ListView.isCurrentItem
                onClicked: {
                    userListView.currentIndex = index;
                    password.forceActiveFocus(); // Move focus to password field
                }
            }
        }
    }
}
