import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: mainWindow
    width: 1920
    height: 1080
    color: "transparent"  // Fallback color when splash is dismissed
    
    UserList {
        id: userList
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
        visible: !splashScreen.active
        enabled: !splashScreen.active
    	onUserSelected: {
	    loginForm.setUsername(username, avatarPath)
	    loginForm.passwordInput.forceActiveFocus()
	}
    }
    
    LoginForm {
        id: loginForm
        visible: !splashScreen.active
        onLoginRequested: sddm.login(username, password, 0)
        onShowSplashRequested: {
            splashScreen.show()
        }
    }
    
    SplashScreen {
        id: splashScreen
        onDismissed: {
            userList.focusList()
        }
    }
    
    Component.onCompleted: {
        // If splash starts active, it grabs focus; otherwise focus user list
        if (splashScreen.active) {
            splashScreen.forceActiveFocus()
        } else {
            userList.focusList()
        }
    }
}
