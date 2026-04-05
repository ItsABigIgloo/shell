pragma Singleton

import QtQuick
import Quickshell
import qs.components

Singleton {
    id: root

    property string name: "Installer"
    property string icon: "downloading"
    property string description: "Caelestia OS Installer"
    property bool enabled: true
    property bool dangerous: false

    function onClicked(list: var): void {
        create(null, {});
        list?.close();
    }

    function create(parent: Item, props: var): void {
        installerWindowWrapper.createObject(parent ?? dummy, props);
    }

    QtObject {
        id: dummy
    }

    Component {
        id: installerWindowWrapper

        FloatingWindow {
            id: win

            visible: true
            // Set specific dimensions for the installer
            implicitWidth: 1100
            implicitHeight: 700
            minimumSize: Qt.size(900, 700)
            color: "transparent"
            title: qsTr("Caelestia Installer")

            // This is the wrapper we discussed earlier
            InstallerWindow {
                id: installerWindow
                anchors.fill: parent

                // Function to handle closing the window after install or cancel
                function close(): void {
                    win.destroy();
                }
            }
        }
    }
}
