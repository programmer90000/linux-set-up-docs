import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

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

        // User icon above password field
        Image {
            id: currentUserIcon
            anchors.horizontalCenter: parent.horizontalCenter
            source: userListView.currentItem ? userListView.currentItem.userIcon : "qrc:/assets/user-icon.png"
            sourceSize: Qt.size(64, 64)
            width: 64
            height: 64
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: currentUsernameText
            anchors.horizontalCenter: parent.horizontalCenter
            text: userListView.currentItem ? userListView.currentItem.userName : "Select a user"
            color: "white"
            font.pixelSize: 16
            font.bold: true
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
            onClicked: {
                if (userListView.currentIndex >= 0) {
                    sddm.login(userListView.currentItem.userName, password.text, 0);
                }
            }
        }
    }

    // User List
    Rectangle {
        id: userListContainer
        width: 300
        height: Math.min(300, userListView.contentHeight)
        color: "#40000000"
        radius: 5
        anchors {
            left: parent.left
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
                height: 50
                flat: true
                highlighted: ListView.isCurrentItem
                onClicked: {
                    userListView.currentIndex = index;
                    password.forceActiveFocus();
                }

                // Store user properties
                property string userName: model.name
                property string userIcon: model.icon || "qrc:/assets/user-icon.png"

                contentItem: RowLayout {
                    spacing: 10

                    Image {
                        id: userIcon
                        source: parent.parent.userIcon
                        sourceSize: Qt.size(32, 32)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                    }

                    Label {
                        text: model.name
                        color: highlighted ? "white" : "#ccc"
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}