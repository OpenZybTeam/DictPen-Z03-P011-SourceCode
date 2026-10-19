import QtQuick 2.0
import "../Style"
Rectangle {
    id:root
    width: 120
    height: 120
    color: "#CC3c3d42"
    radius: 6

    RotationImage
    {
        id:cameraPageBusyImg
        source: "qrc:/images/setLoading46x44.png"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -15
        running: root.visible
    }

    ZybText
    {
        id:loadText
        text: qsTr("加载中")
        font.pixelSize: 24
        color: "#FFFFFF"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
    }

}
