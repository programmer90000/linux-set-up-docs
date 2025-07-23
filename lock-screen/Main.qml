import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

Item {
    width: 640
    height: 480

    // States for pre-login and login screens
    states: [
        State {
            name: "preLogin"
            PropertyChanges { target: preLoginScreen; visible: true }
            PropertyChanges { target: loginContainer; visible: false }
        },
        State {
            name: "login"
            PropertyChanges { target: preLoginScreen; visible: false }
            PropertyChanges { target: loginContainer; visible: true }
        }
    ]

    // Start with pre-login screen
    Component.onCompleted: state = "preLogin"

    // Pre-login screen
    Item {
        id: preLoginScreen
        anchors.fill: parent
        focus: true  // Allow keyboard focus

        Image {
            anchors.fill: parent
            source: "./assets/background.jpg"
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        // Time and Date Display
        Column {
            anchors {
                top: parent.top
                right: parent.right
                margins: 20
            }
            spacing: 5

            Text {
                id: timeText
                color: "white"
                font.pixelSize: 48
                font.bold: true
                style: Text.Outline
                styleColor: "#80000000"
            }

            Text {
                id: dateText
                color: "white"
                font.pixelSize: 24
                style: Text.Outline
                styleColor: "#80000000"
            }
        }

        // Timer to update time
        Timer {
            interval: 1000 // Update every second
            running: true
            repeat: true
            onTriggered: updateTime()
        }

        // Function to update time and date
        function updateTime() {
            var date = new Date();
            timeText.text = Qt.formatTime(date, "hh:mm:ss");
            dateText.text = Qt.formatDate(date, "dddd, MMMM d");
        }

        // Initialize time immediately
        Component.onCompleted: updateTime()

        MouseArea {
            anchors.fill: parent
            onClicked: parent.parent.state = "login"
        }

        Keys.onPressed: {
            parent.parent.state = "login"
        }
    }

    // Main login container
    Item {
        id: loginContainer
        anchors.fill: parent

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
}