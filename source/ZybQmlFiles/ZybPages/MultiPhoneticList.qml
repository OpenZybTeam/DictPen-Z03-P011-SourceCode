import QtQuick 2.0
import "../ZybControls"
import "../Global"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: 56
    property var strWord: ""
    signal currentIndex_Changed(int index)
    ListView{
        id:list
        anchors.fill: parent
        clip: true
        orientation: ListView.Horizontal
        delegate: phoneticComponent
        spacing:22
        model:ListModel{}
        onCurrentIndexChanged: {
            pingManager.addPingData(PingDefine.PING_EVENT_DICT_POLYPHONIC);
            currentIndex_Changed(currentIndex);
        }

    }

    Component{
        id:phoneticComponent
        ZybSoundPlayButton{
            id:multiPhoneticBtn
            property var parentView: list
            text: itemText
            textColor: (parentView.currentIndex === index) ? "#FF12CFA7" : "#FFFFFFFF"
            onClicked: {
                //root.updateExamples(explainIndex);
                parentView.currentIndex = index;
                QueryWordManager.playPolyphonicCharacter(strWord,text)
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
            list.currentItem.play()
        }
    }

    function setData(data,currentWord){
        list.model.clear();
        strWord = currentWord;
//        var explains = data["explains"];
        for(var i = 0;i < data.length;i++){
            var partSpeech,explain;
            var explainItem = data[i];
            if(explainItem["phonetic"] !== undefined){
//                console.log("phonetic:",explainItem["phonetic"])
                var phonetic = explainItem["phonetic"];
                list.model.append({"itemText":phonetic});
//                cell = phoneticComponent.createObject(phoneticList,{text: phonetic,explainIndex:i})
            }
        }
        list.currentIndex = 0;
        if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
//            list.currentItem.play();
            autospeakTimer.running = true;
        }

    }
}
