import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root

    width: 1280
    height: 720

    QtObject {
        id: self
        property int currentIndex: 0
        property var layoutData: [
            { idx: (currentIndex + list_view.count - 4) % list_view.count,   x: 20,    z: 0,   alpha: 1,   originX: 0,     angle: 46.1,    centered: false },
            { idx: (currentIndex + list_view.count - 3) % list_view.count,   x: 70,    z: 1,   alpha: 1,   originX: 0,     angle: 46.1,    centered: false },
            { idx: (currentIndex + list_view.count - 2) % list_view.count,   x: 120,   z: 2,   alpha: 1,   originX: 0,     angle: 46.1,    centered: false },
            { idx: (currentIndex + list_view.count - 1) % list_view.count,   x: 170,   z: 3,   alpha: 1,   originX: 0,     angle: 46.1,    centered: false },
            { idx: currentIndex,                                             x: 280,   z: -1,  alpha: 1,   originX: 360,   angle: 0,       centered: true  },
            { idx: (currentIndex + 1) % list_view.count,                     x: 810,   z: 3,   alpha: 1,   originX: 300,   angle: -46.1,   centered: false },
            { idx: (currentIndex + 2) % list_view.count,                     x: 860,   z: 2,   alpha: 1,   originX: 300,   angle: -46.1,   centered: false },
            { idx: (currentIndex + 3) % list_view.count,                     x: 910,   z: 1,   alpha: 1,   originX: 300,   angle: -46.1,   centered: false },
            { idx: (currentIndex + 4) % list_view.count,                     x: 960,   z: 0,   alpha: 1,   originX: 300,   angle: -46.1,   centered: false },
        ]

        function initLayout() {
            layoutData.forEach(function(item) {
                list_view.itemAt(item.idx).opacity = item.alpha
                list_view.itemAt(item.idx).x = item.x
                list_view.itemAt(item.idx).z = item.z
                list_view.itemAt(item.idx).originX = item.originX
                list_view.itemAt(item.idx).angle = item.angle
                list_view.itemAt(item.idx).itemSize = item.centered ? 720 : 300
                list_view.itemAt(item.idx).markCentered(item.centered)
            })
        }

        function increaseCurrentIndex() {
            currentIndex = (currentIndex + 1) % list_view.count
            layoutData.forEach(function(item, index) {
                if (item.centered) {
                    list_view.itemAt(item.idx).moveItemToCenter(item.x, item.z, item.alpha, item.originX, item.angle)
                    return
                }

                if (index === list_view.count - 1) {
                    list_view.itemAt(item.idx).moveItemToLast(item.x, item.z, item.alpha, item.originX, item.angle)
                    return
                }

                list_view.itemAt(item.idx).animateToNewState(item.x, item.z, item.alpha, item.originX, item.angle)
            })
        }

        function decreaseCurrentIndex() {
            currentIndex = (currentIndex + list_view.count - 1) % list_view.count
            layoutData.forEach(function(item, index) {
                if (item.centered) {
                    list_view.itemAt(item.idx).moveItemToCenter(item.x, item.z, item.alpha, item.originX, item.angle)
                    return
                }

                if (index === 0) {
                    list_view.itemAt(item.idx).moveItemToFirst(item.x, item.z, item.alpha, item.originX, item.angle)
                    return
                }

                list_view.itemAt(item.idx).animateToNewState(item.x, item.z, item.alpha, item.originX, item.angle)
            })
        }
    }

    ListModel {
        id: list_data
        ListElement { fillColor: "#FF7E7E" }
        ListElement { fillColor: "#F87EFF" }
        ListElement { fillColor: "#847EFF" }
        ListElement { fillColor: "#7ED2FF" }
        ListElement { fillColor: "#7EFFBE" }
        ListElement { fillColor: "#90FF7E" }
        ListElement { fillColor: "#C3FF7E" }
        ListElement { fillColor: "#FFF77E" }
        ListElement { fillColor: "#FFB47E" }
    }

    Repeater {
        id: list_view
        anchors.fill: parent
        model: list_data
        delegate: MyItem {
            id: delegate_item
            x: 0
            y: (root.height - height) / 2
            z: 0
            color: fillColor
            antialiasing: true
        }
    }

    Component.onCompleted: {
        self.initLayout()
    }

    function increase() {
        self.increaseCurrentIndex()
    }

    function decrease() {
        self.decreaseCurrentIndex()
    }
}
