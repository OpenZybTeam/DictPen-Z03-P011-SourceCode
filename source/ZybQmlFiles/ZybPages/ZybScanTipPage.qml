import QtQuick 2.0
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Rectangle {
    id:scanTipRoot
    anchors.fill: parent
    color: Style.mainbgColor
    signal toNext();

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

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
            UILogic.backToHome()
            scanTipRoot.destroy();
        }
    }

    AnimatedImage{
        id:tipGif
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: Style.highVersion ? "file:////usr/share/scanword_high.webp" : "file:////usr/share/scanword.webp"
        playing: scanTipRoot.visible
        cache: false
    }

    Connections {
        target: scanManager;

        onSig_scanDown:{
            scanTipRoot.destroy();
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
