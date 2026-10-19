import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"

Item {
    id:root
    property var controlData: new Object
    property bool isRecording: false
    property bool isNetOutTime: false
    property bool isPrePageScanres: true
    signal back();
    signal gotoResultPage(var resObj)

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            QueryWordManager.playStop();
            back();
        }
    }

    Item{
        id:loadingItem
        anchors.centerIn: parent
        height: imgLoading.height + 10 + loadtip.height
        width: loadtip.width
        visible: false
        z:10
        RotationImage
        {
            id: imgLoading

//            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
            source: "qrc:/images/connecting56x56.png"
            running: loadingItem.visible
            duration: 1000
        }

        Text {
            id: loadtip
            color: "#FFFFFFFF"
            anchors.top:imgLoading.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("正在测评")
        }
    }

    Flickable{
        id:titleFlick
        contentHeight: title.height
        ScrollBar.vertical: ScrollBar {active: true}
        clip: true
        boundsBehavior: Flickable.OvershootBounds
        anchors.left: backButton.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: backButton.top
        anchors.bottom: tipText.top
        anchors.bottomMargin: 5
        property var contentCoordY: 0 //记录滚动条位置
//        anchors.verticalCenter: backButton.verticalCenter
        Text {
            id: title
            width: parent.width
            text: qsTr("select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination select by examination")
            wrapMode: Text.WordWrap
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            font.pixelSize: 36
            color: "#FF12CFA7"
        }

        Component.onCompleted: {
            contentCoordY = contentY;
        }

        onVisibleChanged: {
            if(visible){
                contentY = contentCoordY;
            }
        }
    }

    Timer{
        id:timer
        interval: 190000
        running: false
        triggeredOnStart: false
        repeat: false
        onTriggered: {
//            console.log("timer onTriggered");
            console.log("timer voiceManager.stopRecord()")
            voiceManager.stopRecordNoDely();
            engineSocket.sendEnableSysAutoOffScreen(true);
            voiceManager.saveMp3(devManager.getCacheDir() + "yvyin.mp3");
            voiceManager.setNeedSaveFile(false);
            listenControl.stop();
//            UILogic.showTip(qsTr("正在测评"),120000);
            console.time("sendAPiSpeehDetermineData")
            isNetOutTime = false;
            apiNetWork.sendAPiSpeehDetermineData(title.text)
            loadingItem.visible = true;
            isRecording = false;
            outTimeTimer.running = true;
        }
    }

    Timer{
        id:outTimeTimer
        interval: 100000
        running: false
        triggeredOnStart: false
        repeat: false
        onTriggered: {
            loadingItem.visible = false;
            listenControl.enabled = true;
            isNetOutTime = true;
            UILogic.showTip(qsTr("网络错误，请重试"));
            tipText.state = "retry"
        }
    }

    Timer{
        id:sendTimer
        interval: 500
        running: false
        triggeredOnStart: false
        repeat: false
        onTriggered: {

            outTimeTimer.running = true;
            console.log("sendTimer voiceManager.stopRecord()")
            voiceManager.stopRecordNoDely();
            engineSocket.sendEnableSysAutoOffScreen(true);
            voiceManager.saveMp3(devManager.getCacheDir() + "yvyin.mp3");
            voiceManager.setNeedSaveFile(false);

//            UILogic.showTip(qsTr("正在测评"),120000);
            isNetOutTime = false;
            apiNetWork.sendAPiSpeehDetermineData(title.text)
            isRecording = false;
        }
    }

    Text {
        id: tipText
        anchors.bottom: listenControl.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 24
        color: "#666666"
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        text: listenControl.running ? qsTr("点击屏幕结束录音") : qsTr("点击屏幕重试")
        state: "record"
        states: [
            State {
                name: "record"
                StateChangeScript {
                    script: {
                        tipText.text = qsTr("点击屏幕结束录音")
                    }
                }
            },

            State {
                name: "upload"
                StateChangeScript {
                    script: {
                        tipText.text = qsTr(" ")
                    }
                }
            },

            State {
                name: "retry"
                StateChangeScript {
                    script: {
                        tipText.text = qsTr("点击屏幕重试")
                    }
                }
            }
        ]
    }

    ListenControl{
        id:listenControl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        onListenStop: {
            tipText.state = "upload"
            listenControl.enabled = false;
            timer.stop();
            listenControl.stop();
            loadingItem.visible = true;
            sendTimer.running = true;
        }
        onListenStart: {
            tipText.state = "record"
            timer.start();
            voiceManager.setNeedSaveFile(true);
            voiceManager.startRecord();
            engineSocket.sendEnableSysAutoOffScreen(false);
            isRecording = true;
        }


    }

    Timer{
            id:backTimer
            interval: 100
            running: false
            triggeredOnStart: false
            repeat: false
            onTriggered: {
                apiNetWork.setSpeechStop(true);
                timer.stop();
                UILogic.closeTip();
                console.log("backTimer voiceManager.stopRecord()")
                voiceManager.stopRecordNoDely();
                engineSocket.sendEnableSysAutoOffScreen(true);
                console.log("backTimer voiceManager.release()")
                voiceManager.release();
                voiceManager.setNeedSaveFile(false);
                listenControl.stop();
                loadingItem.visible = false;
                isRecording = false;
                outTimeTimer.running = false;
            }
        }

    Timer{
            id:startTimer
            interval: 100
            running: false
            triggeredOnStart: false
            repeat: false
            onTriggered: {
                tipText.state = "record"
                apiNetWork.setSpeechStop(false);
                timer.start();
                listenControl.start();
                voiceManager.setNeedSaveFile(true);
                voiceManager.init();
                voiceManager.startRecord();
                engineSocket.sendEnableSysAutoOffScreen(false);
                isRecording = true;
            }
        }


    Connections{
        target: apiNetWork
        onSig_getSpeechDetermineRes:{
//            console.timeEnd("sendAPiSpeehDetermineData")
            if(isRecording || isNetOutTime){
                return;
            }
            if(visible){
                var httpRes = resObj;
                var res = JSON.stringify(resObj);
//                console.log("resObj:",res)
                if(httpRes["status"] !== undefined){
                    var status = httpRes["status"];

                    if(status === 0){
                        var scoreRes = new Object;
//                        console.log(httpRes["score"],httpRes["accurate_score"],httpRes["integrity_score"],httpRes["fluency_score"])
                        scoreRes["word"] = title.text;
                        scoreRes["score"] = httpRes["score"].toFixed(0);
                        scoreRes["accurate_score"] = httpRes["accurate_score"].toFixed(0);
                        scoreRes["integrity_score"] = httpRes["integrity_score"].toFixed(0);
                        scoreRes["fluency_score"] = httpRes["fluency_score"].toFixed(0);
                        UILogic.closeTip();
                        gotoResultPage(scoreRes);
                    }
                    else{
                        listenControl.enabled = true;
                        tipText.state = "retry"
                        UILogic.closeTip();
                        UILogic.showTip(qsTr("网络错误，请重试"));
//                        console.log("http error");
                    }
                    outTimeTimer.running = false;
                    loadingItem.visible = false;
                }
            }

        }
    }

    onVisibleChanged: {
        if(visible){
            listenControl.enabled = true;
            startTimer.running = true;

        }
        else{
            console.log("FollowUpStartPage backTimer runing true");
//            backTimer.running = true;
            sendTimer.running = false;
            startTimer.running = false;
            outTimeTimer.running = false;
            timer.running = false;
        }
    }

    Component.onCompleted: {
        listenControl.enabled = true;
        startTimer.running = true;
//        listenControl.enabled = true;
//        apiNetWork.setSpeechStop(false);
//        timer.start();
//        listenControl.start();
//        voiceManager.setNeedSaveFile(true);
//        voiceManager.init();
//        voiceManager.startRecord();
//        engineSocket.sendEnableSysAutoOffScreen(false);
//        isRecording = true;
    }

    Component.onDestruction: {
        apiNetWork.setSpeechStop(true);
        timer.stop();
        UILogic.closeTip();
        console.log("Component.onDestruction voiceManager.stopRecord()")
        voiceManager.stopRecordNoDely();
        engineSocket.sendEnableSysAutoOffScreen(true);
        console.log("Component.onDestruction voiceManager.release()")
        voiceManager.release();
        voiceManager.setNeedSaveFile(false);
        listenControl.stop();
        loadingItem.visible = false;
        isRecording = false;
        outTimeTimer.running = false;
    }

    function setData(data){
        if(data.length > 900){
            title.text = data.substring(0,900);
        }
        else{
            title.text = data;
        }

    }


}
