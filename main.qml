import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: root
    width: 1280
    maximumWidth: 1280
    minimumWidth: 1280
    height: 720
    maximumHeight: 720
    minimumHeight: 720
    visible: true
    title: qsTr("Hello World")


    MyList {
        id: list
        anchors.fill: parent
    }

    property bool buttonDisabled: false
    Row {
        spacing: 5
        Rectangle {
            width: 100
            height: 100
            border.color: "black"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                text: "<"
            }
            MouseArea {
                enabled: !root.buttonDisabled
                anchors.fill: parent
                onClicked: {
                    list.decrease()
                    root.buttonDisabled = true
                    disable_timer.start()
                }
            }
        }
        Rectangle {
            width: 100
            height: 100
            border.color: "black"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                text: ">"
            }
            MouseArea {
                enabled: !root.buttonDisabled
                anchors.fill: parent
                onClicked: {
                    list.increase()
                    root.buttonDisabled = true
                    disable_timer.start()
                }
            }
        }
    }

    Timer {
        id: disable_timer
        interval: 340
        onTriggered: {
            root.buttonDisabled = false
        }
    }
}
