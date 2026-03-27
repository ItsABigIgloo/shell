import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components
import qs.components.controls
import qs.services
import qs.config
import Caelestia
import Quickshell.Io

StyledRect {
    id: taskManagerRoot
    anchors.fill: parent
    radius: (Appearance && Appearance.rounding.normal) || 12
    color: (Colours && Colours.tPalette.m3surfaceContainer) || "#222"

    property var processListModel: []

    Process {
        id: psProcess
        command: ["sh", "-c", "ps -eo pid,comm,%cpu --sort=-%cpu | head -n 7 | tail -n 6"]

        stdout: StdioCollector {
            onStreamFinished: {
                let output = text.trim();
                if (!output) {
                    processListModel = [];
                    return;
                }

                let lines = output.split("\n");
                let tempModel = [];

                for (let line of lines) {
                    let parts = line.trim().split(/\s+/);
                    if (parts.length >= 3) {
                        tempModel.push({
                            "pid": parts[0],
                            "name": parts[1],
                            "cpu": parts[2]
                        });
                    }
                }
                processListModel = tempModel;
            }
        }
    }

    Process {
        id: killProcess
        stdout: StdioCollector {
            onStreamFinished: {
                updateTimer.restart();
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                updateTimer.restart();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: (Appearance && Appearance.padding.large) || 16
        spacing: (Appearance && Appearance.spacing.small) || 4

        RowLayout {
            Layout.fillWidth: true
            StyledText {
                text: qsTr("TOP PROCESSES")
                font.pointSize: (Appearance && Appearance.font.size.small) || 12
                color: (Colours && Colours.palette.m3onSurfaceVariant) || "#aaa"
                Layout.fillWidth: true
            }
            IconButton {
                icon: "refresh"
                onClicked: psProcess.running = true
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: processListModel
            spacing: 6
            
            delegate: StyledRect {
                width: listView.width
                height: 50
                radius: (Appearance && Appearance.rounding.small) || 8
                color: (Colours && Colours.tPalette.m3surfaceVariant) || "#333"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: (Appearance && Appearance.padding.medium) || 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        StyledText {
                            text: modelData.name
                            font.bold: true
                            font.pointSize: (Appearance && Appearance.font.size.normal) || 14
                            color: (Colours && Colours.palette.m3onSurface) || "#eee"
                            elide: Text.ElideRight
                        }
                        StyledText {
                            text: "PID: " + modelData.pid + " • CPU: " + modelData.cpu + "%"
                            font.pointSize: (Appearance && Appearance.font.size.tiny) || 10
                            color: (Colours && Colours.palette.m3onSurfaceVariant) || "#aaa"
                        }
                    }
                        Item { Layout.fillWidth: true }
                    IconButton {
                        icon: "delete" 
                        color: "#ef5350"
                        onClicked: {
                            killProcess.command = ["kill", "-9", modelData.pid];
                            killProcess.running = true;
                        }
                    }
                }
            }
        }
    }
    Timer {
        id: updateTimer
        interval: 30000
        running: true
        repeat: true
        onTriggered: psProcess.running = true
    }

    Component.onCompleted: psProcess.running = true
}
