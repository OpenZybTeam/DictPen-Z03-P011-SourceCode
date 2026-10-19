import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"

Item {
    id:root
    height: contentText.height
    property var controlData: null

    Image{
        id:headIcon
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.left: parent.left
        source: "qrc:/images/oxford_shcut.png"
    }
    Text {
        id: contentText
        anchors.top: parent.top
        anchors.left: headIcon.right
        anchors.leftMargin: 29
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        font.family: Style.engFontFamily
        font.weight: Font.Medium
        font.pixelSize: 28
        color: "#FFFFFF"
        text: qsTr("text")
    }


    Component.onCompleted: {
        contentText.text =  controlData;
    }
}
