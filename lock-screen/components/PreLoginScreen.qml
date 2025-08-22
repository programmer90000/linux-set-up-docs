import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: preLoginScreen
    
    signal activated()
    
    function updateTimeDate(timeString, dateString) {
        preLoginDateText.text = dateString;
        preLoginTimeText.text = timeString;
    }

    Image {
        anchors.fill: parent
        source: "../assets/background.jpg"
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
        onClicked: activated()
    }

    Keys.onPressed: activated()
}