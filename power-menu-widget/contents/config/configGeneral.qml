import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
    // Main Icon
    property alias cfg_mainIconName: iconButton.icon.name
    
    // Widget Size
    property alias cfg_width: widthSpinBox.value
    property alias cfg_height: heightSpinBox.value
    
    // Power Options
    property alias cfg_lockScreenEnabled: lockScreenCheck.checked
    property alias cfg_logOutEnabled: logOutCheck.checked
    property alias cfg_suspendEnabled: suspendCheck.checked
    property alias cfg_restartEnabled: restartCheck.checked
    property alias cfg_shutDownEnabled: shutDownCheck.checked

    // Icon Selection
    RowLayout {
        Label { text: i18n("Icon:") }
        Button {
            id: iconButton
            onClicked: iconDialog.open()
        }
        KQuickAddons.IconDialog {
            id: iconDialog
            onIconNameChanged: iconButton.icon.name = iconName
        }
    }

    // Widget Size
    RowLayout {
        Label { text: i18n("Width:") }
        SpinBox {
            id: widthSpinBox
            from: 100
            to: 500
        }
        Label { text: i18n("Height:") }
        SpinBox {
            id: heightSpinBox
            from: 100
            to: 500
        }
    }

    // Power Options Toggles
    ColumnLayout {
        spacing: PlasmaCore.Units.smallSpacing
        
        CheckBox {
            id: lockScreenCheck
            text: i18n("Show Lock Screen option")
        }
        CheckBox {
            id: logOutCheck
            text: i18n("Show Log Out option")
        }
        CheckBox {
            id: suspendCheck
            text: i18n("Show Suspend option")
        }
        CheckBox {
            id: restartCheck
            text: i18n("Show Restart option")
        }
        CheckBox {
            id: shutDownCheck
            text: i18n("Show Shut Down option")
        }
    }
}