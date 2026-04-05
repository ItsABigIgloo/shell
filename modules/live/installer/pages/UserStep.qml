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

    Component.onCompleted: {
        if (root.config) {
            if (root.config.fullname)
                fullNameField.text = root.config.fullname;

            if (root.config.username) {
                usernameField.text = root.config.username;
                root.autoGenUsername = false;
            }
            if (root.config.hostname) {
                hostnameField.text = root.config.hostname;
                root.autoGenHostname = false;
            }
            if (root.config.birthday) {
                birthdayField.text = root.config.birthday;
                skipBirthday = false;
            }
            if (root.config.password) {
                passwordField.text = root.config.password;
                confirmField.text = root.config.password;
            }
        }
    }

    property bool autoGenUsername: true
    property bool autoGenHostname: true
    property bool skipBirthday: false

    readonly property bool isReady: config && fullNameField.text.trim() !== "" && (skipBirthday || birthdayField.text.replace(/_/g, "").trim().length === 5) && usernameField.text.trim() !== "" && hostnameField.text.trim() !== "" && passwordField.text !== "" && passwordField.text === confirmField.text

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        // Header
        ColumnLayout {
            spacing: 0
            StyledText {
                text: qsTr("User Setup")
                font.family: "Nunito"
                font.pointSize: 18
                font.bold: true
                color: Colours.palette.m3onSurface
            }
            StyledText {
                text: qsTr("Configure your primary account and device name.")
                font.pointSize: 12
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        // Form Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 16
            rowSpacing: 16

            // 1. Full Name
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 8

                StyledText {
                    text: qsTr("Full Name")
                    font.bold: true
                    color: Colours.palette.m3primary
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: Colours.palette.m3surfaceContainerHigh
                    radius: 8
                    border.width: 1
                    border.color: fullNameField.activeFocus ? Colours.palette.m3primary : Colours.palette.m3outlineVariant

                    TextInput {
                        id: fullNameField
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: Colours.palette.m3onSurface
                        font.pointSize: 14

                        onTextChanged: {
                            if (root.config)
                                root.config.fullname = text;

                            let baseName = text.split(" ")[0].toLowerCase().replace(/[^a-z0-9]/g, "");
                            if (baseName !== "") {
                                if (root.autoGenUsername)
                                    usernameField.text = baseName;
                                if (root.autoGenHostname)
                                    hostnameField.text = baseName + "-pc";
                            } else {
                                if (root.autoGenUsername)
                                    usernameField.text = "";
                                if (root.autoGenHostname)
                                    hostnameField.text = "";
                            }
                        }
                    }
                }
            }

            // 2. Birthday
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    StyledText {
                        text: qsTr("Birthday (MM/DD)")
                        font.bold: true
                        color: skipBirthday ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3primary
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    MouseArea {
                        Layout.preferredWidth: optOutRow.width
                        Layout.preferredHeight: optOutRow.height
                        onClicked: {
                            skipBirthday = !skipBirthday;
                            if (skipBirthday) {
                                birthdayField.text = "";
                                if (root.config)
                                    root.config.birthday = "";
                            }
                        }

                        Row {
                            id: optOutRow
                            spacing: 6
                            MaterialIcon {
                                text: skipBirthday ? "check_box" : "check_box_outline_blank"
                                color: skipBirthday ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                                font.pointSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            StyledText {
                                text: qsTr("Opt out")
                                font.pointSize: 12
                                color: Colours.palette.m3onSurfaceVariant
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: skipBirthday ? Colours.palette.m3surfaceContainer : Colours.palette.m3surfaceContainerHigh
                    radius: 8
                    border.width: 1
                    border.color: skipBirthday ? Colours.palette.m3outlineVariant : (birthdayField.activeFocus ? Colours.palette.m3primary : Colours.palette.m3outlineVariant)
                    opacity: skipBirthday ? 0.5 : 1.0

                    TextInput {
                        id: birthdayField
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: Colours.palette.m3onSurface
                        font.pointSize: 14
                        enabled: !skipBirthday

                        inputMask: skipBirthday ? "" : "99/99;_"

                        onTextChanged: if (root.config && !skipBirthday)
                            root.config.birthday = text
                    }
                }
            }

            // 3. Username
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 8

                StyledText {
                    text: qsTr("Username")
                    font.bold: true
                    color: Colours.palette.m3primary
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: Colours.palette.m3surfaceContainerHigh
                    radius: 8
                    border.width: 1
                    border.color: usernameField.activeFocus ? Colours.palette.m3primary : Colours.palette.m3outlineVariant

                    TextInput {
                        id: usernameField
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: Colours.palette.m3onSurface
                        font.pointSize: 14

                        onTextEdited: root.autoGenUsername = false
                        onTextChanged: if (root.config)
                            root.config.username = text
                    }
                }
            }

            // 4. Hostname
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 8

                StyledText {
                    text: qsTr("Device Name (Hostname)")
                    font.bold: true
                    color: Colours.palette.m3primary
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: Colours.palette.m3surfaceContainerHigh
                    radius: 8
                    border.width: 1
                    border.color: hostnameField.activeFocus ? Colours.palette.m3primary : Colours.palette.m3outlineVariant

                    TextInput {
                        id: hostnameField
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: Colours.palette.m3onSurface
                        font.pointSize: 14

                        onTextEdited: root.autoGenHostname = false
                        onTextChanged: if (root.config)
                            root.config.hostname = text
                    }
                }
            }

            // 5. Password
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 8

                StyledText {
                    text: qsTr("Password")
                    font.bold: true
                    color: Colours.palette.m3primary
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: Colours.palette.m3surfaceContainerHigh
                    radius: 8
                    border.width: 1
                    border.color: passwordField.activeFocus ? Colours.palette.m3primary : Colours.palette.m3outlineVariant

                    TextInput {
                        id: passwordField
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: TextInput.Password
                        color: Colours.palette.m3onSurface
                        font.pointSize: 14
                        onTextChanged: if (root.config)
                            root.config.password = text
                    }
                }
            }

            // 6. Confirm Password
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 8

                StyledText {
                    text: qsTr("Confirm Password")
                    font.bold: true
                    color: Colours.palette.m3primary
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: Colours.palette.m3surfaceContainerHigh
                    radius: 8
                    border.width: 1
                    border.color: (confirmField.text !== "" && confirmField.text !== passwordField.text) ? Colours.palette.m3error : (confirmField.activeFocus ? Colours.palette.m3primary : Colours.palette.m3outlineVariant)

                    TextInput {
                        id: confirmField
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: TextInput.Password
                        color: Colours.palette.m3onSurface
                        font.pointSize: 14
                    }
                }
            }
        }

        // Error Messaging
        StyledText {
            text: qsTr("Passwords do not match")
            visible: confirmField.text !== "" && confirmField.text !== passwordField.text
            color: Colours.palette.m3error
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
        }

        // Privacy Disclaimer
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            MaterialIcon {
                text: "shield"
                font.pointSize: 16
                color: Colours.palette.m3error
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 2
            }

            StyledText {
                text: qsTr("Privacy Notice: All data entered here is strictly used for your local installation. No telemetry or personal information is ever transmitted.")
                font.pointSize: 11
                color: Colours.palette.m3error
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                lineHeight: 1.2
            }
        }
    }
}
