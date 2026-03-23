import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia
import qs.components
import qs.services
import qs.config

Item {
    id: root

    required property var list
    readonly property string math: root.list.search.text.slice(`${Config.launcher.actionPrefix}calc `.length)

    function onClicked() {
        Quickshell.execDetached(["wl-copy", Qalculator.rawResult]);
        root.list.visibilities.launcher = false;
    }

    onMathChanged: {
        if (root.math.length > 0)
            Qalculator.evalAsync(root.math);
    }
    implicitHeight: Config.launcher.sizes.itemHeight
    anchors.left: root.parent ? root.parent.left : undefined
    anchors.right: root.parent ? root.parent.right : undefined

    StateLayer {
        id: mainStateLayer

        onClicked: root.onClicked()
        radius: Appearance.rounding.normal
    }

    RowLayout {
        id: contentLayout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: Appearance.padding.larger
        spacing: Appearance.spacing.normal

        MaterialIcon {
            text: "function"
            font.pointSize: Appearance.font.size.extraLarge
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            id: resultText

            color: {
                if (resultText.text.includes("error: ") || resultText.text.includes("warning: "))
                    return Colours.palette.m3error;

                if (!root.math)
                    return Colours.palette.m3onSurfaceVariant;

                return Colours.palette.m3onSurface;
            }
            text: root.math.length > 0 ? (Qalculator.result || qsTr("Calculating...")) : qsTr("Type an expression to calculate")
            elide: Text.ElideLeft
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        StyledRect {
            id: openButton

            color: Colours.palette.m3tertiary
            radius: Appearance.rounding.normal
            clip: true
            implicitWidth: (innerStateLayer.containsMouse ? calcLabel.implicitWidth + calcLabel.anchors.rightMargin : 0) + calcIcon.implicitWidth + Appearance.padding.normal * 2
            implicitHeight: Math.max(calcLabel.implicitHeight, calcIcon.implicitHeight) + Appearance.padding.small * 2
            Layout.alignment: Qt.AlignVCenter

            StateLayer {
                id: innerStateLayer

                onClicked: {
                    Quickshell.execDetached(["app2unit", "--", pe_unknown, "fish", "-C", `exec qalc -i '${root.math}'`]);
                    root.list.visibilities.launcher = false;
                }
                color: Colours.palette.m3onTertiary
            }

            StyledText {
                id: calcLabel

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: calcIcon.left
                anchors.rightMargin: Appearance.spacing.small
                text: qsTr("Open in calculator")
                color: Colours.palette.m3onTertiary
                font.pointSize: Appearance.font.size.normal
                opacity: innerStateLayer.containsMouse ? 1 : 0

                Behavior on opacity {
                    Anim {}
                }
            }

            MaterialIcon {
                id: calcIcon

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Appearance.padding.normal
                text: "open_in_new"
                color: Colours.palette.m3onTertiary
                font.pointSize: Appearance.font.size.large
            }

            Behavior on implicitWidth {
                Anim {
                    easing.bezierCurve: Appearance.anim.curves.emphasized
                }
            }
        }
    }
}
