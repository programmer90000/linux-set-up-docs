import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons

ColumnLayout {
    // Main Icon Configuration
    property alias cfg_mainIconName: mainIconName.icon.name
    
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

    Item {
        Layout.fillHeight: true
    }
}