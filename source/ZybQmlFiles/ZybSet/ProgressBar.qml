import QtQuick 2.0

Rectangle {
    id:root
//    height: 8
//    width: 600
    radius: height/2
    property var value: 0
    color: "#993C3D42"
    Rectangle{
        anchors.fill: parent
        radius: height/2
        color: "#FF12CFA7"
        width: root.value * (root.width/100)
    }
}
