import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components
import qs.components.controls
import qs.services
import qs.config
import Caelestia

StyledRect {
    id: pluginRoot
    anchors.fill: parent
    radius: Appearance.rounding.normal
    color: Colours.tPalette.m3surfaceContainer

    // This property will be filled by the PluginLoader
    property var props 

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.small

        RowLayout {
            Layout.fillWidth: true
            StyledText {
                text: qsTr("QUICK NOTES")
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3onSurfaceVariant
                Layout.fillWidth: true
            }

            IconButton {
                icon: "delete"
                onClicked: {
                    noteArea.text = "";
                    Config.utilities.notepadText = "";
                    Config.save();
                }
            }
        }

        TextArea {
            id: noteArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            text: Config.utilities.notepadText

            onTextChanged: {
                if (Config.utilities.notepadText !== text) {
                    Config.utilities.notepadText = text;
                    saveTimer.restart();
                }
            }
            
            placeholderText: qsTr("Type a note...")
            color: Colours.palette.m3onSurface
            font.pointSize: Appearance.font.size.normal
            wrapMode: TextEdit.Wrap
            background: null
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                onPressed: (mouse) => {
                    noteArea.forceActiveFocus();
                    mouse.accepted = true;
                }
            }

            Timer {
                id: saveTimer
                interval: 1000
                onTriggered: Config.save()
            }
        }
    }
}

