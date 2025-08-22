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
            PropertyChanges { target: loginScreen; visible: false }
        },
        State {
            name: "login"
            PropertyChanges { target: preLoginScreen; visible: false }
            PropertyChanges { target: loginScreen; visible: true }
        }
    ]

    // Start with pre-login screen
    Component.onCompleted: state = "preLogin"

    // Clear password and error when switching to preLogin state
    onStateChanged: {
        if (state === "preLogin") {
            loginScreen.clearPassword();
            loginScreen.hideError();
        }
    }

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
        
        preLoginScreen.updateTimeDate(timeString, dateString);
        loginScreen.updateTimeDate(timeString, dateString);
    }

    // Timer to update time
    Timer {
        interval: 1000 // Update every second
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    // Pre-login screen component
    PreLoginScreen {
        id: preLoginScreen
        anchors.fill: parent
        onActivated: parent.state = "login"
    }

    // Login screen component
    LoginScreen {
        id: loginScreen
        anchors.fill: parent
        visible: false
        onLoginRequested: inactivityTimer.restart()
        onLoginFailed: inactivityTimer.restart()
    }
}