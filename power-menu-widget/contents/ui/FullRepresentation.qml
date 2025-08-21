import QtQuick 2.0
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.private.sessions 2.0 as Sessions

ColumnLayout {
    id: root
    spacing: PlasmaCore.Units.smallSpacing

    // DBus interfaces
    Sessions.SessionManagement {
        id: sessionManagement
    }

    // Log Out
    PlasmaComponents.Button {
        visible: root.logOutEnabled
        icon.name: "system-log-out"
        text: i18n("Log Out")
        onClicked: sessionManagement.requestLogout()
        Layout.fillWidth: true
    }

    // Suspend
    PlasmaComponents.Button {
        visible: root.suspendEnabled
        icon.name: "system-suspend"
        text: i18n("Suspend")
        onClicked: sessionManagement.suspend()
        Layout.fillWidth: true
    }

    // Restart
    PlasmaComponents.Button {
        visible: root.restartEnabled
        icon.name: "system-reboot"
        text: i18n("Restart")
        onClicked: sessionManagement.requestReboot()
        Layout.fillWidth: true
    }

    // Shut Down
    PlasmaComponents.Button {
        visible: root.shutDownEnabled
        icon.name: "system-shutdown"
        text: i18n("Shut Down")
        onClicked: sessionManagement.requestShutdown()
        Layout.fillWidth: true
    }
}