import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components
import qs.components.controls
import qs.services
import qs.config


// These point relative to the 'plug-ins' folder
import "../components"
import "../config"

StyledRect {
    id: pluginRoot
    
    // Ensure the card takes up the full carousel space
    anchors.fill: parent
    
    // These should now resolve to your system theme
    radius: Appearance.rounding.normal
    color: Colours.tPalette.m3surfaceContainer

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.small

        StyledText {
            text: qsTr("QUICK NOTES")
            font.pointSize: Appearance.font.size.small
            color: Colours.palette.m3onSurface
        }

        TextArea {
            id: noteArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            placeholderText: qsTr("Type a note...")
            color: Colours.palette.m3onSurface
            font.pointSize: Appearance.font.size.normal
            wrapMode: TextEdit.Wrap
            background: null
            
            // Fix interactivity: ensure clicks focus the text area
            MouseArea {
                anchors.fill: parent
                onClicked: noteArea.forceActiveFocus()
            }
        }
    }
}
