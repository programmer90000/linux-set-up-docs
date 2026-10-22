import QtQuick
import QtQuick.Controls

Rectangle {
    id: powerButtonRoot
    width: 48
    height: 48
    radius: 24
    
    activeFocusOnTab: true
    
    color: activeFocus ? "#3a6ea5" : (mouseArea.containsPress ? "#3a6ea5" : (mouseArea.containsMouse ? "#2a2a2a" : "#1e1e1e"))
    border.color: activeFocus ? "#ffffff" : "#3a3a3a"
    border.width: activeFocus ? 2 : 1
    
    property bool menuOpen: false
    property int selectedMenuIndex: 0
    
    // Signals for system actions
    signal shutdownRequested()
    signal restartRequested()
    signal suspendRequested()
   
    // Toggle menu or activate selection from button focus
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            if (!menuOpen) {
                openMenu()
            }
            event.accepted = true
        }
    }
    
    function openMenu() {
        menuOpen = true
        selectedMenuIndex = 0
        powerMenu.open()
        powerMenu.forceActiveFocus()
    }
    
    function closeMenu() {
        powerMenu.close()
        menuOpen = false
        powerButtonRoot.forceActiveFocus()
    }
    
    function triggerSelectedAction() {
        var action = selectedMenuIndex
        closeMenu()
        if (action === 0) shutdownRequested()
        else if (action === 1) restartRequested()
        else if (action === 2) suspendRequested()
    }
    
    Image {
        id: powerIcon
        anchors.centerIn: parent
        width: 24
        height: 24
        source: Qt.resolvedUrl("assets/gear-icon.png")
        fillMode: Image.PreserveAspectFit
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            menuOpen = !menuOpen
            if (menuOpen) {
                powerMenu.open()
            } else {
                powerMenu.close()
            }
        }
    }
    
    Popup {
        id: powerMenu
        width: 160
        height: 160
        modal: false
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        x: powerButtonRoot.width - width
        y: -height - 10
        
        background: Rectangle {
            color: "#2a2a2a"
            radius: 8
            border.color: powerMenu.activeFocus ? "#5a8ec5" : "#3a3a3a"
            border.width: 1
        }
        
        onClosed: menuOpen = false
       
        // Handle Up/Down arrow navigation and Enter inside popup
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Down) {
                powerButtonRoot.selectedMenuIndex = (powerButtonRoot.selectedMenuIndex + 1) % 3
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                powerButtonRoot.selectedMenuIndex = (powerButtonRoot.selectedMenuIndex + 2) % 3
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                powerButtonRoot.triggerSelectedAction()
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                powerButtonRoot.closeMenu()
                event.accepted = true
            }
        }
        
        Column {
            spacing: 5
            width: parent.width
            padding: 10
            
            Item {
                width: parent.width
                height: 40
                
                Rectangle {
                    id: shutdownBg
                    anchors.fill: parent
                    radius: 4
                    color: (powerButtonRoot.selectedMenuIndex === 0 || shutdownMouse.containsMouse) ? "#3a6ea5" : "transparent"
                }
                
                Image {
                    id: shutdownIcon
                    width: 20
                    height: 20
                    source: Qt.resolvedUrl("assets/shutdown-icon.png")
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }
                
                Text {
                    text: "Shut Down"
                    color: "white"
                    font.pixelSize: 14
                    anchors {
                        left: shutdownIcon.right
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: shutdownMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        powerButtonRoot.selectedMenuIndex = 0
                        powerButtonRoot.triggerSelectedAction()
                    }
                }
            }
            
            Item {
                width: parent.width
                height: 40
                
                Rectangle {
                    id: restartBg
                    anchors.fill: parent
                    radius: 4
                    color: (powerButtonRoot.selectedMenuIndex === 1 || restartMouse.containsMouse) ? "#3a6ea5" : "transparent"
                }
                
                Image {
                    id: restartIcon
                    width: 20
                    height: 20
                    source: Qt.resolvedUrl("assets/restart-icon.png")
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }
                
                Text {
                    text: "Restart"
                    color: "white"
                    font.pixelSize: 14
                    anchors {
                        left: restartIcon.right
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: restartMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        powerButtonRoot.selectedMenuIndex = 1
                        powerButtonRoot.triggerSelectedAction()
                    }
                }
            }
            
            Item {
                width: parent.width
                height: 40
                
                Rectangle {
                    id: suspendBg
                    anchors.fill: parent
                    radius: 4
                    color: (powerButtonRoot.selectedMenuIndex === 2 || suspendMouse.containsMouse) ? "#3a6ea5" : "transparent"
                }
                
                Image {
                    id: suspendIcon
                    width: 20
                    height: 20
                    source: Qt.resolvedUrl("assets/suspend-icon.png")
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }
                
                Text {
                    text: "Suspend"
                    color: "white"
                    font.pixelSize: 14
                    anchors {
                        left: suspendIcon.right
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: suspendMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        powerButtonRoot.selectedMenuIndex = 2
                        powerButtonRoot.triggerSelectedAction()
                    }
                }
            }
        }
    }
    
    ToolTip {
        visible: mouseArea.containsMouse && !menuOpen
        text: "Power Options"
        delay: 500
        background: Rectangle {
            color: "#1e1e1e"
            radius: 4
        }
        contentItem: Text {
            text: parent.text
            color: "white"
        }
    }
}
