import QtQuick 2.15

Item {
    id: root
    // data
    property alias color: rec.color
    property int duration: 335

    // rotation
    property real originX: 0
    property real angle: 0

    width: 300
    height: 300

    transform: Rotation {
        axis.x: 0
        axis.y: 1
        axis.z: 0
        origin.x: root.originX
        origin.y: height / 2
        angle: root.angle
    }

    Rectangle {
        id: rec
        anchors.fill: parent
        color: "transparent"
        radius: 4
        border.color: "black"
    }


    ParallelAnimation {
        id: animation_change_state
        property real targetX: 0
        property real targetZ: 0
        property real targetAlpha: 1
        property real targetOrigin: 0
        property real targetAngle: 0
        alwaysRunToEnd: true
        NumberAnimation { target: root;     property: "x";          to: animation_change_state.targetX;         duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "z";          to: animation_change_state.targetZ;         duration: root.duration;        easing.type: Easing.OutQuad }
        NumberAnimation { target: root;     property: "opacity";    to: animation_change_state.targetAlpha;     duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "originX";    to: animation_change_state.targetOrigin;    duration: root.duration;        easing.type: Easing.OutQuad }
        NumberAnimation { target: root;     property: "angle";      to: animation_change_state.targetAngle;     duration: root.duration;        easing.type: Easing.OutQuart }
    }

    SequentialAnimation {
        id: animation_move_to_last
        property real targetX: 0
        property real targetZ: 0
        property real targetAlpha: 1
        property real targetOrigin: 0
        property real targetAngle: 0
        alwaysRunToEnd: true

        NumberAnimation {
            target: root
            property: "x"
            to: root.x - 500
            duration: root.duration / 2
            easing.type: Easing.InQuint
        }

        ParallelAnimation {
            NumberAnimation { target: root;     property: "originX";    to: animation_move_to_last.targetOrigin;    duration: 0; }
            NumberAnimation { target: root;     property: "angle";      to: animation_move_to_last.targetAngle;     duration: 0; }
        }

        NumberAnimation {
            target: root
            property: "x"
            from: animation_move_to_last.targetX + 500
            to: animation_move_to_last.targetX
            duration: root.duration / 2
            easing.type: Easing.OutQuint
        }
    }

    SequentialAnimation {
        id: animation_move_to_first
        property real targetX: 0
        property real targetZ: 0
        property real targetAlpha: 1
        property real targetOrigin: 0
        property real targetAngle: 0
        alwaysRunToEnd: true

        NumberAnimation {
            target: root
            property: "x"
            to: root.x + 500
            duration: root.duration / 2
            easing.type: Easing.InQuint
        }

        ParallelAnimation {
            NumberAnimation { target: root;     property: "originX";    to: animation_move_to_first.targetOrigin;    duration: 0 }
            NumberAnimation { target: root;     property: "angle";      to: animation_move_to_first.targetAngle;     duration: 0 }
        }

        NumberAnimation {
            target: root
            property: "x"
            from: animation_move_to_first.targetX - 500
            to: animation_move_to_first.targetX
            duration: root.duration / 2
            easing.type: Easing.OutQuint
        }
    }

    function animateToNewState(newX, newZ, newAlpha, newOrigin, newAngle) {
        animation_change_state.targetX = newX
        animation_change_state.targetZ = newZ
        animation_change_state.targetAlpha = newAlpha
        animation_change_state.targetOrigin = newOrigin
        animation_change_state.targetAngle = newAngle
        animation_change_state.start()
    }

    function moveItemToLast(newX, newZ, newAlpha, newOrigin, newAngle) {
        animation_move_to_last.targetX = newX
        animation_move_to_last.targetZ = newZ
        animation_move_to_last.targetAlpha = newAlpha
        animation_move_to_last.targetOrigin = newOrigin
        animation_move_to_last.targetAngle = newAngle
        animation_move_to_last.start()
    }

    function moveItemToFirst(newX, newZ, newAlpha, newOrigin, newAngle) {
        animation_move_to_first.targetX = newX
        animation_move_to_first.targetZ = newZ
        animation_move_to_first.targetAlpha = newAlpha
        animation_move_to_first.targetOrigin = newOrigin
        animation_move_to_first.targetAngle = newAngle
        animation_move_to_first.start()
    }
}
