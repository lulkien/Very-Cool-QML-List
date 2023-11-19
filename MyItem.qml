import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root

    // size
    property real itemSize: 300

    // data
    property alias color: rec.color
    property int duration: 335

    // rotation
    property real originX: 0
    property real angle: 0

    width: itemSize
    height: itemSize

    transform: Rotation {
        axis.x: 0
        axis.y: 1
        axis.z: 0
        origin.x: root.originX
        origin.y: height / 2
        angle: root.angle
    }

    QtObject {
        id: self
        property bool isCentered: false
    }

    Rectangle {
        id: rec
        anchors.fill: parent
        anchors.margins: self.isCentered ? 20 : 0
        color: "transparent"
        radius: 4
        visible: !self.isCentered
    }

    ShaderEffect {
        visible: self.isCentered
        anchors.fill: root
        property variant src: rec

        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }
        "

        fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform vec2 textureSize; // New uniform for texture size

            void main() {
                vec2 texelSize = 1.0 / textureSize;

                // Define a simple 3x3 box blur kernel
                float kernel[3][3] = {
                    {1.0, 1.0, 1.0},
                    {1.0, 1.0, 1.0},
                    {1.0, 1.0, 1.0}
                };

                vec3 color = vec3(0.0);

                // Apply the blur kernel
                for (int i = -1; i <= 1; ++i)
                {
                    for (int j = -1; j <= 1; ++j)
                    {
                        vec2 offset = vec2(i, j) * texelSize;
                        color += texture2D(src, coord + offset).rgb * kernel[i + 1][j + 1];
                    }
                }

                // Normalize the result
                color /= 9.0;

                gl_FragColor = vec4(color, 1.0) * qt_Opacity;
            }
        "
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
        NumberAnimation { target: root;     property: "z";          to: animation_change_state.targetZ;         duration: root.duration;        easing.type: Easing.OutQuad  }
        NumberAnimation { target: root;     property: "opacity";    to: animation_change_state.targetAlpha;     duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "originX";    to: animation_change_state.targetOrigin;    duration: root.duration;        easing.type: Easing.OutQuad  }
        NumberAnimation { target: root;     property: "angle";      to: animation_change_state.targetAngle;     duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "itemSize";   to: 300;                                    duration: root.duration;        easing.type: Easing.OutQuad  }
    }

    ParallelAnimation {
        id: animation_move_to_center
        property real targetX: 0
        property real targetZ: 0
        property real targetAlpha: 1
        property real targetOrigin: 0
        property real targetAngle: 0
        alwaysRunToEnd: true
        NumberAnimation { target: root;     property: "x";          to: animation_move_to_center.targetX;       duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "z";          to: animation_move_to_center.targetZ;       duration: root.duration;        easing.type: Easing.OutQuad  }
        NumberAnimation { target: root;     property: "opacity";    to: animation_move_to_center.targetAlpha;   duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "originX";    to: animation_move_to_center.targetOrigin;  duration: root.duration;        easing.type: Easing.OutQuad  }
        NumberAnimation { target: root;     property: "angle";      to: animation_move_to_center.targetAngle;   duration: root.duration;        easing.type: Easing.OutQuart }
        NumberAnimation { target: root;     property: "itemSize";   to: 720;                                    duration: root.duration;        easing.type: Easing.OutQuad  }
    }

    SequentialAnimation {
        id: animation_move_to_last
        property real targetX: 0
        property real targetZ: 0
        property real targetAlpha: 1
        property real targetOrigin: 0
        property real targetAngle: 0
        alwaysRunToEnd: true

        NumberAnimation { target: root; property: "x"; to: root.x - 500; duration: root.duration / 2; easing.type: Easing.InQuint }
        ParallelAnimation {
            NumberAnimation { target: root;     property: "originX";    to: animation_move_to_last.targetOrigin;    duration: 0; }
            NumberAnimation { target: root;     property: "angle";      to: animation_move_to_last.targetAngle;     duration: 0; }
        }
        NumberAnimation { target: root; property: "x"; from: animation_move_to_last.targetX + 500; to: animation_move_to_last.targetX; duration: root.duration / 2; easing.type: Easing.OutQuint }
    }

    SequentialAnimation {
        id: animation_move_to_first
        property real targetX: 0
        property real targetZ: 0
        property real targetAlpha: 1
        property real targetOrigin: 0
        property real targetAngle: 0
        alwaysRunToEnd: true

        NumberAnimation { target: root; property: "x"; to: root.x + 500; duration: root.duration / 2; easing.type: Easing.InQuint }
        ParallelAnimation {
            NumberAnimation { target: root;     property: "originX";    to: animation_move_to_first.targetOrigin;    duration: 0 }
            NumberAnimation { target: root;     property: "angle";      to: animation_move_to_first.targetAngle;     duration: 0 }
        }
        NumberAnimation { target: root; property: "x"; from: animation_move_to_first.targetX - 500; to: animation_move_to_first.targetX; duration: root.duration / 2; easing.type: Easing.OutQuint }
    }

    function animateToNewState(newX, newZ, newAlpha, newOrigin, newAngle) {
        self.isCentered = false
        animation_change_state.targetX = newX
        animation_change_state.targetZ = newZ
        animation_change_state.targetAlpha = newAlpha
        animation_change_state.targetOrigin = newOrigin
        animation_change_state.targetAngle = newAngle
        animation_change_state.start()
    }

    function moveItemToCenter(newX, newZ, newAlpha, newOrigin, newAngle) {
        self.isCentered = true
        animation_move_to_center.targetX = newX
        animation_move_to_center.targetZ = newZ
        animation_move_to_center.targetAlpha = newAlpha
        animation_move_to_center.targetOrigin = 720 / 2
        animation_move_to_center.targetAngle = newAngle
        animation_move_to_center.start()
    }

    function moveItemToLast(newX, newZ, newAlpha, newOrigin, newAngle) {
        self.isCentered = false
        animation_move_to_last.targetX = newX
        animation_move_to_last.targetZ = newZ
        animation_move_to_last.targetAlpha = newAlpha
        animation_move_to_last.targetOrigin = newOrigin
        animation_move_to_last.targetAngle = newAngle
        animation_move_to_last.start()
    }

    function moveItemToFirst(newX, newZ, newAlpha, newOrigin, newAngle) {
        self.isCentered = false
        animation_move_to_first.targetX = newX
        animation_move_to_first.targetZ = newZ
        animation_move_to_first.targetAlpha = newAlpha
        animation_move_to_first.targetOrigin = newOrigin
        animation_move_to_first.targetAngle = newAngle
        animation_move_to_first.start()
    }

    function markCentered(centered) {
        self.isCentered = centered
    }
}
