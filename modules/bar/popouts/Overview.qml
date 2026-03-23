pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.components
import qs.services
import qs.config
import qs.utils

Item {
    id: root

    required property Window wrapper

    implicitWidth: mainLayout.implicitWidth + (Appearance.padding.large * 3)
    implicitHeight: Quickshell.screens[0].height - (Appearance.padding.large * 4)

    StyledRect {
        id: container

        anchors.fill: parent
        color: "Transparent"
        radius: Appearance.rounding.small * 0.5
        border.color: Colours.palette.m3outlineVariant
        border.width: 0

        ColumnLayout {
            id: mainLayout

            anchors.fill: parent
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            RowLayout {
                Layout.fillWidth: true
                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Workspaces")
                    font.pointSize: Appearance.font.size.large
                    font.weight: 500
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Appearance.spacing.small

                Repeater {
                    model: 10

                    delegate: StyledRect {
                        id: workspaceDelegate

                        required property int index

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 45
                        Layout.minimumWidth: 80

                        property int workspaceId: index + 1
                        property bool isActive: workspaceId === (Hyprland.focusedMonitor?.activeWorkspace?.id ?? 0)

                        property var hyprWs: Hyprland.workspaces.values.find(w => w.id === workspaceDelegate.workspaceId)
                        property bool hasWindows: hyprWs ? hyprWs.windows > 0 : false

                        color: isActive ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceVariant
                        radius: Appearance.rounding.small
                        border.width: isActive ? 5 : 1
                        border.color: isActive ? Colours.palette.m3primary : "transparent"

                        Item {
                            id: minimapContainer

                            anchors.fill: parent
                            anchors.margins: 4
                            clip: true

                            property var monitor: Hyprland.monitorFor(Quickshell.screens[0])

                            property real scaleX: width / (monitor ? monitor.width : 1920)

                            property real scaleY: height / (monitor ? monitor.height : 1080)

                            Repeater {

                                model: Hypr.toplevels.values.filter(t => t.lastIpcObject?.workspace?.id === workspaceDelegate.workspaceId)

                                delegate: Rectangle {
                                    id: windowRect

                                    required property var modelData

                                    property var ipc: modelData.lastIpcObject
                                    property bool isFocusedWindow: Hypr.activeToplevel && Hypr.activeToplevel.lastIpcObject ? ipc.address === Hypr.activeToplevel.lastIpcObject.address : false

                                    x: (ipc.at[0] - (minimapContainer.monitor ? minimapContainer.monitor.x : 0)) * minimapContainer.scaleX
                                    y: (ipc.at[1] - (minimapContainer.monitor ? minimapContainer.monitor.y : 0)) * minimapContainer.scaleY
                                    width: ipc.size[0] * minimapContainer.scaleX
                                    height: ipc.size[1] * minimapContainer.scaleY

                                    color: Colours.palette.m3surfaceVariant
                                    border.color: isFocusedWindow ? Colours.palette.m3outlineVariant : Colours.palette.m3outline
                                    border.width: isFocusedWindow ? 2 : 1

                                    radius: Appearance.rounding.small ?? 1
                                    clip: true

                                    IconImage {
                                        anchors.centerIn: parent

                                        property real boxMin: Math.min(parent.width, parent.height)

                                        property real iconSize: Math.min(boxMin * 0.7, 24)
                                        implicitWidth: iconSize
                                        implicitHeight: iconSize

                                        source: Icons.getAppIcon(windowRect.ipc.class ?? "", "image-missing")
                                    }
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Hyprland.dispatch("workspace " + workspaceDelegate.workspaceId);
                                root.wrapper.close();
                            }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottomMargin: 6
                            height: workspaceText.implicitHeight + 8
                            radius: height / 3
                            color: "transparent"

                            StyledText {
                                id: workspaceText

                                anchors.centerIn: parent
                                text: workspaceDelegate.workspaceId
                                font.pointSize: Appearance.font.size.large
                                font.weight: 600
                                color: workspaceDelegate.isActive ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
                            }
                        }
                    }
                }
            }
        }
    }
}
