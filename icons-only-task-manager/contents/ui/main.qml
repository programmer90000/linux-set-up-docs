import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.workspace.trianglemousefilter 1.0

import org.kde.taskmanager 0.1 as TaskManager
import org.kde.plasma.private.taskmanager 0.1 as TaskManagerApplet

import "code/layout.js" as LayoutManager
import "code/tools.js" as TaskTools

MouseArea {
    id: tasks

    anchors.fill: parent
    hoverEnabled: true

    rotation: plasmoid.configuration.reverseMode && plasmoid.formFactor === PlasmaCore.Types.Vertical ? 180 : 0

    readonly property bool shouldShirnkToZero: !LayoutManager.logicalTaskCount()
    property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool iconsOnly: plasmoid.pluginName === "org.kde.plasma.icontasks"

    property var toolTipOpenedByClick: null

    property QtObject contextMenuComponent: Qt.createComponent("ContextMenu.qml")
    property QtObject pulseAudioComponent: Qt.createComponent("PulseAudio.qml")

    property var toolTipAreaItem: null

    property bool needLayoutRefresh: false;
    property variant taskClosedWithMouseMiddleButton: []
    property alias taskList: taskList

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    Plasmoid.constraintHints: PlasmaCore.Types.CanFillArea

    Plasmoid.onUserConfiguringChanged: {
        if (plasmoid.userConfiguring && !!tasks.groupDialog) {
            tasks.groupDialog.visible = false;
        }
    }

    Layout.fillWidth: tasks.vertical ? true : plasmoid.configuration.fill
    Layout.fillHeight: !tasks.vertical ? true : plasmoid.configuration.fill
    Layout.minimumWidth: {
        if (shouldShirnkToZero) {
            return PlasmaCore.Units.gridUnit; // For edit mode
        }
        return tasks.vertical ? 0 : LayoutManager.preferredMinWidth();
    }
    Layout.minimumHeight: {
        if (shouldShirnkToZero) {
            return PlasmaCore.Units.gridUnit; // For edit mode
        }
        return !tasks.vertical ? 0 : LayoutManager.preferredMinHeight();
    }

    Layout.preferredWidth: {
        if (shouldShirnkToZero) {
            return 0.01;
        }
        if (tasks.vertical) {
            return PlasmaCore.Units.gridUnit * 10;
        }
        return (LayoutManager.logicalTaskCount() * LayoutManager.preferredMaxWidth()) / LayoutManager.calculateStripes();
    }
    Layout.preferredHeight: {
        if (shouldShirnkToZero) {
            return 0.01;
        }
        if (tasks.vertical) {
            return (LayoutManager.logicalTaskCount() * LayoutManager.preferredMaxHeight()) / LayoutManager.calculateStripes();
        }
        return PlasmaCore.Units.gridUnit * 2;
    }

    property Item dragSource: null

    signal requestLayout
    signal windowsHovered(variant winIds, bool hovered)
    signal activateWindowView(variant winIds)

    onDragSourceChanged: {
        if (dragSource == null) {
            tasksModel.syncLaunchers();
        }
    }

    onExited: {
        if (needLayoutRefresh) {
            LayoutManager.layout(taskRepeater)
            needLayoutRefresh = false;
        }
    }

    function publishIconGeometries(taskItems) {
        if (TaskTools.taskManagerInstanceCount >= 2) {
            return;
        }
        for (var i = 0; i < taskItems.length - 1; ++i) {
            var task = taskItems[i];

            if (task.IsLauncher !== true && task.m.IsStartup !== true) {
                tasks.tasksModel.requestPublishDelegateGeometry(tasks.tasksModel.makeModelIndex(task.itemIndex),
                    backend.globalRect(task), task);
            }
        }
    }

    property TaskManager.TasksModel tasksModel: TaskManager.TasksModel {
        id: tasksModel

        readonly property int logicalLauncherCount: {
            if (plasmoid.configuration.separateLaunchers) {
                return launcherCount;
            }

            var startupsWithLaunchers = 0;

            for (var i = 0; i < taskRepeater.count; ++i) {
                var item = taskRepeater.itemAt(i);

                if (item && item.m.IsStartup === true && item.m.HasLauncher === true) {
                    ++startupsWithLaunchers;
                }
            }

            return launcherCount + startupsWithLaunchers;
        }

        virtualDesktop: virtualDesktopInfo.currentDesktop
        screenGeometry: plasmoid.screenGeometry
        activity: activityInfo.currentActivity

        filterByVirtualDesktop: plasmoid.configuration.showOnlyCurrentDesktop
        filterByScreen: plasmoid.configuration.showOnlyCurrentScreen
        filterByActivity: plasmoid.configuration.showOnlyCurrentActivity
        filterNotMinimized: plasmoid.configuration.showOnlyMinimized

        sortMode: sortModeEnumValue(plasmoid.configuration.sortingStrategy)
        launchInPlace: iconsOnly && plasmoid.configuration.sortingStrategy === 1
        separateLaunchers: {
            if (!iconsOnly && !plasmoid.configuration.separateLaunchers
                && plasmoid.configuration.sortingStrategy === 1) {
                return false;
            }

            return true;
        }

        groupMode: groupModeEnumValue(plasmoid.configuration.groupingStrategy)
        groupInline: !plasmoid.configuration.groupPopups && !iconsOnly
        groupingWindowTasksThreshold: (plasmoid.configuration.onlyGroupWhenFull && !iconsOnly
            ? LayoutManager.optimumCapacity(width, height) + 1 : -1)

        onLauncherListChanged: {
            layoutTimer.restart();
            plasmoid.configuration.launchers = launcherList;
        }

        onGroupingAppIdBlacklistChanged: {
            plasmoid.configuration.groupingAppIdBlacklist = groupingAppIdBlacklist;
        }

        onGroupingLauncherUrlBlacklistChanged: {
            plasmoid.configuration.groupingLauncherUrlBlacklist = groupingLauncherUrlBlacklist;
        }

        function sortModeEnumValue(index) {
            switch (index) {
                case 0:
                    return TaskManager.TasksModel.SortDisabled;
                case 1:
                    return TaskManager.TasksModel.SortManual;
                case 2:
                    return TaskManager.TasksModel.SortAlpha;
                case 3:
                    return TaskManager.TasksModel.SortVirtualDesktop;
                case 4:
                    return TaskManager.TasksModel.SortActivity;
                default:
                    return TaskManager.TasksModel.SortDisabled;
            }
        }

        function groupModeEnumValue(index) {
            switch (index) {
                case 0:
                    return TaskManager.TasksModel.GroupDisabled;
                case 1:
                    return TaskManager.TasksModel.GroupApplications;
            }
        }

        Component.onCompleted: {
            launcherList = plasmoid.configuration.launchers;
            groupingAppIdBlacklist = plasmoid.configuration.groupingAppIdBlacklist;
            groupingLauncherUrlBlacklist = plasmoid.configuration.groupingLauncherUrlBlacklist;

            // Only hook up view only after the above churn is done.
            taskRepeater.model = tasksModel;
        }
    }

    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }

    TaskManager.ActivityInfo {
        id: activityInfo
        readonly property string nullUuid: "00000000-0000-0000-0000-000000000000"
    }

    property TaskManagerApplet.Backend backend: TaskManagerApplet.Backend {
        taskManagerItem: tasks
        highlightWindows: plasmoid.configuration.highlightWindows

        onAddLauncher: {
            tasks.addLauncher(url);
        }

        Component.onCompleted: TaskTools.windowViewAvailable = windowViewAvailable;
    }

    PlasmaCore.DataSource {
        id: mpris2Source
        engine: "mpris2"
        connectedSources: sources
        onSourceAdded: {
            connectSource(source);
        }
        onSourceRemoved: {
            disconnectSource(source);
        }
        function sourceNameForLauncherUrl(launcherUrl, pid) {
            if (!launcherUrl || launcherUrl === "") {
                return "";
            }

            var desktopFileName = launcherUrl.toString().split('/').pop().split('?')[0].replace(".desktop", "")
            if (desktopFileName.indexOf("applications:") === 0) {
                desktopFileName = desktopFileName.substr(13)
            }

            let fallbackSource = "";

            for (var i = 0, length = connectedSources.length; i < length; ++i) {
                var source = connectedSources[i];
                // we intend to connect directly, otherwise the multiplexer steals the connection away
                if (source === "@multiplex") {
                    continue;
                }

                var sourceData = data[source];
                if (!sourceData) {
                    continue;
                }

                if (pid && sourceData.InstancePid === pid) {
                    return source;
                }
                if (sourceData.DesktopEntry === desktopFileName) {
                    fallbackSource = source;
                }

                var metadata = sourceData.Metadata;
                if (metadata) {
                    var kdePid = metadata["kde:pid"];
                    if (kdePid && pid === kdePid) {
                        return source;
                    }
                }
            }

            return fallbackSource;
        }

        function startOperation(source, op) {
            var service = serviceForSource(source)
            var operation = service.operationDescription(op)
            return service.startOperationCall(operation)
        }

        function goPrevious(source) {
            startOperation(source, "Previous");
        }
        function goNext(source) {
            startOperation(source, "Next");
        }
        function play(source) {
            startOperation(source, "Play");
        }
        function pause(source) {
            startOperation(source, "Pause");
        }
        function playPause(source) {
            startOperation(source, "PlayPause");
        }
        function stop(source) {
            startOperation(source, "Stop");
        }
        function raise(source) {
            startOperation(source, "Raise");
        }
        function quit(source) {
            startOperation(source, "Quit");
        }
    }

    Loader {
        id: pulseAudio
        sourceComponent: pulseAudioComponent
        active: pulseAudioComponent.status === Component.Ready
    }

    Timer {
        id: iconGeometryTimer

        interval: 500
        repeat: false

        onTriggered: {
            tasks.publishIconGeometries(taskList.children, tasks);
        }
    }

    Binding {
        target: plasmoid
        property: "status"
        value: (tasksModel.anyTaskDemandsAttention && plasmoid.configuration.unhideOnAttention
            ? PlasmaCore.Types.NeedsAttentionStatus : PlasmaCore.Types.PassiveStatus)
        restoreMode: Binding.RestoreBinding
    }

    Connections {
        target: plasmoid

        function onLocationChanged() {
            if (TaskTools.taskManagerInstanceCount >= 2) {
                return;
            }

            iconGeometryTimer.start();
        }
    }

    Connections {
        target: plasmoid.configuration

        function onLaunchersChanged() {
            tasksModel.launcherList = plasmoid.configuration.launchers
        }
        function onGroupingAppIdBlacklistChanged() {
            tasksModel.groupingAppIdBlacklist = plasmoid.configuration.groupingAppIdBlacklist;
        }
        function onGroupingLauncherUrlBlacklistChanged() {
            tasksModel.groupingLauncherUrlBlacklist = plasmoid.configuration.groupingLauncherUrlBlacklist;
        }
        function onIconSpacingChanged() {
            taskList.layout();
        }
    }

    property Component taskInitComponent: Component {
        Timer {
            id: timer

            interval: PlasmaCore.Units.longDuration
            running: true

            onTriggered: {
                tasksModel.requestPublishDelegateGeometry(parent.modelIndex(), backend.globalRect(parent), parent);
                timer.destroy();
            }
        }
    }

    Component {
        id: busyIndicator
        PlasmaComponents3.BusyIndicator {}
    }

    // Save drag data
    Item {
        id: dragHelper

        Drag.dragType: Drag.Automatic
        Drag.supportedActions: Qt.CopyAction | Qt.MoveAction | Qt.LinkAction
        Drag.onDragFinished: tasks.dragSource = null;
    }

    PlasmaCore.FrameSvgItem {
        id: taskFrame

        visible: false;

        imagePath: "widgets/tasks";
        prefix: "normal"
    }

    PlasmaCore.Svg {
        id: taskSvg

        imagePath: "widgets/tasks"
    }

    MouseHandler {
        id: mouseHandler

        anchors.fill: parent

        target: taskList

        onUrlsDropped: {
            // If all dropped URLs point to application desktop files, we'll add a launcher for each of them.
            var createLaunchers = urls.every(function (item) {
                return backend.isApplication(item)
            });

            if (createLaunchers) {
                urls.forEach(function (item) {
                    addLauncher(item);
                });
                return;
            }

            if (!hoveredItem) {
                return;
            }

            // DeclarativeMimeData urls is a QJsonArray but requestOpenUrls expects a proper QList<QUrl>.
            var urlsList = backend.jsonArrayToUrlList(urls);

            // Otherwise we'll just start a new instance of the application with the URLs as argument,
            // as you probably don't expect some of your files to open in the app and others to spawn launchers.
            tasksModel.requestOpenUrls(hoveredItem.modelIndex(), urlsList);
        }
    }

    ToolTipDelegate {
        id: openWindowToolTipDelegate
        visible: false
    }

    ToolTipDelegate {
        id: pinnedAppToolTipDelegate
        visible: false
    }

    TriangleMouseFilter {
        id: tmf
        anchors.fill: parent
        filterTimeOut: 300
        active: tasks.toolTipAreaItem && tasks.toolTipAreaItem.toolTipOpen
        blockFirstEnter: false

        edge: {
            switch (plasmoid.location) {
                case PlasmaCore.Types.BottomEdge:
                    return Qt.TopEdge;
                case PlasmaCore.Types.TopEdge:
                    return Qt.BottomEdge;
                case PlasmaCore.Types.LeftEdge:
                    return Qt.RightEdge;
                case PlasmaCore.Types.RightEdge:
                    return Qt.LeftEdge;
                default:
                    return Qt.TopEdge;
            }
        }

        secondaryPoint: {
            if (tasks.toolTipAreaItem === null) {
                return Qt.point(0, 0);
            }
            const x = tasks.toolTipAreaItem.x;
            const y = tasks.toolTipAreaItem.y;
            const height = tasks.toolTipAreaItem.height;
            const width = tasks.toolTipAreaItem.width;
            return Qt.point(x+width/2, height);
        }

        PlasmaComponents3.ScrollView {
            id: scrollView
            anchors.fill: parent
            clip: true

            PlasmaComponents3.ScrollBar.horizontal.policy: tasks.vertical ? PlasmaComponents3.ScrollBar.AlwaysOff : PlasmaComponents3.ScrollBar.AsNeeded
            PlasmaComponents3.ScrollBar.vertical.policy: tasks.vertical ? PlasmaComponents3.ScrollBar.AsNeeded : PlasmaComponents3.ScrollBar.AlwaysOff

            TaskList {
                id: taskList

                width: {
                    if (tasks.shouldShirnkToZero || taskRepeater.count === 0) return 0;
                    if (tasks.vertical) return scrollView.width;

                    // Horizontal panel
                    const taskWidth = LayoutManager.taskWidth();
                    if (flow === Flow.LeftToRight) { // single row
                        return taskRepeater.count * taskWidth + (taskRepeater.count - 1) * spacing;
                    } else { // TopToBottom, multi-row
                        const taskHeight = LayoutManager.taskHeight();
                        if (taskHeight === 0) return 0;
                        const itemsPerColumn = Math.max(1, Math.floor(scrollView.height / taskHeight));
                        const numColumns = Math.ceil(taskRepeater.count / itemsPerColumn);
                        return numColumns * taskWidth + (numColumns - 1) * spacing;
                    }
                }
                height: {
                    if (tasks.shouldShirnkToZero || taskRepeater.count === 0) return 0;
                    if (!tasks.vertical) return scrollView.height;

                    // Vertical panel
                    const taskHeight = LayoutManager.taskHeight();
                    if (flow === Flow.TopToBottom) { // single column
                        return taskRepeater.count * taskHeight + (taskRepeater.count - 1) * spacing;
                    } else { // LeftToRight, multi-column
                        const taskWidth = LayoutManager.taskWidth();
                        if (taskWidth === 0) return 0;
                        const itemsPerRow = Math.max(1, Math.floor(scrollView.width / taskWidth));
                        const numRows = Math.ceil(taskRepeater.count / itemsPerRow);
                        return numRows * taskHeight + (numRows - 1) * spacing;
                    }
                }

                flow: {
                    if (tasks.vertical) {
                        return plasmoid.configuration.forceStripes ? Flow.LeftToRight : Flow.TopToBottom
                    }
                    return plasmoid.configuration.forceStripes ? Flow.TopToBottom : Flow.LeftToRight
                }

                onAnimatingChanged: {
                    if (!animating) {
                        tasks.publishIconGeometries(children, tasks);
                    }
                }
                onWidthChanged: layoutTimer.restart()
                onHeightChanged: layoutTimer.restart()

                function layout() {
                    LayoutManager.layout(taskRepeater);
                }

                Timer {
                    id: layoutTimer

                    interval: 0
                    repeat: false

                    onTriggered: taskList.layout()
                }

                Repeater {
                    id: taskRepeater

                    delegate: Task {}
                    onItemAdded: taskList.layout()
                    onItemRemoved: {
                        if (tasks.containsMouse && index != taskRepeater.count &&
                            item.winIdList && item.winIdList.length > 0 &&
                            taskClosedWithMouseMiddleButton.indexOf(item.winIdList[0]) > -1) {
                            needLayoutRefresh = true;
                        } else {
                            taskList.layout();
                        }
                        taskClosedWithMouseMiddleButton = [];
                    }
                }
            }
        }
    }

    readonly property Component groupDialogComponent: Qt.createComponent("GroupDialog.qml")
    property GroupDialog groupDialog: null

    function hasLauncher(url) {
        return tasksModel.launcherPosition(url) != -1;
    }

    function addLauncher(url) {
        if (plasmoid.immutability !== PlasmaCore.Types.SystemImmutable) {
            tasksModel.requestAddLauncher(url);
        }
    }

    // This is called by plasmashell in response to a Meta+number shortcut.
    function activateTaskAtIndex(index) {
        if (typeof index !== "number") {
            return;
        }

        var task = taskRepeater.itemAt(index);
        if (task) {
            TaskTools.activateTask(task.modelIndex(), task.m, null, task, plasmoid, tasks);
        }
    }

    function createContextMenu(rootTask, modelIndex, args = {}) {
        const initialArgs = Object.assign(args, {
            visualParent: rootTask,
            modelIndex,
            mpris2Source,
            backend,
        });
        return contextMenuComponent.createObject(rootTask, initialArgs);
    }

    Component.onCompleted: {
        TaskTools.taskManagerInstanceCount += 1;
        tasks.requestLayout.connect(layoutTimer.restart);
        tasks.requestLayout.connect(iconGeometryTimer.restart);
        tasks.windowsHovered.connect(backend.windowsHovered);
        tasks.activateWindowView.connect(backend.activateWindowView);
    }

    Component.onDestruction: {
        TaskTools.taskManagerInstanceCount -= 1;
    }
}
