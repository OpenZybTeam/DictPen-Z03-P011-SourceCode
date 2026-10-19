import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Rectangle {
    id: control
    width: content.width + 40//235
    height: 56
    radius: 28
    color: "#663C3D42"
    property var soundFilePath: ""
    property var soundIndex: -1
    property alias text: contentText.text
    property alias textColor: contentText.color
    property var isHaveSound: true
    signal clicked();

    Item {
        id:content
        height: parent.height
//        width: contentText.width + (control.isHaveSound ? contentImage.width : 0)
        width: contentText.width + contentImage.width
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id:contentText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "#FFCECECE"
            font.pixelSize: Style.scanresult_explain_fontSize
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: control.text
        }
        Image {
            id: contentImage
//            visible: control.isHaveSound
            anchors.left: contentText.right
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/soundplay2_1.png"
        }
    }



    Timer{
        id:timer
        interval: 400
        running: false
        triggeredOnStart: true
        repeat: true
        property var triggerCount: 0
        onTriggered: {
            triggerCount = triggerCount + 1;
            if(triggerCount%3 === 0){
                contentImage.source = "qrc:/images/soundplay2_2.png"
            }
            else if(triggerCount%3 === 1){
                contentImage.source = "qrc:/images/soundplay2_3.png"
            }
            else if(triggerCount%3 === 2){
                contentImage.source = "qrc:/images/soundplay2_1.png"
            }

        }
    }

    MouseArea{
        width: parent.width
        height: parent.height + 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:parent.verticalCenter
        onClicked: {
//            if(!control.isHaveSound)
//                return;

            if(soundPlayConnect.enabled === false){
                QueryWordManager.playStop();
                soundPlayConnect.enabled = true;
                control.clicked();
                timer.triggerCount = 0;
                timer.running = true;
            }
            else{
                soundPlayConnect.enabled = false;
                timer.running = false;
                contentImage.source = "qrc:/images/soundplay2_1.png"
                QueryWordManager.playStop();
            }
        }
    }



    Connections{
        id:soundPlayConnect
        enabled:false
        target:QueryWordManager
        onAudioStart:{
//            console.log("soundPlay onAudioStart")
            timer.triggerCount = 0;
            timer.running = true;
        }
        onAudioStop:{
//            console.log("soundPlay onAudioStop")
            enabled = false;
            timer.running = false;
            contentImage.source = "qrc:/images/soundplay2_1.png"
        }
    }

    function play(){
//        if(/*soundPlayConnect.enabled === false && */control.isHaveSound){
//            QueryWordManager.playStop();
//            control.clicked();
//            soundPlayConnect.enabled = true;
//            timer.triggerCount = 0;
//            timer.running = true;
//        }
        QueryWordManager.playStop();
        control.clicked();
        soundPlayConnect.enabled = true;
        timer.triggerCount = 0;
        timer.running = true;
    }
}

