import QtQuick 2.0
import QtQuick.Controls 2.3

import "../ZybControls"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
Pane {
    id:root

    property string mytext: "未识别到语音内容，请重讲"

    anchors.fill: parent
    signal returnToParent()

    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }

    ZybBackButton
    {
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        onBackClicked: {
            returnToParent();
        }
    }



    Text {
        id:content
        text: mytext
        font.family: Style.fontFamily
        font.weight: Font.Normal
        font.pixelSize: Style.tipFontPixel
        color: "#FFFFFF"
        anchors.centerIn: parent
    }

}
