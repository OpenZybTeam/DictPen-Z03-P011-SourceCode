import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../Global"
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: explainContent.height + 0
    property var controlData: new Object;
    property bool isTitleViseble: true

    Column{
        id:explainContent
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        width: parent.width

        Text{
            id:title
            visible: root.isTitleViseble
            color: "#FF12CFA7"
            font.pixelSize: 36
            text: qsTr("成语词典")
        }
//        Text {
//            id: phonetic
//            color: "white"
//            font.pixelSize:28
//            text: qsTr("text")
//        }
        Item{
            width: parent.width
            height: example.height
            Text{
                id:example
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                font.pixelSize: 28
                color: "white"
                wrapMode: Text.WrapAnywhere
            }
        }

        Item {
            visible: singlePhonetic.visible
            width: explainContent.width
            height: 23
        }

        ZybSoundPlayButton{
            id:singlePhonetic
            visible: false
            onClicked: {
                QueryWordManager.play(controlData["word"],1);
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
            singlePhonetic.play();
        }
    }

    property bool phoneticVisible: true
    Component.onCompleted: {
        var data = controlData;
        singlePhonetic.visible = phoneticVisible;
        if(data["explain"] !== undefined && data["phonetic"] !== undefined){
            singlePhonetic.text = data["phonetic"];
            example.text = data["explain"];
//            console.log("explain:",data["explain"],"phonetic",data["phonetic"])
            if(phoneticVisible){
                if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
//                    singlePhonetic.play();
                    autospeakTimer.running = true;
                }
            }
        }
    }

    function setData(data,phoneticVisible){
        controlData = data;
        singlePhonetic.visible = phoneticVisible;
        if(data["explain"] !== undefined && data["phonetic"] !== undefined){
            singlePhonetic.text = data["phonetic"];
            example.text = data["explain"];
//            console.log("explain:",data["explain"],"phonetic",data["phonetic"])
            if(phoneticVisible){
                if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
//                    singlePhonetic.play();
                    autospeakTimer.running = true;
                }
            }
        }
    }
}
