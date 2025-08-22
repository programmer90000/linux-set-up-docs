import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

Item {
    id: loginScreen
    
    signal loginRequested()
    signal loginFailed()
    
    function clearPassword() {
        passwordField.text = "";
    }
    
    function hideError() {
        loginError.visible = false;
    }
    
    function updateTimeDate(timeString, dateString) {
        loginDateText.text = dateString;
        loginTimeText.text = timeString;
    }

    // Background
    Image {
        anchors.fill: parent
        source: "../assets/background.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
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
            id: passwordField
            placeholderText: "Password"
            echoMode: TextInput.Password
            onTextChanged: {
                loginRequested();
                loginError.visible = false;
            }
            Keys.onReturnPressed: loginButton.clicked()
            Keys.onEnterPressed: loginButton.clicked()
        }

        // Desktop environment/session selector
        ComboBox {
            id: sessionBox
            model: sessionModel
            textRole: "name"
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            onCurrentIndexChanged: loginRequested()
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
                    var success = sddm.login(userListView.currentItem.userName, passwordField.text, sessionBox.currentIndex);
                    
                    if (!success) {
                        loginError.visible = true;
                        passwordField.text = "";
                        passwordField.forceActiveFocus();
                        shakeAnimation.start();
                        loginFailed();
                    } else {
                        passwordField.text = "";
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
            model: userModel
            currentIndex: 0
            delegate: Button {
                width: ListView.view.width
                height: 64
                flat: true
                highlighted: ListView.isCurrentItem

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
                    passwordField.forceActiveFocus();
                    loginRequested();
                }
            }
            onCurrentIndexChanged: {
                passwordField.text = "";
                loginError.visible = false;
                loginRequested();
            }
        }
    }

    PowerMenu {
        id: powerMenu
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
    }
}