import QtQuick
import qs.components
import qs.components.effects
import qs.services
import qs.config
import qs.utils

Item {
    id: root
    
    property var barRef: null 

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true 
        cursorShape: Qt.PointingHandCursor

        onClicked: (mouse) => {
            const name = "overview"
            let p = typeof popouts !== "undefined" ? popouts : (barRef ? barRef.popouts : null);
            
            if (p) {
                if (p.currentName === name && p.hasCurrent) {
                    p.hasCurrent = false;
                } else {
                    p.currentName = name;
                    p.currentCenter = barRef.height / 2;
                    p.hasCurrent = true;
                }
            } else {
                console.error("OsIcon: Could not find popouts reference!");
            }
            mouse.accepted = false; 
        }
    }

    ColouredIcon {
        anchors.centerIn: parent
        source: SysInfo.osLogo 
        implicitSize: Appearance.font.size.large * 1.6
        colour: Colours.palette.m3tertiary
    }

    implicitWidth: Appearance.font.size.large * 1.6
    implicitHeight: Appearance.font.size.large * 1.6
}