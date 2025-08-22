import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    width: 640
    height: 480

    // States for pre-login and login screens
    states: [
        State {
            name: "preLogin"
            PropertyChanges { target: preLoginLoader; visible: true }
            PropertyChanges { target: loginScreenLoader; visible: false }
        },
        State {
            name: "login"
            PropertyChanges { target: preLoginLoader; visible: false }
            PropertyChanges { target: loginScreenLoader; visible: true }
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
        
        if (preLoginLoader.item && preLoginLoader.item.timeText) 
            preLoginLoader.item.timeText.text = timeString;
        if (preLoginLoader.item && preLoginLoader.item.dateText) 
            preLoginLoader.item.dateText.text = dateString;
        if (loginScreenLoader.item && loginScreenLoader.item.timeText) 
            loginScreenLoader.item.timeText.text = timeString;
        if (loginScreenLoader.item && loginScreenLoader.item.dateText) 
            loginScreenLoader.item.dateText.text = dateString;
    }

    // Timer to update time
    Timer {
        interval: 1000 // Update every second
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    // Pre-login screen (loaded from external component)
    Loader {
        id: preLoginLoader
        anchors.fill: parent
        source: "components/pre-login.qml"
        
        onLoaded: {
            item.loginRequested.connect(function() {
                parent.state = "login";
            });
        }
    }

    // Login screen (loaded from external component)
    Loader {
        id: loginScreenLoader
        anchors.fill: parent
        source: "components/login-screen.qml"
        visible: false
        
        onLoaded: {
            // Connect to go back to pre-login screen
            item.goToPreLogin.connect(function() {
                parent.state = "preLogin";
            });
            
            // Connect to inactivity timer
            item.resetInactivityTimer.connect(function() {
                inactivityTimer.restart();
            });
        }
    }
}