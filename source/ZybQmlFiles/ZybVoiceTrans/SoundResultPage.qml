import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
Rectangle {

    id:control
    property alias src: edit1.text
    property alias des: edit2.text


    width: Style.gWidth
    height: Style.gHeight
    color: "#0F0F0F"
    signal returnToParent()

    function play()
    {
        if(edit2.text.length <= 0)
            return;
        QueryWordManager.play(edit2.text,1)
    }

    ZybBackButton
    {
        id:back
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20

        onBackClicked: {
            QueryWordManager.playStop();
            returnToParent();
        }
    }

    ZybVolumeButton
    {
        id:volBtn
        anchors.left: back.left
        anchors.top: back.bottom
        anchors.topMargin: 120

        onClicked:
        {
            volset.visible = true
        }
    }

    VolumnPage
    {
        id:volset;
        anchors.fill: parent
        z:8
        visible: false;
        ZybBackButton{
            id:backButton
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20

            onBackClicked: {
                volset.visible = false
            }
        }
    }


    //    Slider {
    //        Layout.alignment: Qt.AlignCenter
    //        value: 40
    //        tickmarksEnabled: true
    //        stepSize: 20
    //        minimumValue: 0
    //        maximumValue: 100
    //        darkBackground: index == 1
    //    }


    ZybText {
        id: src
        text: qsTr("原文")
        font.pixelSize:Style.titleFontPixel
        color: Style.mainColor
        anchors.left: back.right
        anchors.leftMargin: 30
        anchors.verticalCenter: back.verticalCenter
    }


    PlayButton
    {
        id:sound1
        anchors.left: src.right
        anchors.leftMargin: 18
        anchors.verticalCenter: back.verticalCenter
        onPlay:
        {
            QueryWordManager.play(edit1.text,1)
        }

    }


    ZybText {
        id: des
        //x:534
        x:461
        font.pixelSize:Style.titleFontPixel
        color: Style.mainColor
        text: qsTr("译文")
        anchors.verticalCenter: back.verticalCenter
    }


    PlayButton
    {
        id:sound2
        anchors.left: des.right
        anchors.leftMargin: 18
        anchors.verticalCenter: back.verticalCenter
        enabled: (edit2.text.length > 0)
        onPlay:
        {
            QueryWordManager.play(edit2.text,1)
        }

    }

    Flickable {
        id: flick1
        x:src.x
        y:86
        //width: 380+47; height: 154;
        width: 320; height: 154;
        contentWidth: 320
        contentHeight: edit1.paintedHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick

        TextEdit {
            id: edit1
            anchors.fill: parent
            color: "#FFFFFF"
            font.pixelSize: Style.normalFontPixel
            wrapMode: TextEdit.WrapAnywhere
            readOnly: true
            text: "为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？"

        }
    }


    Flickable {
        id: flick2
        x:des.x
        y:86
        //width: 380+47; height: 154;
        width: 320; height: 154;
        contentWidth: 320
        contentHeight: edit2.paintedHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick

        TextEdit {
            id: edit2
            anchors.fill: parent
            color: "#FFFFFF"
            font.pixelSize: Style.normalFontPixel
            wrapMode: TextEdit.Wrap
            readOnly: true
            text: "In comparison to the desktop-oriented Qt Quick Controls 1, Qt Quick Controls 2 "
                  + "are an order of magnitude simpler, lighter and faster, and are primarily targeted "
                  + "towards embedded and mobile platforms. you are wait"
                  + "hello world,u"

        }
    }
}
