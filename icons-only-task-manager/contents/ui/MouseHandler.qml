import QtQuick 2.15

import org.kde.draganddrop 2.0

import org.kde.taskmanager 0.1 as TaskManager

import "code/tools.js" as TaskTools

Item {
    signal urlsDropped(var urls)

    property Item target
    property Item ignoredItem
    property bool isGroupDialog: false
    property bool moved: false

    property alias hoveredItem: dropHandler.hoveredItem
    property alias handleWheelEvents: wheelHandler.active

    function insertIndexAt(above, x, y) {
        if (above) {
            return above.itemIndex;
        } else {
            var distance = tasks.vertical ? x : y;
            var step = tasks.vertical ? LayoutManager.taskWidth() : LayoutManager.taskHeight();
            var stripe = Math.ceil(distance / step);

            if (stripe === LayoutManager.calculateStripes()) {
                return tasks.tasksModel.count - 1;
            } else {
                return stripe * LayoutManager.tasksPerStripe();
            }
        }
    }

    Timer {
        id: ignoreItemTimer

        repeat: false
        interval: 750

        onTriggered: {
            ignoredItem = null;
        }
    }

    Connections {
        target: tasks

        function onDragSourceChanged() {
            if (!dragSource) {
                ignoredItem = null;
                ignoreItemTimer.stop();
            }
        }
    }

    WheelHandler {
        id: wheelHandler

        property bool active: true
        property int wheelDelta: 0;

        enabled: active && plasmoid.configuration.wheelEnabled

        onWheel: {
            wheelDelta = TaskTools.wheelActivateNextPrevTask(null, wheelDelta, event.angleDelta.y, plasmoid.configuration.wheelSkipMinimized, tasks);
        }
    }

    DropArea {
        id: dropHandler

        anchors.fill: parent

        preventStealing: true;

        property Item hoveredItem

        //ignore anything that is neither internal to TaskManager or a URL list
        onDragEnter: {
            if (event.mimeData.formats.indexOf("text/x-plasmoidservicename") >= 0) {
                event.ignore();
            }
        }

        onDragMove: {
            if (target.animating) {
                return;
            }

            let above;
            if (isGroupDialog) {
                above = target.itemAt(event.x, event.y);
            } else {
                above = target.childAt(event.x, event.y);
            }

            if (!above) {
                hoveredItem = null;
                activationTimer.stop();

                return;
            }


            if (!plasmoid.configuration.separateLaunchers && tasks.dragSource != null
                 && tasks.dragSource.m.IsLauncher === true && above.m.IsLauncher !== true
                 && above === ignoredItem) {
                return;
            } else {
                ignoredItem = null;
            }

            if (tasksModel.sortMode === TaskManager.TasksModel.SortManual && tasks.dragSource) {
                // Reject drags between different TaskList instances.
                if (tasks.dragSource.parent !== above.parent) {
                    return;
                }

                var insertAt = insertIndexAt(above, event.x, event.y);

                if (tasks.dragSource !== above && tasks.dragSource.itemIndex !== insertAt) {
                    if (!!tasks.groupDialog) {
                        tasksModel.move(tasks.dragSource.itemIndex, insertAt,
                            tasksModel.makeModelIndex(tasks.groupDialog.visualParent.itemIndex));
                    } else {
                        tasksModel.move(tasks.dragSource.itemIndex, insertAt);
                    }

                    ignoredItem = above;
                    ignoreItemTimer.restart();
                }
            } else if (!tasks.dragSource && hoveredItem !== above) {
                hoveredItem = above;
                activationTimer.restart();
            }
        }

        onDragLeave: {
            hoveredItem = null;
            activationTimer.stop();
        }

        onDrop: {
            // Reject internal drops.
            if (event.mimeData.formats.indexOf("application/x-orgkdeplasmataskmanager_taskbuttonitem") >= 0) {
                event.ignore();
                return;
            }

            // Reject plasmoid drops.
            if (event.mimeData.formats.indexOf("text/x-plasmoidservicename") >= 0) {
                event.ignore();
                return;
            }

            if (event.mimeData.hasUrls) {
                parent.urlsDropped(event.mimeData.urls);
                return;
            }
        }

        Timer {
            id: activationTimer

            interval: 250
            repeat: false

            onTriggered: {
                if (parent.hoveredItem.m.IsGroupParent === true) {
                    TaskTools.createGroupDialog(parent.hoveredItem, tasks);
                } else if (parent.hoveredItem.m.IsLauncher !== true) {
                    tasksModel.requestActivate(parent.hoveredItem.modelIndex());
                }
            }
        }
    }
}
