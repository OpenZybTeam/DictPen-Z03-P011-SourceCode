
import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
Pane {
    id:root

    anchors.fill: parent
    signal returnToParent()
    signal endClicked()

    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                endClicked();
            }
        }
    }

    ZybBackButton
    {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20

        onBackClicked: {
            returnToParent();
        }
    }

    Text {
        id:content
        text: "倾听中..."
        font.family: Style.fontFamily
        font.weight: Font.Bold
        font.pixelSize: Style.titleFontPixel
        color: "#FFFFFF"
        anchors.centerIn: parent
    }


    Item  {
        width: 160
        height: 48
        anchors.horizontalCenter: parent.horizontalCenter
        y:158
        SpriteSequence {
            id: listen
            anchors.fill: parent
            interpolate: true
            goalSprite: ""

            Sprite {
                name: "1"
                source: "qrc:/images/listening.png"
                frameWidth: 160
                frameHeight: 48
                frameCount: 1
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "2" : 1 }
            }

            Sprite {
                name: "2"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "3" : 1 }
            }

            Sprite {
                name: "3"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*2
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "4" : 1 }
            }

            Sprite {
                name: "4"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*3
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "5" : 1 }
            }

            Sprite {
                name: "5"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*4
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "6" : 1 }
            }

            Sprite {
                name: "6"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*5
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "7" : 1 }
            }

            Sprite {
                name: "7"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 0
                frameY: 48
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "8" : 1 }
            }

            Sprite {
                name: "8"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160
                frameY: 48
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "9" : 1 }
            }

            Sprite {
                name: "9"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*2
                frameY: 48
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "10" : 1 }
            }

            Sprite {
                name: "10"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*3
                frameY: 48
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "11" : 1 }
            }

            Sprite {
                name: "11"
                source: "qrc:/images/listening.png"
                frameCount: 1
                frameX: 160*4
                frameY: 48
                frameWidth: 160
                frameHeight: 48
                frameDuration: 90
                //frameDurationVariation: 50
                to: { "1" : 1 }
            }
        }

    }

}
