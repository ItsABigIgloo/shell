import QtQuick
import qs.components.effects
import qs.services
import qs.config
import qs.utils

Item {
    id: root

    property var popouts
    property var barRef: null

    implicitWidth: Appearance.font.size.large * 1.6
    implicitHeight: Appearance.font.size.large * 1.6

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            const name = "overview";
            const p = (root.popouts !== undefined) ? root.popouts : (root.barRef ? root.barRef.popouts : null);
            if (p) {
                if (p.currentName === name && p.hasCurrent) {
                    p.hasCurrent = false;
                } else {
                    p.currentName = name;
                    p.currentCenter = root.barRef.height / 2;
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
}
