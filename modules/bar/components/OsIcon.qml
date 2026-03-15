import qs.components
import qs.components.effects
import qs.services
import qs.config
import qs.utils
import QtQuick

Item {
    id: root

    implicitWidth: Math.round(Appearance.font.size.large * 1.2)
    implicitHeight: Math.round(Appearance.font.size.large * 1.2)

    MouseArea {
        anchors.fill: parent
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

    Loader {
        anchors.centerIn: parent
        sourceComponent: SysInfo.isDefaultLogo ? caelestiaLogo : distroIcon
    }

    Component {
        id: caelestiaLogo

        Logo {
            implicitWidth: Math.round(Appearance.font.size.large * 1.6)
            implicitHeight: Math.round(Appearance.font.size.large * 1.6)
        }
    }

    Component {
        id: distroIcon

        ColouredIcon {
            source: SysInfo.osLogo
            implicitSize: Math.round(Appearance.font.size.large * 1.2)
            colour: Colours.palette.m3tertiary
        }
    }
}
