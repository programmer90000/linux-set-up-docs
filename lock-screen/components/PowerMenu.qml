import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: powerMenuRoot
    width: 32
    height: 32
    
    property bool menuVisible: false
    
    Image {
        id: powerButton
        source: "../assets/gear-icon.png"
        width: 32
        height: 32
        anchors.fill: parent

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
            onClicked: menuVisible = !menuVisible
        }
    }

    // Power Menu
    Rectangle {
        id: powerMenuPopup
        visible: menuVisible
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
                        source: "../assets/shutdown-icon.png"
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
                    menuVisible = false;
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
                        source: "../assets/restart-icon.png"
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
                    menuVisible = false;
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
                        source: "../assets/suspend-icon.png"
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
                    menuVisible = false;
                    sddm.suspend();
                }
            }
        }
    }

    // Overlay to close power menu when clicking outside
    MouseArea {
        anchors.fill: parent.parent
        enabled: menuVisible
        onClicked: menuVisible = false
        z: powerMenuPopup.z - 1
    }
}