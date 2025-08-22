import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: powerMenu
    width: 200
    height: powerMenuColumn.height + 20
    color: "#80000000"
    radius: 5
    visible: false

    signal shutdownRequested()
    signal restartRequested()
    signal suspendRequested()

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
                powerMenu.visible = false;
                shutdownRequested();
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
                powerMenu.visible = false;
                restartRequested();
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
                powerMenu.visible = false;
                suspendRequested();
            }
        }
    }
}