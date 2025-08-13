import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
    // Main Icon
    property alias cfg_mainIconName: iconButton.icon.name
    
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
}