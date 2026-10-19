import QtQuick 2.0
import "../Style"
import com.zyb.PingDefine 1.0

Item {
    height: exampleEn.height + exampleCh.height + 10
    property alias enText: exampleEn.text
    property alias chText: exampleCh.text
    Text {
        id: exampleEn
        color: "#FFFFFFFF"
        wrapMode: Text.WordWrap
        font.family: Style.scanresult_explain_fontSize
        font.pixelSize: 28

        Component.onCompleted: {
            if(contentWidth < parent.width - 150){
                width = contentWidth;
            }
            else{
                width = parent.width - 150;
            }
        }
    }
    Text {
        id: exampleCh
        color: "#FFFFFFFF"
        width: parent.width
        wrapMode: Text.WrapAnywhere
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        font.pixelSize: Style.scanresult_explain_fontSize
        anchors.top: exampleEn.bottom
        anchors.topMargin: 10
        textFormat: Text.RichText
    }

    Image {
        id: soundPlay
        anchors.left: exampleEn.right
        anchors.leftMargin: 16
        anchors.top: exampleEn.top
        source: "qrc:/images/soundplay1_1.png"
        MouseArea{
            height: parent.height + 10
            width: parent.width + 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                if(soundPlayConnect.enabled === false){
                    var valueObj = new Object;
                    valueObj["dictType"] = "brief"
                    pingManager.addPingData(PingDefine.PING_EVENT_DICT_EXAMPLE_SPEECH,valueObj);
                    QueryWordManager.playStop();
                    soundPlayConnect.enabled = true;
                    QueryWordManager.play(exampleEn.text,2,4);
                    timer.triggerCount = 0;
                    timer.running = true;
                }
                else{
                    soundPlayConnect.enabled = false;
                    timer.running = false;
                    soundPlay.source = "qrc:/images/soundplay1_1.png"
                    QueryWordManager.playStop();
                }
            }
        }
    }

    Connections{
        id:soundPlayConnect
        enabled:false
        target:QueryWordManager
        onAudioStart:{
            timer.triggerCount = 0;
            timer.running = true;
        }
        onAudioStop:{
            enabled = false;
            timer.running = false;
            soundPlay.source = "qrc:/images/soundplay1_1.png"
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
                soundPlay.source = "qrc:/images/soundplay1_2.png"
            }
            else if(triggerCount%3 === 1){
                soundPlay.source = "qrc:/images/soundplay1_3.png"
            }
            else if(triggerCount%3 === 2){
                soundPlay.source = "qrc:/images/soundplay1_1.png"
            }

        }
    }
}
