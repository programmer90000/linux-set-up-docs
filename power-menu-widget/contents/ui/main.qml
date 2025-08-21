import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    // Main properties
    property string mainIconName: plasmoid.configuration.mainIconName
    
    // Power options
    property bool logOutEnabled: plasmoid.configuration.logOutEnabled
    property bool suspendEnabled: plasmoid.configuration.suspendEnabled
    property bool restartEnabled: plasmoid.configuration.restartEnabled
    property bool shutDownEnabled: plasmoid.configuration.shutDownEnabled

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.compactRepresentation: CompactRepresentation {}
}