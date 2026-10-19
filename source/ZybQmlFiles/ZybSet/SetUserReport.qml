import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.0
import "../ZybControls/"
import "../Style"
import "../Funcs/UILogics.js" as UILogic
import "../ZybVirturlKeyBoard"
import DevStateMonitor.DevStateDefine 1.0
import QtQuick.Controls.Styles 1.4

Rectangle {
    id:root
    color: Style.mainbgColor
    property bool isRecorded: false
    property bool isPressed : false
    property bool uploading : false
    property var duration : 0

    property string mp3Path : "/home/userdata/feedback.mp3"
    property var source : "file:///" +mp3Path
    signal backToParent
    signal btnClicked


    state: "normal"
    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    uploadTip.visible = false;
                }
            }
        },

        State {
            name: "recording"
            StateChangeScript {
                script: {
                    uploadTip.visible = false;
                }
            }
        },

        State {
            name: "commit"
            StateChangeScript {
                script: {
                    uploadTip.visible = false;
//                    totalTime.visible = false
//                    curTime.visible = false;

                }
            }
        },

        State {
            name: "input"
            StateChangeScript {
                script: {
                    uploadTip.visible = false;
                }
            }
        }
    ]


    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        onBackClicked: {

            player.stop();
            player.source = "";
            if(root.state === "commit")
            {
                root.state = "normal"
            }
            else
            {
                UILogic.backToSetPage();
            }

        }
    }

    ZybText {
        id: title
        text: qsTr("用户反馈")
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

    ZybText
    {
        id:info
        text: qsTr("录音反馈您的问题")
        color: "#A9A9A9"
        font.pixelSize: Style.tipFontPixel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: backButton.bottom
        anchors.topMargin: 26
        visible: root.state === "normal" || root.state === "recording"
    }

    ZybText
    {
        id:timenum
        text: qsTr("120s")
        font.pixelSize: Style.tipFontPixel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: info.bottom
        anchors.topMargin: 15
        font.styleName: "Bold"
        visible: root.state === "recording"
    }


    AppCountDownTimer {
        id: countDownTimer
        interval: 1090
        currentTime: 120

        onStoped: {
            isPressed = true
            bstartRecord = false;
            stopRecord()
            root.state = "commit"
            player.source = ""
            player.source = root.source
            player.play();
        }
    }


    Timer {
        id:stopRecordTimer
        interval: 1; running: false; repeat: false
        onTriggered:
        {
            stopRecord();
            console.log("ispress =", countDownTimer.currentTime);
            if(countDownTimer.currentTime > 118)
            {
                root.state = "normal"
                bstartRecord = false;
                main.showTip(qsTr("录音时间过短，请重录"));
                return;
            }

            root.state = "commit"
            player.source = "";
            player.source = root.source;
            bstartRecord = false;
        }
    }

    Timer {
        id:enableTimer
        interval: 1000; running: false; repeat: false
        onTriggered:
        {
            bstartRecord = false;
            btnRecord.enabled = true
        }
    }

    property bool bstartRecord : false

    Image {
        id: btnRecord
        source: bstartRecord === true ? "qrc:/images/recordEnd.png":"qrc:/images/recordStart.png"
        visible : root.state === "normal" || root.state === "recording"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        z:2
        MouseArea
        {
            anchors.fill: parent
            anchors.margins: -15
            onClicked:
            {
                if(bstartRecord === false)
                {
                    if(dataManager.getLive() === false)
                    {
                        main.showTip(qsTr("网络未连接，请连接网络"));
                        return;
                    }

                    root.state = "recording"
                    startRecord();
                    bstartRecord = true;
                }
                else
                {
                    btnRecord.enabled = false
                    stopRecordTimer.start();
                    enableTimer.start();
                }
            }
        }
    }

    MediaPlayer {
        id: player;
        //source: root.source
        onError: {
            console.error("MediaPlayer error:",errorString);
        }

        onPlaybackStateChanged:
        {
            if(player.playbackState ===  MediaPlayer.PlayingState)
            {
                engineSocket.sendEnableSysAutoOffScreen(false);
                devStateMonitor.setDevState(DevStatus.DevState_MediaPlaying);
            }
            else
            {
                engineSocket.sendEnableSysAutoOffScreen(true);
                devStateMonitor.setDevState(DevStatus.DevState_Normal);
            }
        }

    }

    Connections {
        target: player
        onMediaObjectChanged: {
            console.log("enter player.mediaObject");
            if (player.mediaObject)
            {
                console.log("player.mediaObject.notifyInterval = 50");
                player.mediaObject.notifyInterval = 50;
            }
        }

    }


    RowLayout
    {
        id:timeStatus
        z:10
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 120
        anchors.right: parent.right
        anchors.rightMargin: 120
        visible: root.state === "commit"
        spacing: 16

        Image {
            id:pausebtn
            source: player.playbackState ===  MediaPlayer.PlayingState ? "qrc:/images/pause88.png" :"qrc:/images/report_btn_play.png"
            width:88
            height: 88

            MouseArea
            {
                id:pausemouse
                anchors.fill: parent

                onClicked:
                {
                    console.log("pausemouse onClicked")
                    if(player.status == MediaPlayer.Loaded)
                    {
                        if(player.playbackState ==  MediaPlayer.PlayingState)
                        {
                            player.pause();
                        }
                        else if(player.playbackState ==  MediaPlayer.StoppedState)
                        {
                            player.play();
                        }
                        else if(player.playbackState ==  MediaPlayer.PausedState)
                        {
                            player.play();
                        }

                    }
                    else  if(player.status == MediaPlayer.EndOfMedia)
                    {
                        player.play();
                    }
                    else  if(player.status == MediaPlayer.Buffered)
                    {

                        if(player.playbackState ==  MediaPlayer.PlayingState)
                        {
                            player.pause();
                        }
                        else if(player.playbackState ==  MediaPlayer.StoppedState)
                        {
                            player.play();
                        }
                        else if(player.playbackState ==  MediaPlayer.PausedState)
                        {
                            player.play();
                        }
                    }
                }
            }
        }


        Text {
            id: curTime
            text: UILogic.currentTimeMMSS(player.position)
            color: "#ffffff"
            font.pixelSize: 24
            visible: root.state == "commit"
            //visible: player.duration > 0
        }


        Slider {
            id: timeSpan
            from: 0
            value: player.position
            to:player.duration
            stepSize: 1
            Layout.fillWidth: true

            background: Rectangle {
                x: timeSpan.leftPadding
                y: timeSpan.topPadding + timeSpan.availableHeight / 2 - height / 2
                implicitWidth: 440
                implicitHeight: 6
                width: timeSpan.availableWidth
                height: implicitHeight
                radius: implicitHeight/2
                color: "#33F2F3FA"

                Rectangle {
                    width: timeSpan.visualPosition * parent.width
                    height: parent.height
                    color: Style.mainColor
                    radius: 2
                }


            }

            handle: Rectangle {
                x: timeSpan.leftPadding + timeSpan.visualPosition * (timeSpan.availableWidth - width)
                y: timeSpan.topPadding + timeSpan.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                //color:  Style.mainColor
                color: timeSpan.pressed
                       ?Qt.darker("#FFFFFF")
                       :"#FFFFFF"
                border.width: 4
                border.color: Style.mainColor
            }


            onMoved: {
                console.log("player moved")
                player.seek(timeSpan.value)
                player.play();
            }
        }


        Text {
            id: totalTime
            text: UILogic.currentTimeMMSS(duration*1000)
            color: "#ffffff"
            font.pixelSize: 24
            visible: root.state === "commit"
            //visible: player.duration > 0
        }

    }

    RowLayout
    {
        id:commitlayout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 27
        spacing: 80
        visible: root.state === "commit"

        BasicButton
        {
            id:reRecord
            text: qsTr("重录")
            backgroundTheme: Style.digbgColor
            implicitWidth: 160
            implicitHeight: 56
            radius:6
            textColor:"#FFFFFF"
            checkable: false
            onClicked:
            {
                player.stop();
                root.state = "normal"
            }
        }

        BasicButton
        {
            id:btnCommit
            text: qsTr("提交")
            backgroundTheme: Style.mainColor
            implicitWidth: 160
            implicitHeight: 56
            radius:6
            checkable: false
            checked: true
            onClicked:
            {
                player.stop();
                root.state = "input"
                digKeyBoard.showKeyboard();
            }
        }
    }

    property string  phone: ""
    Timer {
        id:feedtimer
        interval: 10; running: false; repeat: false
        onTriggered:
        {
            apiNetWork.sendFeedbackData(phone,mp3Path);
        }
    }


    ZybText
    {
        id:uploadTip
        text: qsTr("反馈中...")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 80

        visible: false
        z:10
    }

    ZybDigitalKeyBoard
    {
        id:digKeyBoard
        z:9
        width: parent.width
        height: parent.height
        x:0
        y : Style.gHeight

        onBackToBefore:
        {
            root.state = "normal"
        }

        onCommitInput:
        {
            if(t1.length <9)
            {
                main.showTip(qsTr("手机号长度不正确"));
                return;
            }
            else
            {

                if(dataManager.isValidPhone(t1))
                {
                    if(uploading === true)
                        return;
                    if(dataManager.getLive() === false)
                    {
                        main.showTip(qsTr("网络未连接，请检查网络"));
                        return;
                    }

                    uploading = true;
                    phone = t1;
                    uploadTip.visible = true;
                    feedtimer.start();

                }
                else
                    main.showTip(qsTr("手机号不存在"));
            }

        }
    }

    function startRecord()
    {
        voiceManager.setNeedSaveFile(true);
        voiceManager.init();
        voiceManager.startRecord();

        timenum.text = Qt.binding(function () {
            return countDownTimer.currentTime+"s"
        })

        countDownTimer.currentTime = 120;
        countDownTimer.start();
        engineSocket.sendEnableSysAutoOffScreen(false);
    }


    function stopRecord()
    {
        console.log("onReleased")
        voiceManager.stopRecordNoDely();
        voiceManager.release();
        voiceManager.saveMp3(devManager.getCacheDir() + "feedback.mp3")
        duration = voiceManager.getMp3Duration();
        countDownTimer.stop();
        voiceManager.setNeedSaveFile(false);
        engineSocket.sendEnableSysAutoOffScreen(true);
        player.volume = devManager.getSoundVal();
    }

    function recvFeedback()
    {
        digKeyBoard.hideKeyboard();
        root.state = "normal"
        uploading = false;
    }

    Connections {
        target: apiNetWork;
        onFeedbackSubmited:
        {
            //            if(res)
            //            {
            recvFeedback();
            main.showTip(qsTr("反馈成功"));
            //            }
            //            else
            //            {

            //            }
        }

    }

    Connections {
        target: dataManager;
        onSig_netLive:
        {
            if(sta === false)
            {
                if(uploading)
                {
                    recvFeedback();
                    main.showTip(qsTr("反馈失败，请重试"));
                }
            }
        }

    }


    Component.onDestruction:
    {
        bstartRecord = false;
        uploading = false;
        voiceManager.stopRecordNoDely();
        voiceManager.release();
        voiceManager.setNeedSaveFile(false);
        countDownTimer.stop();
        engineSocket.sendEnableSysAutoOffScreen(true);
        player.stop();
        console.info("user report  player.stop()");
    }

}
