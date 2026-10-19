import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

RoundButton{
    id:control
    height: 56
    width: 180
    radius:6

    contentItem: Item{
        anchors.fill: control
        Text {
            id: contentText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 24
            color: "#999999"
            text: qsTr("使用帮助")
        }


    }
    background: Rectangle{
        color: "transparent"
        radius: 6
        Image {
            id: noreportback
            anchors.fill: parent
            source: "qrc:/images/error_rect.png"
        }
    }
}

