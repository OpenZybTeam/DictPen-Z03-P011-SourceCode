import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybStore"
import "../ZybSet"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Rectangle {
    id:root
    color: Style.mainbgColor
    property var pageState: "scanword"
    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    Flickable{
        id:flickable
        anchors.fill: parent
        contentHeight: tipGif.visible ? parent.height : 382
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true
        ZybBackButton
        {
            id :back
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            z:10
            onBackClicked:
            {
                root.destroy();
            }
        }
        Text{
            id:wordText
            anchors.left: back.right
            anchors.leftMargin: 10
            anchors.verticalCenter: back.verticalCenter
            font.family: Style.chFontFamily
            font.pixelSize: 28
            color: "#FFFFFF"
            font.bold: true
            text: qsTr("语音通话")
        }
        AnimatedImage{
            id:tipGif
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            //source: "file:////usr/share/scanword.webp"
            playing: visible
            cache: false

            onCurrentFrameChanged: {
                if(currentFrame === (frameCount - 1)){
                    if(pageState === "question"){
                        pageState = "question2"
                        tipGif.source = Style.highVersion ? "file:////usr/share/cameraSearch_high.webp" : "file:////usr/share/cameraSearch.webp"
                    }
                    else if(pageState === "question2"){
                        pageState = "question"
                        tipGif.source = Style.highVersion ? "file:////usr/share/scanquestion_high.webp" : "file:////usr/share/scanquestion.webp"
                    }
                }
            }

        }

        Item{
            id:tipItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: back.bottom
            height: 382
            Text{
                id:page2Title
                color: "#FFFFFFFF"
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 48
                font.pixelSize: 28
                font.styleName: "Medium"
                font.family: Style.chFontFamily
                text: qsTr("学习笔收不到APP的语音呼叫怎么办？")
            }

            Image {
                source: "qrc:/images/set_help_triangle.png"
                anchors.right: page2Title.left
                anchors.rightMargin: 10
                anchors.verticalCenter: page2Title.verticalCenter
            }

            Text{
                id:page2Text1
                color: "#FFFFFFFF"
                anchors.top: page2Title.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 48
                font.pixelSize: 24
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                text: qsTr("1.请在作业帮智能APP — 设备管理 — 设备详情页 — 打开实时在线开关")
            }

            Text{
                id:page2Text2
                color: "#999999"
                anchors.top: page2Text1.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 48
                font.pixelSize: 24
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                text: qsTr("（开启后，学习笔可以随时接收到APP的语音呼叫，但是会增加耗电量）")
            }

            Text{
                id:page2Text3
                color: "#FFFFFFFF"
                anchors.top: page2Text2.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 48
                font.pixelSize: 24
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                text: qsTr("2.开启后将学习笔灭屏再亮屏设置才可生效")
            }

            Text{
                id:page2Title2
                color: "#FFFFFFFF"
                anchors.top: page2Text3.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 48
                font.pixelSize: 28
                font.styleName: "Medium"
                font.family: Style.chFontFamily
                text: qsTr("APP收不到设备的语音呼叫怎么办？")
            }

            Image {
                source: "qrc:/images/set_help_triangle.png"
                anchors.right: page2Title2.left
                anchors.rightMargin: 10
                anchors.verticalCenter: page2Title2.verticalCenter
            }

            Text{
                id:page2Text4
                color: "#FFFFFFFF"
                anchors.top: page2Title2.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 48
                font.pixelSize: 24
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                text: qsTr("1.请在作业帮智能APP — 设备管理 — 设备详情页 — 点击帮助查看配置")
            }
        }
    }








    Component.onCompleted: {
        console.log("tipPage open")
        if(pageState === "scanword"){
            wordText.visible = false;
            tipItem.visible = false;
            tipGif.visible = true;
            tipGif.source = Style.highVersion ? "file:////usr/share/scanword_high.webp" : "file:////usr/share/scanword.webp"
        }

        if(pageState === "scanquestion"){
            wordText.visible = false;
            tipItem.visible = false;
            tipGif.visible = true;
            tipGif.source = Style.highVersion ? "file:////usr/share/scanquestion_high.webp" : "file:////usr/share/scanquestion.webp"
        }

        if(pageState === "cameraquestion"){
            wordText.visible = false;
            tipItem.visible = false;
            tipGif.visible = true;
            tipGif.source = Style.highVersion ? "file:////usr/share/cameraSearch_high.webp" : "file:////usr/share/cameraSearch.webp"
        }

        if(pageState === "question"){
            wordText.visible = false;
            tipItem.visible = false;
            tipGif.visible = true;
            tipGif.source = Style.highVersion ? "file:////usr/share/scanquestion_high.webp" : "file:////usr/share/scanquestion.webp"
        }

        if(pageState === "phone"){
            wordText.visible = true;
            tipGif.visible = false;
            tipItem.visible = true;
        }
    }

    Connections {
        target: engineSocket;
        onSig_offScreenKey:{
            tipGif.playing = false;
            tipGif.currentFrame = 0;
        }
        onSig_normalKey:{
            tipGif.playing = true;
        }
    }
}
