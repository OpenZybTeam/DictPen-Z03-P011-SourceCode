import QtQuick 2.0

Item  {
    width: 800
    height: 48
    anchors.horizontalCenter: parent.horizontalCenter
    property alias running: listen.running
    signal listenStop()
    signal listenStart()

    SpriteSequence {
        id: listen
//        anchors.fill: parent
        width: 160
        height: 48
        anchors.horizontalCenter: parent.horizontalCenter
        interpolate: true
//        running: false
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

    MouseArea{
        anchors.centerIn: parent
        width: parent.width
        height: 200
        onClicked: {
            console.log("running:",listen.running)
            if(listen.running){
                listen.jumpTo("5")
                listen.running = false;
                listenStop();
            }
            else{
                listen.running = true;
                listenStart();
            }
        }
    }

    function start(){
        if(!listen.running){
            listen.running = true;
//            listenStart();
        }
    }

    function stop(){
        if(listen.running){
            listen.jumpTo("5")
            listen.running = false;
//            listenStop();
        }
    }

}
