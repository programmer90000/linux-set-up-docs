import QtQuick
import QtQuick.Controls

Rectangle {
    id: splashScreen
    anchors.fill: parent
    color: "transparent"
    z: 1000
    
    property bool active: true
    
    signal dismissed()
    
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: Qt.resolvedUrl("splash_background.png")
        fillMode: Image.PreserveAspectCrop
        z: -1  // Ensure it stays behind the transparent overlay
        
        Rectangle {
            anchors.fill: parent
            color: "#80000000"  // Semi-transparent dark overlay
            z: 1
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: dismiss()
    }
    
    focus: true
    Keys.onPressed: dismiss()
    
    function dismiss() {
        if (!active) return
        active = false
        visible = false
        dismissed()
    }
    
    Component.onCompleted: {
        forceActiveFocus()
        console.log("Splash screen ready")
    }
}