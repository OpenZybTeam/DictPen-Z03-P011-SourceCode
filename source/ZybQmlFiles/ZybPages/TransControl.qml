import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../Global"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: transContent.height + 17
    property alias transText: trans.text
    property var orgText: ""
    Column{
        id:transContent
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 16
//        width: parent.width
        spacing: 18
        Text {
            id: trans
            width: parent.width
            wrapMode: Text.WordWrap
            lineHeight: 1.3
            font.pixelSize: 28
            font.family: Style.chFontFamily

            font.styleName: "Bold"
            color: "white"
        }
        Item {
            id: soundItem
            height: 56
            width: transContent.width
            ZybSoundPlayButton{
                id:orgPlay
                anchors.top: parent.top
                anchors.left: parent.left
                text: qsTr("原文")
                onClicked: {
                    var valueObj = new Object;
                    if(QueryWordManager.m_isEnglish){
                        valueObj["wordType"] = "en"
                    }
                    else{
                        valueObj["wordType"] = "ch"
                    }

                    pingManager.addPingData(PingDefine.PING_EVENT_DICT_SRC_SPEECH,valueObj);
                    if(QueryWordManager.m_isEnglish){
                        QueryWordManager.play(root.orgText,2,4);
                    }
                    else{
                        QueryWordManager.play(root.orgText,1);
                    }
                }
            }
            ZybSoundPlayButton{
                id:transPlay
                anchors.left: orgPlay.right
                anchors.leftMargin: 22
                anchors.top: parent.top
                text: qsTr("译文")
                onClicked: {
                    var valueObj = new Object;
                    if(!QueryWordManager.m_isEnglish){
                        valueObj["wordType"] = "en"
                    }
                    else{
                        valueObj["wordType"] = "ch"
                    }
                    pingManager.addPingData(PingDefine.PING_EVENT_DICT_TRANS_SPEECH,valueObj);
                    if(QueryWordManager.m_isEnglish){
                        QueryWordManager.play(root.transText,1);
                    }
                    else{
                        QueryWordManager.play(root.transText,2,4);
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
            if(!root.visible)
                return;
            if(devStateMonitor.getDevState() === DevStatus.DevState_OffScreen){
                return;
            }
            orgPlay.play();
        }
    }

    function setTransText(str){
        transText = str;
        if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
//            orgPlay.play();
            autospeakTimer.running = true;
        }

    }

    function setDataText(transStr,orgStr){
        orgText = orgStr;
        transText = transStr;
        if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
//            orgPlay.play();
            autospeakTimer.running = true;
        }

    }

//    onVisibleChanged: {
//        if(!visible){
//            QueryWordManager.playStop();
//        }
//    }

}
