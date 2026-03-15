pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config // Ensure this is imported for Config access
import Caelestia // Required for Toaster access

Singleton {
    id: root

    property alias enabled: props.enabled
    readonly property alias enabledSince: props.enabledSince

    onEnabledChanged: {
        if (enabled) {
            props.enabledSince = new Date();
            // Trigger notification for Enabled state
            Toaster.toast(qsTr("Idle inhibitor enabled"), qsTr("Locking and Sleep disabled."), "coffee");
        } else {
            // Trigger notification for Disabled state
            Toaster.toast(qsTr("Idle inhibitor disabled"), qsTr("The computer will now lock automatically"), "coffee");
        }
    }

    PersistentProperties {
        id: props

        property bool enabled
        property date enabledSince

        reloadableId: "idleInhibitor"
    }

    IdleInhibitor {
        enabled: props.enabled
        window: PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"
            mask: Region {}
        }
    }

    IpcHandler {
        target: "idleInhibitor"

        function isEnabled(): bool {
            return props.enabled;
        }

        function toggle(): void {
            props.enabled = !props.enabled;
        }

        function enable(): void {
            props.enabled = true;
        }

        function disable(): void {
            props.enabled = false;
        }
    }
}
