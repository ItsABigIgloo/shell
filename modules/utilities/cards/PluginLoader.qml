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
        
        

        RowLayout {
            spacing: Appearance.spacing.small
            visible: folderModel.count > 1

            IconButton {
                icon: "arrow_back_ios"
                font.pointSize: Appearance.font.size.normal
                onClicked: {
                    if(pluginCarousel.currentIndex > 0) {
                        pluginCarousel.currentIndex--
                    }
                }
                enabled: pluginCarousel.currentIndex > 0
            }

            Item { Layout.fillWidth: true }
            StyledText {
                text: qsTr("Widgets")
                font.pointSize: Appearance.font.size.normal
                color: Colours.palette.m3onSurfaceVariant
            }

            Item { Layout.fillWidth: true }

            IconButton {
                icon: "arrow_forward_ios"
                font.pointSize: Appearance.font.size.normal
                onClicked: {
                    if(pluginCarousel.currentIndex < folderModel.count - 1) {
                        pluginCarousel.currentIndex++
                    }
                }
                enabled: pluginCarousel.currentIndex < folderModel.count - 1
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
        cacheBuffer: 2
        clip: true

        Behavior on contentX {
            Anim {
                duration: Appearance.anim.durations.small
            }
        }

        model: FolderListModel {
            id: folderModel
            folder: Qt.resolvedUrl("../../../plug-ins")
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