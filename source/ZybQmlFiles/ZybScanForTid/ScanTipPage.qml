import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"
import "../ZybCamera"
import "../ZybStore"
import "../ZybVirturlKeyBoard"
Pane {
    id:root

    property var pageType: "tippage"
    property string content : "请用笔头扫描\n根据文本内容自动查词"

    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }

    ZybBackButton
    {
        id :back
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        z:10
        onBackClicked:
        {
            UILogic.backToHome()
        }
    }

    AnimatedImage{
        id:tipGif
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: Style.highVersion ? "file:////usr/share/scanquestion_high2.webp" : "file:////usr/share/scanquestion2.webp"
        playing: root.visible
        cache: false
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
