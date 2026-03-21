import QtQuick
import QtQuick.Layouts
import qs.components
import qs.components.controls
import qs.services
import Qt.labs.folderlistmodel
import qs.config

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Appearance.spacing.normal
    visible: folderModel.count > 0

    StyledText {
        text: qsTr("PLUG-INS")
        font.pointSize: Appearance.font.size.small
        color: Colours.palette.m3onSurfaceVariant
        Layout.leftMargin: Appearance.padding.small
    }

    ListView {
        id: pluginCarousel
        Layout.fillWidth: true
        implicitHeight: 180 
        orientation: ListView.Horizontal
        spacing: Appearance.spacing.normal
        snapMode: ListView.SnapToItem
        clip: true

        model: FolderListModel {
            id: folderModel
            // Points to ~/.config/quickshell/caelestia/plug-ins/
            folder: Qt.resolvedUrl("../../../plug-ins") 
            nameFilters: ["*.qml"]
            showDirs: false
        }

        delegate: Item {
            width: pluginCarousel.width
            height: pluginCarousel.height

            Loader {
                anchors.fill: parent
                source: fileUrl 
            }
        }
    }
}