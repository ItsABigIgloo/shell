import QtQuick
import QtQuick.Layouts
import qs.components
import qs.components.controls
import qs.services
import Qt.labs.folderlistmodel
import qs.config
import Caelestia

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Appearance.spacing.normal
    visible: folderModel.count > 0

    RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        spacing: Appearance.spacing.normal * 1.5
        visible: folderModel.count > 1

        Repeater {
            model: folderModel.count

            Rectangle {
                id: dot
                width: 8
                height: 8
                radius: 4
                color: index === pluginCarousel.currentIndex 
                       ? Colours.palette.m3primary 
                       : Colours.palette.m3onSurfaceVariant
                opacity: index === pluginCarousel.currentIndex ? 1.0 : 0.4

                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on opacity { OpacityAnimator { duration: 200 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: pluginCarousel.currentIndex = index 
                }
            }
        }
    }

    ListView {
        id: pluginCarousel
        Layout.fillWidth: true
        interactive: folderModel.count > 1 
        implicitHeight: 180 
        orientation: ListView.Horizontal

        onCurrentIndexChanged: {
            if (Config.utilities.pluginIndex !== currentIndex) {
                Config.utilities.pluginIndex = currentIndex
                Config.save()
            }
        }
    
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 0
        cacheBuffer: 2
        clip: true

        model: FolderListModel {
            id: folderModel
            folder: Qt.resolvedUrl("../../../widgets")
            nameFilters: ["*.qml"]
            showDirs: false
            sortField: FolderListModel.Name
            
            onStatusChanged: {
                if (status === FolderListModel.Ready) {
                    pluginCarousel.currentIndex = Config.utilities.pluginIndex
                }
            }
        }

        delegate: Item {
            width: pluginCarousel.width
            height: pluginCarousel.height

            Loader {
                anchors.fill: parent
                source: fileUrl 
            
                onLoaded: {
                    if (item && item.hasOwnProperty("props")) {
                        item.props = root.props;
                    }
                }
            }
        }
    }
}