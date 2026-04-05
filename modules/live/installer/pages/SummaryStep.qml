pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.components.live
import qs.components.containers
import qs.config

Item {
    id: root
    property var config: ({})

    readonly property bool isReady: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        // Header
        ColumnLayout {
            spacing: 0
            StyledText {
                text: qsTr("Ready to Install")
                font.family: "Nunito"
                font.pointSize: 18
                font.bold: true
                color: Colours.palette.m3onSurface
            }
            StyledText {
                text: qsTr("Please review your selections before writing to disk.")
                font.pointSize: 12
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        // Summary
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Colours.palette.m3surfaceContainerHigh
            radius: 12
            border.width: 1
            border.color: Colours.palette.m3outlineVariant

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 24

                SummaryRow {
                    icon: "public"
                    title: "Timezone"
                    value: root.config && root.config.timezone !== "" ? root.config.timezone : "Not Selected"
                }

                SummaryRow {
                    icon: "person"
                    title: "Primary User"
                    value: root.config && root.config.fullname !== "" ? root.config.fullname + " (" + root.config.username + ")" : "Not Selected"
                }

                SummaryRow {
                    icon: "computer"
                    title: "Device Name"
                    value: root.config && root.config.hostname !== "" ? root.config.hostname : "Not Selected"
                }

                SummaryRow {
                    icon: "apps"
                    title: "Additional Software"
                    value: root.config && root.config.software && root.config.software.length > 0 ? root.config.software.length + " applications selected" : "Base System Only"
                }

                SummaryRow {
                    icon: "save"
                    title: "Target Disk"
                    value: root.config && root.config.targetDisk !== "" ? root.config.targetDisk : "Not Selected"
                    valueColor: Colours.palette.m3error
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }

    component SummaryRow: RowLayout {
        id: rowRoot // THE FIX: Explicit ID to prevent scope trapping
        property string icon: ""
        property string title: ""
        property string value: ""
        property color valueColor: Colours.palette.m3onSurface

        Layout.fillWidth: true
        spacing: 24

        MaterialIcon {
            text: rowRoot.icon
            font.pointSize: 28
            color: Colours.palette.m3primary
            Layout.alignment: Qt.AlignTop
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            StyledText {
                text: rowRoot.title
                font.pointSize: 12
                color: Colours.palette.m3onSurfaceVariant
            }

            StyledText {
                Layout.fillWidth: true
                text: rowRoot.value
                font.bold: true
                font.pointSize: 16
                color: rowRoot.valueColor
                wrapMode: Text.WordWrap
            }
        }
    }
}
