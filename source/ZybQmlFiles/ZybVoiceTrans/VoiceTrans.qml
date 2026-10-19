import QtQuick 2.0
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"
import DataManager.PageModeDefine 1.0
import DevConfig.LogLevelDefine 1.0
import com.zyb.PingDefine 1.0

Rectangle {
    id : voiceTrans

    color: Style.mainbgColor
    state: "SoundListen"

    property var pageType: "voicetranspage"
    property string currentWord: ""
    property string strFrom : ""
    property string strTo : ""

    function speechEnd()
    {
        console.log("speechEnd");
        voiceManager.stopRecord();
    }

    function speechStart()
    {
        voiceManager.init();
        QueryWordManager.playStop();
        resPage.des = "";
        voiceManager.startRecord();
        UILogic.openOwnrTranseVoice();
        //UILogic.openWebSocket(1);
    }

    states: [
        State {
            name: "SoundTip"
            StateChangeScript {
                script: {
                    console.log("SoundTip state")
                }
            }
        },
        State {
            name: "SoundListen"
            StateChangeScript {
                script: {
                    console.log("SoundListen state")
                }
            }
        },
        State {
            name: "SoundNoRes"
            StateChangeScript {
                script: {
                    console.log("SoundNoRes state")
                }
            }
        },
        State {
            name: "SoundRes"
            StateChangeScript {
                script: {
                    console.log("SoundRes state")
                }
            }
        }
    ]


    Timer {
        id:backTimer
        interval: 1; running: false; repeat: false
        onTriggered:
        {
            UILogic.backToHome();
        }
    }

    SoundTipPage
    {
        id:tippage
        visible: voiceTrans.state == "SoundTip"
        anchors.fill: parent

        onReturnToParent:
        {
            backTimer.start();
        }
    }

    SoundListeningVPage
    {
        id:listenPage;
        anchors.centerIn: parent
        //rotation: 90
        rotation: devManager.isLeftHand ?-90:90
        visible: voiceTrans.state === "SoundListen"
        //anchors.fill: parent

        onReturnToParent:
        {
            voiceTrans.state = "SoundTip"
            voiceManager.stopRecord();
            ownrtansvoice.closeWebSocket();
        }

    }

    SoundNoInput
    {
        id:noResPage
        visible: voiceTrans.state == "SoundNoRes"
        anchors.fill: parent

        onReturnToParent:
        {
            voiceTrans.state = "SoundTip"
        }
    }

    VolumnPage
    {
        id:volset;
        anchors.fill: parent
        z:8
        visible: false;
        ZybBackButton{
            id:backButton
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10

            onBackClicked: {
                voiceTrans.state = "SoundRes"
                volset.visible = false
            }
        }

        onVolmueChanged:
        {
            pingManager.addPingData(PingDefine.PING_EVENT_VOICE_TRANS_VOLUME);
        }
    }

    SoundResultVPage
    {
        id:resPage;
        visible: voiceTrans.state === "SoundRes"
        //anchors.fill: parent
        anchors.centerIn: parent
        //rotation: 90
        rotation: devManager.isLeftHand ?-90:90
        onReturnToParent:
        {
            if(resPage.bFormKey === true)
            {
                UILogic.backToHome()
            }
            else
                voiceTrans.state = "SoundTip"
        }

        onVolBtnClicked:
        {
            volset.visible = true
        }

        onTimeEnd:
        {
           speechEnd();
        }
    }

    Connections
    {
        target: voiceManager
        onSig_speechEnd:
        {
//            if(websocket.isConnected())
//            {
//                console.info("****************   onSig_speechEnd 1");
//                websocket.sendApiSpeechPcmEndData();
//            }
//            else
//            {
//                console.info("****************   onSig_speechEnd 2");
//                websocket.closeWebSokcet();
//            }

            if(ownrtansvoice.isConnected())
            {
                console.info("****************   onSig_speechEnd 1");
                ownrtansvoice.sendAudioDataEnd();
            }
            else
            {
                console.info("****************   onSig_speechEnd 2");
                ownrtansvoice.closeWebSocket();
            }
        }
    }

    property  var res : new Object;

    Connections {
        target: ownrtansvoice;

        onSigSpeechReady:
        {
            console.log("onSigSpeechReady");
            voiceTrans.state = "SoundListen"
            QueryWordManager.playStop();
//            isData = false;
//            closeTimer.start();
        }

        onSigAsrResult:
        {
            console.log("onGetAsrResult:",strAsrData);
//            closeTimer.stop()
//            isData = true;
            currentWord = strAsrData

            resPage.src = currentWord;
            resPage.scrollToBottom_1();
            voiceTrans.state = "SoundRes";

            if(iStatus === 1)
            {
                //UILogic.openWebSocket(2);
                if(Segmentation.isEnglishStr(currentWord))
                {
                    strFrom = "en";
                    strTo = "zh";
                }
                else
                {
                    strFrom = "zh";
                    strTo = "en";
                }

               apiNetWork.sendApiGetNlpResult(currentWord, strFrom, strTo);

            }

        }
        onSigAsrError:
        {
            console.log("onAsrError:",strMsg);
//            closeTimer.stop()
//            isData = true;
            //err
            noResPage.mytext = strMsg
            voiceTrans.state = "SoundNoRes";
            voiceManager.stopRecord();
            UILogic.showTip("未识别到有效内容，请重试",3000);
        }

        onSigClosed:
        {
            console.log(" websocket onClosed");
//            isData = true;
//            closeTimer.stop()
            if(voiceTrans.state === "SoundListen")
            {
                QueryWordManager.playStop();
                noResPage.mytext = qsTr("服务器异常，请稍后重试2");
                voiceTrans.state = "SoundNoRes";
            }
        }
    }

//    Connections {
//        target: websocket;

//        onSpeechReady:
//        {
//            console.log("onSpeechReady");
//            voiceTrans.state = "SoundListen"
//            QueryWordManager.playStop();
//        }

//        onGetNlpResult:
//        {
//            resPage.des = trans;
//            res = {};
//            res["time"] = resPage.lasttime+1;
//            if(Segmentation.isEnglishStr(trans))
//            {
//                res["Lang"] = "Ch2Eng";
//            }
//            else
//            {
//                res["Lang"] = "Eng2Ch";
//            }
//            res["content"] = src;
//            pingManager.addPingData(PingDefine.PING_EVENT_VOICE_TRANS_NUM,res);

//            resPage.scrollToTop_1();
//            if(devManager.getAutoSpeak())
//            {
//                resPage.autoPlay();
//            }

//            if(websocket.getVoiceUUid().length > 0)
//                apiNetWork.sendAPiVoiceOPusFile(src,trans,websocket.getVoiceUUid());
//        }

//        onGetAsrResult:
//        {
//            console.log("onGetAsrResult");
//            resPage.src = src;
//            resPage.scrollToBottom_1();
//            voiceTrans.state = "SoundRes";
//        }

//        onAsrError:
//        {
//            console.log("onAsrError");
//            //err
//            noResPage.mytext = err
//            voiceTrans.state = "SoundNoRes";
//            voiceManager.stopRecordNoDely();
//        }

//        onNetworkError:
//        {
//            console.log("onNetworkError");
//            voiceTrans.state = "SoundNoRes";
//            QueryWordManager.playStop();

//            main.showTip("网络异常，请稍后重试");
//            voiceManager.stopRecordNoDely();
//        }

//        onClosed:
//        {
//            console.log(" websocket onClosed");
//            if(voiceTrans.state === "SoundListen")
//            {
//                QueryWordManager.playStop();
//                noResPage.mytext = qsTr("网络异常，请重试");
//                voiceTrans.state = "SoundNoRes";

//            }
//        }
//    }


    Connections {

        target: apiNetWork
        onSigNlpResult:
        {

            resPage.des = strDstText;
            res = {};
            res["time"] = resPage.lasttime+1;
            if(Segmentation.isEnglishStr(strDstText))
            {
                res["Lang"] = "Ch2Eng";
            }
            else
            {
                res["Lang"] = "Eng2Ch";
            }
            res["content"] = strAsrSrc;
            pingManager.addPingData(PingDefine.PING_EVENT_VOICE_TRANS_NUM,res);

            resPage.scrollToTop_1();
            if(devManager.getAutoSpeak())
            {
                if(voiceTrans.state === "SoundListen")
                {
                    return;
                }

                resPage.autoPlay();
            }

            if(ownrtansvoice.getVoiceUUid().length > 0)
                apiNetWork.sendAPiVoiceOPusFile(strAsrSrc,strDstText,ownrtansvoice.getVoiceUUid());
        }

        onSigNlpErr:
        {
            UILogic.showTip("未识别到有效内容，请重试",3000);
        }
    }

    Timer {
        id: delaytimer
        interval: 100;
        running: false;
        repeat: false

        onTriggered:
        {
            speechEnd();
        }
    }


    Connections {
        target: engineSocket;

        onSig_recordStart:
        {
            console.log("voicetrans recordStart");
            if(dataManager.getLive() === false)
            {
                voiceManager.stopRecord();
                ownrtansvoice.closeWebSocket();
                netDig.open();
                return;
            }
            genUUid();
            speechStart();
            voiceTrans.state = "SoundListen";
            volset.visible = false
            resPage.startCountTimer();

        }

        onSig_recordEnd:
        {
            resPage.stopCountTimer();
            delaytimer.restart();
        }

        onSig_offScreenKey:{
            QueryWordManager.playStop();
        }

    }

    Connections {
        target: dataManager;
        onSig_netLive:
        {
            if(sta === false)
            {
                voiceManager.stopRecord();
                ownrtansvoice.closeWebSocket();
                netDig.open();
            }
        }
    }

    function genUUid()
    {
        var conform = devManager.isConformUpTrans();
        console.log("need upload voice :",conform)
        if(conform === true)
        {
            var uuid =  Utils.currentDateTimeMs();
            voiceManager.setVoiceUUid(uuid);
            ownrtansvoice.setVoiceUUid(uuid);
        }
        else
        {
            voiceManager.setVoiceUUid("");
            ownrtansvoice.setVoiceUUid("");
        }
    }

    Component.onCompleted:
    {
        dataManager.setUIMode(PageStatus.UI_Speech);
        voiceManager.setNeedSaveFile(false);
        voiceManager.init();
        if(main.bEnterSpeechFormKey === true)
        {
            console.log("VoiceTrans onCompleted")
            genUUid();

            voiceManager.startRecord();
            UILogic.openOwnrTranseVoice()
            //UILogic.openWebSocket(1);
            QueryWordManager.playStop();

            resPage.startCountTimer();
            resPage.bFormKey = true;
            voiceTrans.state = "SoundListen";
            main.bEnterSpeechFormKey = false;
        }
        else
        {
            voiceTrans.state = "SoundTip";
        }

    }

    Component.onDestruction:
    {
        console.log("voiceTrans onDestruction()");
        voiceManager.stopRecord();
        voiceManager.release();
        ownrtansvoice.closeWebSocket();
        QueryWordManager.playStop();
        resPage.stopCountTimer();
        main.bEnterSpeechFormKey = false
        devManager.saveConfigFile();
    }

}
