pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.components.live
import qs.components.controls
import qs.components.containers
import qs.config

Item {
    id: root
    property var config: ({})
    readonly property bool isReady: config && config.timezone && config.timezone !== ""

    // 1. Expanded Offline Database of Timezones
    readonly property var tzDatabase: [
        // North America
        {
            id: "America/Anchorage",
            name: "Anchorage",
            lat: 61.21,
            lon: -149.90
        },
        {
            id: "America/Vancouver",
            name: "Vancouver",
            lat: 49.28,
            lon: -123.12
        },
        {
            id: "America/Los_Angeles",
            name: "Los Angeles",
            lat: 34.05,
            lon: -118.24
        },
        {
            id: "America/Denver",
            name: "Denver",
            lat: 39.73,
            lon: -104.99
        },
        {
            id: "America/Chicago",
            name: "Chicago",
            lat: 41.87,
            lon: -87.62
        },
        {
            id: "America/New_York",
            name: "New York",
            lat: 40.71,
            lon: -74.00
        },
        {
            id: "America/Halifax",
            name: "Halifax",
            lat: 44.64,
            lon: -63.57
        },
        {
            id: "America/Mexico_City",
            name: "Mexico City",
            lat: 19.43,
            lon: -99.13
        },

        // South America
        {
            id: "America/Bogota",
            name: "Bogotá",
            lat: 4.71,
            lon: -74.07
        },
        {
            id: "America/Lima",
            name: "Lima",
            lat: -12.04,
            lon: -77.02
        },
        {
            id: "America/Santiago",
            name: "Santiago",
            lat: -33.44,
            lon: -70.66
        },
        {
            id: "America/Buenos_Aires",
            name: "Buenos Aires",
            lat: -34.60,
            lon: -58.38
        },
        {
            id: "America/Sao_Paulo",
            name: "São Paulo",
            lat: -23.55,
            lon: -46.63
        },

        // Europe
        {
            id: "Europe/London",
            name: "London",
            lat: 51.50,
            lon: -0.12
        },
        {
            id: "Europe/Paris",
            name: "Paris",
            lat: 48.85,
            lon: 2.35
        },
        {
            id: "Europe/Berlin",
            name: "Berlin",
            lat: 52.52,
            lon: 13.40
        },
        {
            id: "Europe/Rome",
            name: "Rome",
            lat: 41.90,
            lon: 12.49
        },
        {
            id: "Europe/Athens",
            name: "Athens",
            lat: 37.98,
            lon: 23.72
        },
        {
            id: "Europe/Moscow",
            name: "Moscow",
            lat: 55.75,
            lon: 37.61
        },

        // Africa
        {
            id: "Africa/Cairo",
            name: "Cairo",
            lat: 30.04,
            lon: 31.23
        },
        {
            id: "Africa/Lagos",
            name: "Lagos",
            lat: 6.52,
            lon: 3.37
        },
        {
            id: "Africa/Nairobi",
            name: "Nairobi",
            lat: -1.29,
            lon: 36.82
        },
        {
            id: "Africa/Johannesburg",
            name: "Johannesburg",
            lat: -26.20,
            lon: 28.04
        },

        // Asia
        {
            id: "Asia/Riyadh",
            name: "Riyadh",
            lat: 24.71,
            lon: 46.67
        },
        {
            id: "Asia/Dubai",
            name: "Dubai",
            lat: 25.20,
            lon: 55.27
        },
        {
            id: "Asia/Karachi",
            name: "Karachi",
            lat: 24.86,
            lon: 67.00
        },
        {
            id: "Asia/Kolkata",
            name: "Kolkata",
            lat: 22.57,
            lon: 88.36
        },
        {
            id: "Asia/Bangkok",
            name: "Bangkok",
            lat: 13.75,
            lon: 100.50
        },
        {
            id: "Asia/Singapore",
            name: "Singapore",
            lat: 1.35,
            lon: 103.81
        },
        {
            id: "Asia/Shanghai",
            name: "Shanghai",
            lat: 31.23,
            lon: 121.47
        },
        {
            id: "Asia/Seoul",
            name: "Seoul",
            lat: 37.56,
            lon: 126.97
        },
        {
            id: "Asia/Tokyo",
            name: "Tokyo",
            lat: 35.67,
            lon: 139.65
        },

        // Oceania & Pacific
        {
            id: "Australia/Perth",
            name: "Perth",
            lat: -31.95,
            lon: 115.86
        },
        {
            id: "Australia/Sydney",
            name: "Sydney",
            lat: -33.86,
            lon: 151.20
        },
        {
            id: "Pacific/Auckland",
            name: "Auckland",
            lat: -36.85,
            lon: 174.76
        },
        {
            id: "Pacific/Honolulu",
            name: "Honolulu",
            lat: 21.30,
            lon: -157.85
        }
    ]

    property var selectedCity: null

    Component.onCompleted: {
        if (root.config && root.config.timezone) {
            for (let i = 0; i < tzDatabase.length; i++) {
                if (tzDatabase[i].id === root.config.timezone) {
                    selectedCity = tzDatabase[i];
                    break;
                }
            }
        }
    }

    function selectTimezoneByCoords(mouseX, mouseY) {
        let pWidth = worldMap.status === Image.Ready ? worldMap.paintedWidth : worldMap.width;
        let pHeight = worldMap.status === Image.Ready ? worldMap.paintedHeight : worldMap.height;
        let xOffset = (worldMap.width - pWidth) / 2;
        let yOffset = (worldMap.height - pHeight) / 2;
        let realX = mouseX - xOffset;
        let realY = mouseY - yOffset;

        if (realX < 0 || realX > pWidth || realY < 0 || realY > pHeight)
            return;

        let lon = (realX / pWidth) * 360 - 180;
        let lat = 90 - (realY / pHeight) * 180;

        let nearest = null;
        let minDist = Infinity;
        for (let i = 0; i < tzDatabase.length; i++) {
            let city = tzDatabase[i];
            let dx = city.lon - lon;
            let dy = city.lat - lat;
            let dist = dx * dx + dy * dy;
            if (dist < minDist) {
                minDist = dist;
                nearest = city;
            }
        }

        if (nearest) {
            selectedCity = nearest;
            if (root.config)
                root.config.timezone = nearest.id;
        }
    }

    function getPinX(lon, pWidth) {
        return ((lon + 180) / 360) * pWidth;
    }
    function getPinY(lat, pHeight) {
        return ((90 - lat) / 180) * pHeight;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.padding.large

        // 1. Header
        ColumnLayout {
            spacing: 0
            StyledText {
                text: qsTr("Where are you?")
                font.pointSize: Appearance.font.size.large
                font.bold: true
                color: Colours.palette.m3onSurface
            }
            StyledText {
                text: qsTr("Click your location on the map to set the system clock.")
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        // 2. Map Container (Strict layout settings)
        StyledRect {
            // THE FIX: Stop filling the width, and center the box horizontally
            Layout.alignment: Qt.AlignHCenter

            // Mathematically perfect 2:1 ratio container (accommodating 16px margins)
            Layout.preferredWidth: 608
            Layout.preferredHeight: 320

            color: Colours.palette.m3surfaceContainerHigh
            radius: Appearance.rounding.normal
            clip: true

            Image {
                id: worldMap
                anchors.fill: parent
                anchors.margins: 16
                fillMode: Image.PreserveAspectFit
                source: "../../assets/world_map.png"
                smooth: true
                mipmap: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse => selectTimezoneByCoords(mouse.x, mouse.y)
                }

                MaterialIcon {
                    visible: selectedCity !== null
                    text: "location_on"
                    color: Colours.palette.m3primary
                    font.pointSize: 24

                    property real pWidth: worldMap.status === Image.Ready ? worldMap.paintedWidth : worldMap.width
                    property real pHeight: worldMap.status === Image.Ready ? worldMap.paintedHeight : worldMap.height

                    x: selectedCity ? ((worldMap.width - pWidth) / 2) + root.getPinX(selectedCity.lon, pWidth) - width / 2 : 0
                    y: selectedCity ? ((worldMap.height - pHeight) / 2) + root.getPinY(selectedCity.lat, pHeight) - height : 0

                    Behavior on x {
                        Anim {
                            duration: Appearance.anim.durations.normal
                            easing.bezierCurve: Appearance.anim.curves.emphasized
                        }
                    }
                    Behavior on y {
                        Anim {
                            duration: Appearance.anim.durations.normal
                            easing.bezierCurve: Appearance.anim.curves.emphasized
                        }
                    }
                }
            }
        }

        // 3. Selection Feedback Bar
        StyledRect {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Colours.palette.m3surfaceContainerHigh
            radius: Appearance.rounding.small
            border.width: 1
            border.color: selectedCity ? Colours.palette.m3primary : Colours.palette.m3outlineVariant

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Appearance.padding.normal
                anchors.rightMargin: Appearance.padding.normal
                spacing: Appearance.spacing.normal

                MaterialIcon {
                    text: "schedule"
                    font.pointSize: 16
                    color: selectedCity ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: selectedCity ? selectedCity.name + " (" + selectedCity.id + ")" : qsTr("Awaiting selection...")
                    font.pointSize: Appearance.font.size.medium
                    font.bold: selectedCity !== null
                    color: selectedCity ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                }
            }
        }

        // 4. Spacer
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
