import QtQuick 2.0
import QtQuick.Controls 2.0
//题干页面

Page {

    property alias content: text.text
    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }

    Text
    {
        id:text
        //height: 120
        width: parent.width
        wrapMode:Text.WrapAnywhere
        font.pixelSize : 28
        font.family: "SourceHanSansSC"
        font.weight: Font.Normal
        color: "#FFFFFF"
        text: "is a test 11111111111111122222222333"
        +"4444444444444444444444444444444"
        +"5555555555555555555555555555555"
    }

}
