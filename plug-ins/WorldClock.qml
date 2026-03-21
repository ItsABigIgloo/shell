import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components
import qs.components.controls
import qs.services
import qs.config
import Caelestia

StyledRect {
    id: clockRoot
    anchors.fill: parent
    radius: Appearance.rounding.normal
    color: Colours.tPalette.m3surfaceContainer

    Timer {
        id: wallTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            localTime.text = Qt.formatTime(new Date(), "hh:mm:ss ap")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.small

        StyledText {
            text: qsTr("WORLD CLOCK")
            font.pointSize: Appearance.font.size.small
            color: Colours.palette.m3onSurfaceVariant
        }

        StyledText {
            id: localTime
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatTime(new Date(), "hh:mm:ss ap")
            font.pointSize: Appearance.font.size.extraLarge
            font.bold: true
            color: Colours.palette.m3onSurface
        }

        Column {
            Layout.fillWidth: true
            spacing: 4

            TimeZoneRow { 
                label: "UTC/GMT"
                timeOffset: 0 
            }
            
            TimeZoneRow { 
                label: "New York"
                timeOffset: -4 
            }
            
            TimeZoneRow { 
                label: "Tokyo"
                timeOffset: 9 
            }
        }
    }

    component TimeZoneRow : RowLayout {
        property string label: ""
        property int timeOffset: 0
        
        Layout.fillWidth: true
        
        StyledText {
            text: label
            Layout.fillWidth: true
            font.pointSize: Appearance.font.size.small
            color: Colours.palette.m3onSurfaceVariant
        }
        
        StyledText {
            text: {
                var d = new Date();
                var utc = d.getTime() + (d.getTimezoneOffset() * 60000);
                var nd = new Date(utc + (3600000 * timeOffset));
                return Qt.formatTime(nd, "hh:mm ap");
            }
            font.pointSize: Appearance.font.size.small
            color: Colours.palette.m3onSurface
        }
    }
}