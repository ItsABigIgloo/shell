import qs.components.effects
import qs.services
import qs.config
import qs.utils
import QtQuick

Item {
    id: root
    
    property var barRef: null 

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true 
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (barRef) {
                if (barRef.hasCurrent && barRef.currentName === "overview") {
                    barRef.hasCurrent = false;
                } else {
                    barRef.currentName = "overview";
                    barRef.currentCenter = barRef.screen.height / 2;
                    barRef.hasCurrent = true;
                }
            }
        }
    }

    Loader {
        anchors.centerIn: parent
        source: SysInfo.osLogo 
        implicitSize: Appearance.font.size.large * 1.6
        colour: Colours.palette.m3tertiary
    }

    implicitWidth: Appearance.font.size.large * 1.6
    implicitHeight: Appearance.font.size.large * 1.6
}