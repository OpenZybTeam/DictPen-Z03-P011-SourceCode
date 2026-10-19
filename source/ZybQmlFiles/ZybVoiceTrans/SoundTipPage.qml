import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
Pane {
    id:root

    anchors.fill: parent
    signal returnToParent()
    signal imageClicked();

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
            returnToParent()
        }
    }


    Image{
        id: tip
        source: "qrc:/images/soundtip212x201.png"
        x:Style.pen_x
        y:19
        anchors.verticalCenter: parent.verticalCenter

//        MouseArea
//        {
//            anchors.fill: parent
//            onClicked:
//            {
//                if(Qt.platform.os === "windows")
//                    imageClicked();
//                    //voiceTrans.state = "SoundListen"
//            }
//        }
    }

    Text {
        id:content
        text: "请长按语音键输入语音"
        font.family: Style.fontFamily
        font.weight: Font.Normal
        font.pixelSize : Style.tipFontPixel
        color: "#FFFFFF"
        anchors.left: tip.right
        anchors.verticalCenter: parent.verticalCenter
    }

}
