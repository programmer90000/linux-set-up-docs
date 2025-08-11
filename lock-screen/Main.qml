import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

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

    // Inactivity timer
    Timer {
        id: inactivityTimer
        interval: 15000 // 15 seconds
        onTriggered: if (state === "login") state = "preLogin"
    }

    // Reset timer on any interaction
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.AllButtons
        onPositionChanged: inactivityTimer.restart()
        onClicked: {
            inactivityTimer.restart()
            mouse.accepted = false // Allow click to propagate
        }
    }

    Keys.onPressed: inactivityTimer.restart()

    // Function to update time and date
    function updateTime() {
        var date = new Date();
        var timeString = Qt.formatTime(date, "hh:mm:ss");
        var dateString = Qt.formatDate(date, "dddd, MMMM d");
        
        if (preLoginTimeText) preLoginTimeText.text = timeString;
        if (preLoginDateText) preLoginDateText.text = dateString;
        if (loginTimeText) loginTimeText.text = timeString;
        if (loginDateText) loginDateText.text = dateString;
    }

    // Timer to update time
    Timer {
        interval: 1000 // Update every second
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    // Pre-login screen
    Item {
        id: preLoginScreen
        anchors.fill: parent
        focus: true // Allow keyboard focus

        Image {
            anchors.fill: parent
            source: "./assets/background.jpg"
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        // Time and Date Display for pre-login
        Column {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 40 
            }
            spacing: 10
            width: Math.max(preLoginDateText.implicitWidth, preLoginTimeText.implicitWidth) + 20

            Text {
                id: preLoginDateText
                width: parent.width
                color: "white"
                font.pixelSize: 24
                style: Text.Outline
                styleColor: "#80000000"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: preLoginTimeText
                width: parent.width
                color: "white"
                font.pixelSize: 48
                font.bold: true
                style: Text.Outline
                styleColor: "#80000000"
                horizontalAlignment: Text.AlignHCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.parent.state = "login"
        }

        Keys.onPressed: parent.parent.state = "login"
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

        // Time and Date Display for login screen
        Column {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 40 
            }
            spacing: 10
            width: Math.max(loginDateText.implicitWidth, loginTimeText.implicitWidth) + 20

            Text {
                id: loginDateText
                width: parent.width
                color: "white"
                font.pixelSize: 24
                style: Text.Outline
                styleColor: "#80000000"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: loginTimeText
                width: parent.width
                color: "white"
                font.pixelSize: 48
                font.bold: true
                style: Text.Outline
                styleColor: "#80000000"
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Login Form
        Column {
            id: loginForm
            anchors.centerIn: parent
            spacing: 10

            // User icon above password field
            Image {
                id: currentUserIcon
                anchors.horizontalCenter: parent.horizontalCenter
                source: userListView.currentItem ? userListView.currentItem.userIcon : "qrc:/assets/user-icon.png"
                sourceSize: Qt.size(96, 96)
                width: 96
                height: 96
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
                onTextChanged: {
                    inactivityTimer.restart()
                    loginError.visible = false
                }
                Keys.onReturnPressed: loginButton.clicked()
            }

            // Desktop environment/session selector
            ComboBox {
                id: sessionBox
                model: sessionModel
                textRole: "name"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                onCurrentIndexChanged: inactivityTimer.restart()
            }

            // Error message
            Text {
                id: loginError
                visible: false
                text: "Password incorrect. Please try again"
                color: "#ff4444"
                font.pixelSize: 12
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: loginButton
                text: "Login"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    if (userListView.currentIndex >= 0) {
                        var success = sddm.login(userListView.currentItem.userName, password.text, sessionBox.currentIndex);
                        
                        if (!success) {
                            loginError.visible = true;
                            password.text = "";
                            password.forceActiveFocus();
                            shakeAnimation.start();
                        }
                    }
                }
            }
        }

        // Shake animation for error feedback
        SequentialAnimation {
            id: shakeAnimation
            loops: 2
            PropertyAnimation {
                target: loginForm
                property: "x"
                from: 0
                to: -10
                duration: 50
            }
            PropertyAnimation {
                target: loginForm
                property: "x"
                from: -10
                to: 10
                duration: 50
            }
            PropertyAnimation {
                target: loginForm
                property: "x"
                from: 10
                to: 0
                duration: 50
            }
        }

        // User List
        Rectangle {
            id: userListContainer
            width: 300
            height: Math.min(400, userListView.contentHeight)
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
                    height: 64
                    flat: true
                    highlighted: ListView.isCurrentItem

                    // Store user properties
                    property string userName: model.name
                    property string userIcon: model.icon || "qrc:/assets/user-icon.png"

                    contentItem: RowLayout {
                        spacing: 10

                        Image {
                            source: parent.parent.userIcon
                            sourceSize: Qt.size(48, 48)
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                        }

                        Label {
                            text: model.name
                            color: highlighted ? "white" : "#ccc"
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    onClicked: {
                        userListView.currentIndex = index;
                        password.forceActiveFocus();
                    }
                }
                onCurrentIndexChanged: {
                    password.text = "";
                    loginError.visible = false;
                    inactivityTimer.restart();
                }
            }
        }

        // Power Menu Components
        Image {
            id: powerButton
            source: "./assets/gear-icon.png"
            width: 32
            height: 32
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 20
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 16
                height: width
                radius: width / 2
                color: "#80000000"
                z: -1
            }

            MouseArea {
                anchors.fill: parent
                onClicked: powerMenu.visible = !powerMenu.visible
            }
        }

        // Power Menu
        Rectangle {
            id: powerMenu
            visible: false
            width: 200
            height: powerMenuColumn.height + 20
            color: "#80000000"
            radius: 5
            anchors {
                right: powerButton.right
                bottom: powerButton.top
                bottomMargin: 10
            }

            Column {
                id: powerMenuColumn
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 10
                }
                spacing: 10

                // Shutdown Button
                Button {
                    width: parent.width
                    height: 40
                    flat: true

                    contentItem: Row {
                        spacing: 10
                        Image {
                            source: "./assets/shutdown-icon.png"
                            sourceSize: Qt.size(24, 24)
                            width: 24
                            height: 24
                        }
                        Text {
                            text: "Shutdown"
                            color: "white"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        color: parent.hovered ? "#40ffffff" : "transparent"
                        radius: 3
                    }

                    onClicked: {
                        powerMenu.visible = false;
                        sddm.powerOff();
                    }
                }

                // Restart Button
                Button {
                    width: parent.width
                    height: 40
                    flat: true
                
                    contentItem: Row {
                        spacing: 10
                        Image {
                            source: "./assets/restart-icon.png"
                            sourceSize: Qt.size(24, 24)
                            width: 24
                            height: 24
                        }
                        Text {
                            text: "Restart"
                            color: "white"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        color: parent.hovered ? "#40ffffff" : "transparent"
                        radius: 3
                    }

                    onClicked: {
                        powerMenu.visible = false;
                        sddm.reboot();
                    }
                }

                // Suspend Button
                Button {
                    width: parent.width
                    height: 40
                    flat: true

                    contentItem: Row {
                        spacing: 10
                        Image {
                            source: "./assets/suspend-icon.png"
                            sourceSize: Qt.size(24, 24)
                            width: 24
                            height: 24
                        }
                        Text {
                            text: "Suspend"
                            color: "white"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        color: parent.hovered ? "#40ffffff" : "transparent"
                        radius: 3
                    }

                    onClicked: {
                        powerMenu.visible = false;
                        sddm.suspend();
                    }
                }
            }
        }

        // Overlay to close power menu when clicking outside
        MouseArea {
            anchors.fill: parent
            enabled: powerMenu.visible
            onClicked: powerMenu.visible = false
            z: powerMenu.z - 1
        }
    }
}
