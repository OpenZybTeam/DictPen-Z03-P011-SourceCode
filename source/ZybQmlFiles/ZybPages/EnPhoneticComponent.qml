import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../Global"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Item {
    id: root
    height: 56
    property bool isAutoPlay: false
    property var controlData: null
    property var wordText: ""
    Flickable {
        id:flickable
        anchors.fill: parent
//        anchors.leftMargin: 52
        contentWidth: row.width
//        contentHeight: colume.height + title.height + 100 + 80
        ScrollBar.horizontal: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true
        Row{
            id:row
            height: 56
            spacing: 22
            ZybSoundPlayButton{
                id:americaPhonetic
//                anchors.top: parent.top
//                anchors.left: parent.left
                text: qsTr("美[æt , ət]")
                onClicked: {
                    if(!isAutoPlay){
                        var valueObj = new Object;
                        valueObj["word"] = root.wordText
                        pingManager.addPingData(PingDefine.PING_EVENT_DICT_SPEECH_US,valueObj);
                    }
                    isAutoPlay = false;
                    if(isHaveSound){
                        QueryWordManager.playAmericaSound();
                    }
                    else{
                        if(visible){
                            QueryWordManager.play(root.wordText,2);
                        }
                    }

                }
            }
            ZybSoundPlayButton{
                id:englishPhonetic
//                anchors.left: americaPhonetic.right
//                anchors.leftMargin: 22
//                anchors.top: parent.top
                text: qsTr("英[æt , ət]")
                onClicked: {
                    if(!isAutoPlay){
                        var valueObj = new Object;
                        valueObj["word"] = root.wordText
                        pingManager.addPingData(PingDefine.PING_EVENT_DICT_SPEECH_ENG,valueObj);
                    }
                    isAutoPlay = false;
                    if(isHaveSound){
                        QueryWordManager.playEnglishSound();
                    }
                    else{
                        if(visible){
                            QueryWordManager.play(root.wordText,2);
                        }
                    }
                }
            }
        }
    }


    Timer{
        id:autospeakTimer
        interval: GlobalProperty.autoSpeekDelay
        repeat: false;
        running: false
        triggeredOnStart: false
        onTriggered:{
            if(devStateMonitor.getDevState() === DevStatus.DevState_OffScreen){
                return;
            }
            if(!root.visible)
                return;
            isAutoPlay = true;
            if(devManager.getSpeekMode() === 0){
                americaPhonetic.play();
            }
            else if(devManager.getSpeekMode() === 1){
                englishPhonetic.play();
            }
        }
    }

    Component.onCompleted: {
        if(controlData["phonetic"] !== undefined){

            var phonetic = controlData["phonetic"];
            if(phonetic["america"] !== undefined){
                americaPhonetic.visible = true;
                if(controlData["americasound"] !== undefined){
                    if(controlData["americasound"] || controlData["americasound"] === true){
                        americaPhonetic.isHaveSound = true;
                    }
                    else{
                        americaPhonetic.isHaveSound = false;
                    }
                }
                else{
                    if(controlData["americasound"] || controlData["americasound"] === true){
                        americaPhonetic.isHaveSound = true;
                    }
                    else{
                        americaPhonetic.isHaveSound = false;
                    }
                }
                americaPhonetic.text = qsTr("美") + phonetic["america"]
            }
            else{
                americaPhonetic.isHaveSound = false;
                americaPhonetic.visible = false;
            }

            if(phonetic["english"] !== undefined){
                englishPhonetic.visible = true;
                if(controlData["englishsound"] !== undefined){
                    if(controlData["englishsound"] || controlData["englishsound"] === true){
                        englishPhonetic.isHaveSound = true;
                    }
                    else{
                        englishPhonetic.isHaveSound = false;
                    }
                }
                else{
                    if(controlData["englishsound"] || controlData["englishsound"] === true){
                        englishPhonetic.isHaveSound = true;
                    }
                    else{
                        englishPhonetic.isHaveSound = false;
                    }
                }
                englishPhonetic.text = qsTr("英") + phonetic["english"]
            }
            else{
                englishPhonetic.isHaveSound = false;
                englishPhonetic.visible = false;
            }
            if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
                autospeakTimer.running = true;
            }
        }
        else{
            if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
                autospeakTimer.running = true;
            }
        }
    }
}
