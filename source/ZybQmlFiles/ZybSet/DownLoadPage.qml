import QtQuick 2.0
import "../Style"

Item {
    id:root
    property var value: 0
    CustomProgressBar{
        id:progress
        width: 600
        height: 8
        anchors.top: parent.top
        anchors.left: parent.left
        value: root.value
    }


    Row{
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: progress.bottom
        anchors.topMargin: 36
        height: tip.height
        Text {
            id:tip
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            font.pixelSize: 28
            color: "#FFFFFFFF"
            text: qsTr("下载中…")
        }
        Item{
            height: parent.height
            width: 16
        }
        Text {
            id: progressValue
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            font.pixelSize: 28
            color: "#FFFFFFFF"
            text: (root.value * 100).toFixed(0) + "%";
        }
    }


}
