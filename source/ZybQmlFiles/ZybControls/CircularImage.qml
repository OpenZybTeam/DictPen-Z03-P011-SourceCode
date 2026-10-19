import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    property string img_src
    radius: 6

    Image {
        id: _image
        asynchronous:true
        smooth: true
        visible: false
        anchors.fill: parent
        fillMode:  Image.PreserveAspectCrop
        source: img_src
        sourceSize: Qt.size(parent.width, parent.height)
        antialiasing: true
    }
    Rectangle {
        id: _mask
        color: "black"
        anchors.fill: parent
        radius: parent.radius
        visible: false
        antialiasing: true
        smooth: true
    }
    OpacityMask {
        id: mask_image
        anchors.fill: _image
        source: _image
        maskSource: _mask
        visible: true
        antialiasing: true
    }
}
