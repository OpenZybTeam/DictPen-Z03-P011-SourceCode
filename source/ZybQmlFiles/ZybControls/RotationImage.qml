import QtQuick 2.0

Image {
    id: img

    property alias running: animation.running
    property alias duration: animation.duration


    RotationAnimation on rotation {
        id : animation
        from: 0
        to: 360
        duration: 2000
        loops: Animation.Infinite
    }
}
