pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.components
import qs.components.live
import qs.components.containers
import qs.config

Item {
    id: root
    property var config: ({})

    readonly property bool isReady: config !== null

    property int _selectionTrigger: 0

    Component.onCompleted: {
        if (root.config && !root.config.software) {
            root.config.software = [];
        }
    }

    readonly property var softwareGroups: [
        {
            category: "Work",
            apps: [
                {
                    appId: "libreoffice",
                    name: "LibreOffice",
                    desc: "Complete, open-source office productivity suite.",
                    iconName: "description"
                },
                {
                    appId: "thunderbird",
                    name: "Thunderbird",
                    desc: "Standalone email, news, and chat client.",
                    iconName: "mail"
                }
            ]
        },
        {
            category: "Development",
            apps: [
                {
                    appId: "codium",
                    name: "VSCodium",
                    desc: "Free, telemetry-free binary release of VS Code.",
                    iconName: "code"
                },
                {
                    appId: "github_desktop",
                    name: "GitHub Desktop",
                    desc: "Simple GitHub collaboration from your desktop.",
                    iconName: "folder_special"
                }
            ]
        },
        {
            category: "Creative",
            apps: [
                {
                    appId: "gimp",
                    name: "GIMP",
                    desc: "GNU Image Manipulation Program for professional editing.",
                    iconName: "palette"
                },
                {
                    appId: "resolve",
                    name: "DaVinci Resolve",
                    desc: "Professional video editing and color correction.",
                    iconName: "movie"
                }
            ]
        },
        {
            category: "Gaming",
            apps: [
                {
                    appId: "steam",
                    name: "Steam",
                    desc: "The ultimate destination for playing and discussing games.",
                    iconName: "sports_esports"
                },
                {
                    appId: "obs",
                    name: "OBS Studio",
                    desc: "Free and open source software for video recording and streaming.",
                    iconName: "videocam"
                }
            ]
        }
    ]

    function toggleSoftware(appId) {
        if (!root.config)
            return;

        // THE FIX: Clone the array so QML recognizes it as entirely "new" data
        let currentList = root.config.software ? [...root.config.software] : [];
        let index = currentList.indexOf(appId);

        if (index === -1) {
            currentList.push(appId);
        } else {
            currentList.splice(index, 1);
        }

        root.config.software = currentList;
        root._selectionTrigger++;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        ColumnLayout {
            spacing: 0
            StyledText {
                text: qsTr("Additional Software")
                font.family: "Nunito"
                font.pointSize: 18
                font.bold: true
                color: Colours.palette.m3onSurface
            }
            StyledText {
                text: qsTr("Select any extra applications you'd like to install alongside the base system.")
                font.pointSize: 12
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        Flickable {
            id: scrollArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            contentWidth: width
            contentHeight: scrollContent.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                id: vbar
                policy: ScrollBar.AlwaysOn
                contentItem: Rectangle {
                    implicitWidth: 6
                    implicitHeight: 40
                    radius: width / 2
                    color: vbar.pressed ? Colours.palette.m3primary : Colours.palette.m3outlineVariant
                }
            }

            ColumnLayout {
                id: scrollContent
                width: parent.width - 16
                spacing: 24

                Repeater {
                    model: root.softwareGroups

                    delegate: ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        required property int index
                        required property var modelData

                        StyledText {
                            text: modelData.category
                            font.bold: true
                            font.pointSize: 14
                            color: Colours.palette.m3primary
                            Layout.topMargin: index === 0 ? 0 : 8
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: 16
                            rowSpacing: 16

                            Repeater {
                                model: modelData.apps

                                delegate: MouseArea {
                                    id: cardRoot
                                    required property var modelData

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 80
                                    hoverEnabled: true

                                    property bool selected: {
                                        let trigger = root._selectionTrigger;
                                        return root.config && root.config.software && root.config.software.indexOf(modelData.appId) !== -1;
                                    }

                                    onClicked: root.toggleSoftware(modelData.appId)

                                    StyledRect {
                                        anchors.fill: parent
                                        color: cardRoot.selected ? Colours.palette.m3surfaceVariant : Colours.palette.m3surfaceContainerHigh
                                        radius: 12
                                        border.width: 1
                                        border.color: cardRoot.selected ? Colours.palette.m3primary : (cardRoot.containsMouse ? Colours.palette.m3outline : Colours.palette.m3outlineVariant)

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 16
                                            spacing: 16

                                            MaterialIcon {
                                                text: modelData.iconName
                                                font.pointSize: 28
                                                color: cardRoot.selected ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                                            }

                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: 2

                                                StyledText {
                                                    text: modelData.name
                                                    font.bold: true
                                                    font.pointSize: 14
                                                    color: cardRoot.selected ? Colours.palette.m3onSurface : Colours.palette.m3onSurface
                                                }
                                                StyledText {
                                                    Layout.fillWidth: true
                                                    text: modelData.desc
                                                    font.pointSize: 11
                                                    color: Colours.palette.m3onSurfaceVariant
                                                    wrapMode: Text.WordWrap
                                                    maximumLineCount: 2
                                                    elide: Text.ElideRight
                                                }
                                            }

                                            MaterialIcon {
                                                text: cardRoot.selected ? "check_circle" : "radio_button_unchecked"
                                                font.pointSize: 24
                                                color: cardRoot.selected ? Colours.palette.m3primary : Colours.palette.m3outline
                                                Behavior on color {
                                                    ColorAnimation {
                                                        duration: 150
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
