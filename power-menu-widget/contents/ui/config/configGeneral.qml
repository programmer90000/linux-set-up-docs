import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons

ColumnLayout {
    // Main Icon Configuration
    property alias cfg_mainIconName: mainIconName.icon.name
    
    // Widget Size Configuration
    property alias cfg_width: widthSpinBox.value
    property alias cfg_height: heightSpinBox.value
    
    // Power Options Configuration
    property alias cfg_showLockScreen: showLockScreen.checked
    property alias cfg_showLogOut: showLogOut.checked
    property alias cfg_showSuspend: showSuspend.checked
    property alias cfg_showRestart: showRestart.checked
    property alias cfg_showShutDown: showShutDown.checked

    // Icon Selection Dialog
    KQuickAddons.IconDialog {
        id: iconDialog
        property var iconObj
        onIconNameChanged: iconObj.name = iconName
    }

    // Main Icon Selection
    RowLayout {
        Label {
            text: i18n("Main Icon:")
        }
        Button {
            id: mainIconName
            onClicked: {
                iconDialog.open()
                iconDialog.iconObj = mainIconName.icon
            }
        }
    }

    // Widget Size Configuration
    RowLayout {
        Label {
            text: i18n("Widget Size (px): W:")
        }
        SpinBox {
            id: widthSpinBox
            from: 100
            to: 500
            value: 200
        }
        Label {
            text: i18n("H:")
        }
        SpinBox {
            id: heightSpinBox
            from: 100
            to: 500
            value: 250
        }
    }

    // Power Options Toggles
    ColumnLayout {
        spacing: PlasmaCore.Units.smallSpacing

        CheckBox {
            id: showLockScreen
            text: i18n("Show Lock Screen option")
            checked: true
        }
        CheckBox {
            id: showLogOut
            text: i18n("Show Log Out option")
            checked: true
        }
        CheckBox {
            id: showSuspend
            text: i18n("Show Suspend option")
            checked: true
        }
        CheckBox {
            id: showRestart
            text: i18n("Show Restart option")
            checked: true
        }
        CheckBox {
            id: showShutDown
            text: i18n("Show Shut Down option")
            checked: true
        }
    }

    Item {
        Layout.fillHeight: true
    }
}