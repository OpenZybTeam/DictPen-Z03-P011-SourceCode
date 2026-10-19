import QtQuick 2.0

Image {
    id: iconImage

    source: "qrc:/images/soundplay1_1.png"
    signal play();

    function startConnection()
    {
        soundPlayConnect.enabled = true;
    }

    function init()
    {
        timer.running = false;
        iconImage.source = "qrc:/images/soundplay1_1.png"
    }

    MouseArea{
        id:clickedArea
        anchors.fill: parent
        anchors.margins: -16

        onClicked: {
            QueryWordManager.playStop();
//            soundPlayConnect.enabled = true;
//            clickedArea.enabled = false;
            soundPlayConnect.enabled = true;
            play();
            clickedArea.enabled = false;
            timer.running = true;
            //QueryWordManager.play(wordList.getCurrentText(),2,4);
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
                iconImage.source = "qrc:/images/soundplay1_2.png"
            }
            else if(triggerCount%3 === 1){
                iconImage.source = "qrc:/images/soundplay1_3.png"
            }
            else if(triggerCount%3 === 2){
                iconImage.source = "qrc:/images/soundplay1_1.png"
            }
        }
    }



    Connections{
        id:soundPlayConnect
        target: QueryWordManager
        enabled:false

        onAudioStart:{
            clickedArea.enabled = true;
            timer.triggerCount = 0;
            timer.running = true;
        }

        onAudioStop:{
            enabled = false;
            timer.running = false;
            iconImage.source = "qrc:/images/soundplay1_1.png"
        }
    }

}
