import QtQuick 2.0

Item {
    width: splitImage.width
    height: 37
    clip: true
    Image {
        id: splitImage
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/images/spliter.png"
    }
}
