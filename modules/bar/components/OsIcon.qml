import qs.components
import qs.components.effects
import qs.services
import qs.config
import qs.utils
import QtQuick

Item {
    id: root

    property var barRef: null

    implicitWidth: Math.round(Appearance.font.size.large * 1.2)
    implicitHeight: Math.round(Appearance.font.size.large * 1.2)

    MouseArea {
        anchors.fill: parent
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
