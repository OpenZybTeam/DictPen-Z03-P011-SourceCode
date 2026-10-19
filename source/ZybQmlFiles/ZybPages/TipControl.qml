import QtQuick 2.0
import "../Style/"

Item {
    id:root
    height: 100
    property alias tips: tip.text
    Text {
        id: tip
//        width: parent.width
        font.family: Style.chFontFamily;
        font.styleName: "Normal"
        font.pixelSize: 24
        color: "#FFFFFF"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        text: qsTr("正在查询......")
    }

}
