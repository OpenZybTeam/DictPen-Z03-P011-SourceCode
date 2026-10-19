import QtQuick 2.0
import QtMultimedia 5.0
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"
import "../ZybSet"
import DataManager.PageModeDefine 1.0
import DevConfig.LogLevelDefine 1.0
import AgoraSslClient.CallStateDefine 1.0
import QtQuick.Controls 2.3
import DevStateMonitor.DevStateDefine 1.0
import com.zyb.PingDefine 1.0

Rectangle {
    id : phone
    color: Style.mainbgColor
    property var pageType: "phone"
    property int callingTime : 0
    property var callStartTime : 0
    property bool isCallout : true
    property int recordStaus: 2 //0:接收方拒接，1：接收方超时取消，2，接收方忙，3：接收方接通，4：呼入方取消
    property bool initRecord : false
    property bool redIconClicked: false
    property bool haveRedIcon: false
    function callTimerTriggerd()
    {
        callTimer.triggered.disconnect(callTimerTriggerd) // don't forget to remove the callback
        btncall.enabled = true
    }

    Item
    {
        id:child
        width: Style.gHeight
        height: Style.gWidth
        rotation: devManager.isLeftHand ?-90:90
        anchors.centerIn: parent

        PopupDialog
        {
            id:netWarnDig
            width: 228
            height: 231
            isVertical :true
            x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
            y:devManager.isLeftHand?(parent.height-(parent.height -80- height) /*/ 2*/):((parent.height-80 - height)/* / 2*/)
            closeBtnVisible:true
            leftTxtVisble:false
            content:qsTr("网络未连接，\n请先连接网络")
            rightTxt:qsTr("去设置")

            onRightClicked:
            {
                netWarnDig.close();
                naviPanel.sceneSource = "qrc:/ZybQmlFiles/ZybSet/SetMainPage.qml";
            }
        }


        ZybBackButton
        {
            id:back
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            visible: phone.state==="ready"
            onBackClicked: {
                UILogic.backToHome();
            }
        }

        Image {
            id: img
            //            anchors.top: parent.top
            //            anchors.topMargin: 13
            y:volume.y+5
            anchors.horizontalCenter: volume.horizontalCenter
            //            anchors.left: parent.left
            //            anchors.leftMargin: 22

            z:2
            visible : phone.state === "calling"
            source: "qrc:/images/soundon.png"
            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onClicked:
                {
                    volume.visible = !volume.visible
                }
            }

            onVisibleChanged:
            {
                console.log("IMg visible changed")
                initAudio();
                if(visible === false)
                {
                    volume.visible = false;
                }
            }
        }

        Rectangle {
            id:volume
            implicitWidth: 50
            implicitHeight: 290
            anchors.left: parent.left
            anchors.leftMargin: 20
            //            anchors.left: back.right
            //            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: 26
            radius: 25
            color: "#993C3D42"
            property alias slider: control
            visible: false

            Slider{
                id: control
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 69
                implicitWidth: 4
                implicitHeight: 199
                orientation:Qt.Vertical
                from: 0
                to:100
                padding: 0
                stepSize: 1
                z:2

                background: Rectangle {
                    implicitWidth: 4
                    implicitHeight: control.implicitHeight
                    color: "#66FFFFFF"
                    radius:2

                    Rectangle {
                        y: 0
                        width:  parent.width
                        height: control.position * parent.height
                        color: "#12CFA7"
                        radius:2
                    }
                }

                handle: Item {
                    width: 0
                    height: 0
                }
            }

        }


        SwipeArea
        {
            id:audioArea
            x:0
            width: parent.width
            y:0
            height: volume.height
            enabled: phone.state === "calling"
            //drayXandY : false
            z:10
//            onXmove:
//            {
//                console.log("x move",x)
//                volume.visible = true
//                if(x > 0)
//                {
//                    phoneA2BManager.adjustPlayoutVolumeSmall();
//                }
//                else
//                {
//                    phoneA2BManager.adjustPlayoutVolumeBig();
//                }

//                initAudio();
//            }

            onUpmove:{
                volume.visible = true
                phoneA2BManager.adjustPlayoutVolumeSmall();
                initAudio();
            }

            onClicked:
            {
                volume.visible = !volume.visible
            }

            onDownmove:{
                volume.visible = true
                phoneA2BManager.adjustPlayoutVolumeBig();
                initAudio();
            }

        }


        Rectangle {
            id:appform
            width: 200
            height: 70
            radius: 6
            color: "#993C3D42"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: volume.bottom
            anchors.topMargin: 10
            visible: formOrTo.text.length > 0

            ZybText {
                id:formOrTo
                text: ""//qsTr("爸爸")
                font.styleName: "Bold"
                font.pixelSize: Style.titleFontPixel
                anchors.centerIn: parent
            }
        }

        ZybText {
            id:status
            text: qsTr("正在呼叫...")
            font.pixelSize: Style.titleFontPixel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: appform.bottom
            anchors.topMargin: 30
            visible: phone.state === "ring"
        }

        ZybText {
            id:status_incoming
            text: qsTr("您来电了...")
            font.pixelSize: Style.titleFontPixel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: appform.bottom
            anchors.topMargin: 30
            visible: phone.state === "incoming"
        }

        ZybText {
            id:strTime
            text: qsTr("00:00")
            font.pixelSize: Style.titleFontPixel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: appform.bottom
            anchors.topMargin: 30
            visible: phone.state === "calling"
        }


        Rectangle {
            id: statip
            opacity: 0
            width: 200
            height: 70
            radius: 6
            color: Style.digbgColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: strTime.top
            anchors.topMargin: -15
            property alias content: text.text

            Label {
                id: text
                width: parent.width-20
                //color: "transparent"
                height: parent.height
                anchors.centerIn: parent
                //elide: Text.ElideMiddle
                wrapMode: Text.WrapAnywhere
                font.pixelSize: Style.tipFontPixel
                font.family: Style.fontFamily
                color: Style.fontColor
                verticalAlignment: Text.AlignVCenter 	//垂直居中，控件必须有height才可以使用
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("对方已取消")
            }

            Behavior on opacity { PropertyAnimation{ duration: 1000 } }

            Timer{
                id:tiptimer
                interval: 1000;
                repeat: false;
                running: statip.opacity === 1
                triggeredOnStart: false
                onTriggered: {
                    statip.opacity = 0;
                }
            }
        }

        Timer { id: callTimer }

        Image {
            id: btncall
            //anchors.centerIn: parent
            //anchors.verticalCenterOffset: 160
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Style.highVersion?192:114
            source: "qrc:/images/call.png"
            width: phone.state==="ready"?100:88
            height: width
            visible: phone.state === "ready" ||  phone.state=== "incoming"
            opacity: mouseArea.pressed ? 0.4 : 1.0
            enabled: false
            MouseArea
            {
                id:mouseArea
                anchors.fill: parent
                onClicked:
                {
                    console.log("btncall clicked",phone.state);
                    btncall.enabled =false
//                    callTimer.interval = 160
//                    callTimer.triggered.connect(callTimerTriggerd)
//                    callTimer.start();

                    strTime.text = "";
                    if(phone.state === "ready")
                    {
                        if(dataManager.getLive() === false)
                        {
                            statip.height = 70
                            statip.content = qsTr("无网络")
                            statip.opacity = 1;
                            btncall.enabled = true
                            return;
                        }
                        else
                        {
                            if(sslClient.getLoginStatus() === false)
                            {
                                statip.height = 70
                                statip.content = qsTr("网络异常，请重试")
                                statip.opacity = 1;
                                sslClient.sendLogin();
                                btncall.enabled = true
                                return;
                            }
                        }

                        apiNetWork.sendGetDevSta();
                        //                        if(!devManager.getAppSupportPhone())
                        //                        {
                        //                            statip.height = 110
                        //                            statip.content = qsTr("碳氧智能App版本低，请升级")
                        //                            statip.opacity = 1;
                        //                            return;
                        //                        }

                        //                        sslClient.sendRequestApply();
                        phone.state = "ring"
                        isCallout = true;
                        btncall.enabled = true
                    }
                    else if(phone.state === "incoming")
                    {
                        hangAccept();
                    }
                    else
                    {
                        btncall.enabled = true
                    }
                }
            }
        }


        Image {
            id:btnhangup
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Style.highVersion?192:114

            source: "qrc:/images/hangup.png"
            width: phone.state==="ring"?100:88
            height: width
            visible: phone.state === "ring" || phone.state=== "incoming" || phone.state==="calling"
            opacity: hangupmouseArea.pressed ? 0.4 : 1.0

            MouseArea
            {
                id:hangupmouseArea
                anchors.fill: parent
                onClicked:
                {
                    btnhangup.enabled = false;
                    btncall.enabled = false
                    hangupClickTimer.start();
                    hangup();
                    phone.state = "ready"
                }
            }
        }

        ZybText {
            text: qsTr("挂断")
            anchors.top: btnhangup.bottom
            anchors.topMargin: 10
            visible:  phone.state==="calling"
            anchors.horizontalCenter: btnhangup.horizontalCenter
        }


        Image {
            id:btnMute
            anchors.left : parent.left
            anchors.leftMargin : 20
            //anchors.verticalCenter: parent.verticalCenter
            //anchors.verticalCenterOffset: 160
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Style.highVersion?192:114
            source: "qrc:/images/nosound.png"
            width: 88
            height: width
            visible: phone.state === "calling"
            opacity: mutemouseArea.pressed ? 0.4 : 1.0

            MouseArea
            {
                id:mutemouseArea
                anchors.fill: parent
                onClicked:
                {
                    if(phoneA2BManager.getPublishVolumn() === 0)
                    {
                        phoneA2BManager.adjustPublishVolumn(85);
                        phoneA2BManager.muteLocalAudio(false);
                        btnMute.source = "qrc:/images/nosound.png";

                    }
                    else
                    {
                        phoneA2BManager.adjustPublishVolumn(0);
                        phoneA2BManager.muteLocalAudio(true);
                        btnMute.source = "qrc:/images/nosound-checked.png";
                    }
                }
            }
        }


        ZybText {
            text: qsTr("静音")
            anchors.top: btnMute.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: btnMute.horizontalCenter
            visible: btnMute.visible
        }

        PhoneRecord
        {
            id:recordPage
            z:2
            anchors.fill: parent
            anchors.topMargin: 90
            anchors.bottomMargin: 70
            visible: false

        }

        BasicButton
        {
            id:callSwitchBtn
            text: qsTr("语音通话")
            backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            implicitWidth: parent.width/2
            implicitHeight: 66
            radius:0
            fontsize: Style.highVersion? 24:28
            autoExclusive: true
            checked: true
            checkable: true
            visible: phone.state === "ready"
            onClicked: {
                recordPage.visible = false
                recordSwitchBtn.enabled = true
                recordBtnTimer.stop();
            }
        }
        BasicButton
        {
            id:recordSwitchBtn
            text: qsTr("通话记录")
            backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
            implicitWidth: parent.width/2
            implicitHeight: 66
            anchors.left: callSwitchBtn.right
            y:callSwitchBtn.y
            radius:0
            fontsize: Style.highVersion? 24:28
            autoExclusive: true
            checked: false
            checkable: true
            visible: phone.state === "ready"

            Timer
            {
                id:recordBtnTimer
                repeat: false
                interval: 200
                onTriggered:
                {
                    recordSwitchBtn.enabled = true
                }
            }

            onClicked: {
                console.log("recordSwitchBtn clicked")
                recordSwitchBtn.enabled = false
                recordBtnTimer.start();

                initPhoneRecords();
                recordPage.visible = true
                redIconClicked = true;
                if(haveRedIcon)
                {
                    apiNetWork.sendApiClearCallMiss();
                    haveRedIcon = false;
                }

                redIcon.visible = false;
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_HISTORY);
            }
        }

        Rectangle
        {
            id:redIcon
            color: "red"
            width: 12
            height: 12
            radius: 6
            anchors.right: recordSwitchBtn.right
            anchors.rightMargin: 6
            anchors.top: recordSwitchBtn.top
            anchors.topMargin: 6
            visible: false
        }

    }

    Timer
    {
        id:countTimer
        repeat: true
        running: false
        interval: 1000
        onTriggered:
        {
            callingTime++;
            strTime.text = UILogic.currentTimeMMSS(callingTime*1000);
        }
    }

    Timer {
        id: hangupClickTimer
        interval: 1500;
        running: false;
        repeat: false

        onTriggered:
        {
            btnhangup.enabled = true;
            btncall.enabled = true
        }
    }

    Timer {
        id: hangupTimer
        interval: 500;
        running: false;
        repeat: false

        onTriggered:
        {
            phone.state = "ready"
            player.stop();
        }
    }

    property  var res : new Object;
    function hangup()
    {
        console.log("cur state = ",phone.state);
        player.stop();
        res = {};
        if(phone.state === "incoming")
        {
            isCallout = false
            recordStaus = 0
            haveRedIcon = true
            sslClient.sendApplyStatus(CallStatue.Call_hangup);
            sendApiAddOneCallRecord();
            res["state"] = "reject"
            pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
        }
        else if(phone.state === "ring")
        {
            if(dataManager.getLive() === false)
            {
                statip.height = 70
                statip.content = qsTr("网络已断开")
                statip.opacity = 1;
                calloutTimer.stop();
                phone.state = "ready"
                res["state"] = "network err"
                if(isCallout === true)
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
                }
                else
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
                }
                return;
            }

            recordStaus = 4
            sslClient.sendCancelRequestApply();
            sendApiAddOneCallRecord();

            res["state"] = "cancel"
            pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
        }
        else if(phone.state === "calling")
        {
            recordStaus = 3
            countTimer.stop();
            sendApiAddOneCallRecord();

            res["state"] = "accept"
            if(isCallout === true)
            {
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
            }
            else
            {
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
            }

        }

        phoneA2BManager.stopAgoraThread();
        incomeingTimer.stop();
        calloutTimer.stop();
        phone.state = "ready"
        //hangupTimer.restart();
    }

    function hangAccept()
    {
        sslClient.sendApplyStatus(CallStatue.Call_Accept);
        //开启声望sdk线程
        sslClient.startAgoraThread();
        recordStaus = 3
        isCallout = false
        callingTime = 0;
        callStartTime = devManager.getCurStampMS();
        console.log("22---------------------",callStartTime);
        //countTimer.start();
        incomeingTimer.stop();
        //accetpTimer.start();
        //player.stop();
    }

    Timer {
        id: accetpTimer
        interval: 400;
        running: false;
        repeat: false

        onTriggered:
        {
            //phone.state = "calling"
            //player.stop();
        }
    }

    function sendApiAddOneCallRecord()
    {
        var t = callingTime;
        var startTime = callStartTime;
        var did = devManager.getDeviceId();
        var pid = devManager.getCurPareId();
        var pname = devManager.getCurPareName();
        console.log(t,did,pid,pname);

        apiNetWork.sendApiAddOneCallRecord(did,pid,recordStaus,startTime,t,isCallout,0);
    }

    state: "ready"
    states: [
        State {
            name: "ready"
            StateChangeScript {
                script: {
                    console.log("ready state")
                    engineSocket.sendEnableSysAutoOffScreen(true);
                    btncall.anchors.left = undefined;
                    btncall.anchors.horizontalCenter = child.horizontalCenter
                    btncall.anchors.bottom = child.bottom
                    btncall.anchors.bottomMargin =  Style.highVersion?192:114

                    player.stop();
                    devStateMonitor.setDevState(DevStatus.DevState_Normal);
                    phoneA2BManager.setTalking(false);
                    if(haveRedIcon)
                    {
                        redIcon.visible = true;
                    }
                }
            }
        },
        State {
            name: "ring"
            StateChangeScript {
                script: {
                    console.log("ring state")
                    engineSocket.sendEnableSysAutoOffScreen(false);
                    btnhangup.anchors.right = undefined
                    btnhangup.anchors.horizontalCenter= child.horizontalCenter
                    btnhangup.anchors.bottom=  parent.bottom
                    btnhangup.anchors.bottomMargin= Style.highVersion?192:114


                    calloutTimer.restart();
                    devStateMonitor.setDevState(DevStatus.DevState_Calling);
                    phoneA2BManager.setTalking(true);
                    redIcon.visible = false;
                    player.play();
                }
            }
        },

        State {
            name: "incoming"
            StateChangeScript {
                script: {
                    console.log("incoming state")
                    engineSocket.sendEnableSysAutoOffScreen(false);
                    btncall.anchors.horizontalCenter = undefined
                    btncall.anchors.left = child.left
                    btncall.anchors.leftMargin =  20

                    btnhangup.anchors.horizontalCenter= undefined
                    btnhangup.anchors.right = child.right
                    btnhangup.anchors.rightMargin = 20

                    recordPage.visible = false
                    callSwitchBtn.checked = true

                    incomeingTimer.restart();
                    devStateMonitor.setDevState(DevStatus.DevState_Calling);
                    engineSocket.sendPhoneComeingScreenOn();
                    phoneA2BManager.setTalking(true);
                    redIcon.visible = false;
                    player.play();
                }
            }
        },
        State {
            name: "calling"
            StateChangeScript {
                script: {
                    console.log("calling state")
                    btnhangup.anchors.horizontalCenter = undefined
                    btnhangup.anchors.right = child.right
                    btnhangup.anchors.rightMargin = 20

                    countTimer.start();
                    player.stop();
                    btnMute.source = "qrc:/images/nosound.png";
                    devStateMonitor.setDevState(DevStatus.DevState_Calling);
                    phoneA2BManager.setTalking(true);
                    redIcon.visible = false;
                }
            }
        }
    ]

    Timer {
        id:calloutTimer
        interval: 60000; running: false; repeat: false
        onTriggered:
        {
            if(phone.state === "ready")
                return;

            if(phone.state == "ring")
            {
                phone.state = "ready"
                recordStaus = 1
                if(dataManager.getLive() === false)
                {
                    statip.height = 70
                    statip.content = qsTr("网络已断开")
                    statip.opacity = 1;
                    return;
                }

                res = {};
                res["state"] = "timeout"
                if(isCallout === true)
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
                }
                else
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
                }

                statip.height = 70
                statip.content = qsTr("对方无应答")
                statip.opacity = 1;
                sendApiAddOneCallRecord();
            }
        }
    }

    Timer {
        id:incomeingTimer
        interval: 60000; running: false; repeat: false
        onTriggered:
        {
            console.log("incomeingTimer trigered");
            if(phone.state === "incoming")
            {
                sslClient.sendApplyStatus(CallStatue.Call_timeout);
                isCallout = false
                recordStaus = 1
                sendApiAddOneCallRecord();
                haveRedIcon = true
                phone.state = "ready"

                res = {};
                res["state"] = "timeout"
                if(isCallout === true)
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
                }
                else
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
                }
            }
        }
    }

    Timer {
        id:backTimer
        interval: 2; running: false; repeat: false
        onTriggered:
        {
            player.stop();
            UILogic.backToHome();
        }
    }

    Timer {
        id: delaytimer
        interval: 1000;
        running: false;
        repeat: false

        onTriggered:
        {
            qrIndicator.visible = false
            qr.visible = false

            formOrTo.text = devManager.getCurPareName();
            sslClient.setupSecureSocket();
            sslClient.secureConnect();
        }
    }

    RotationImage
    {
        id:qrIndicator
        source: "qrc:/images/setLoading46x44.png"
        anchors.centerIn: parent
        visible: false
        z:100
        running: visible
    }

    SetQrVPage
    {
        id:qr;
        anchors.centerIn: parent
        rotation: devManager.isLeftHand ?-90:90
        visible: false
        z:2
        source: "file:///"+"/home/userdata/qr.png"
        onBackToParent:
        {
            UILogic.backToHome();
        }

        onQrSuccess:
        {
            if(qr.visible === true)
            {
                qrIndicator.visible = true
                apiNetWork.sendApiGetCallRecords();
                console.log("On qrSuccess");
                delaytimer.start();
            }
        }
    }

    MediaPlayer {
        id: player;
        volume: devManager.getSoundVal()
        loops: MediaPlayer.Infinite
        source : "qrc:/images/ring.mp3"
        onError: {
            console.error("MediaPlayer error:",errorString);
        }

        onStopped:
        {
            console.log("ssl player stoped");
        }


        //autoPlay: phone.state==="incoming" || phone.state==="ring"
    }

    Connections{
        target: engineSocket
        onSig_offScreenKey:
        {
            //挂断电话
            hangup();
        }

        onSig_btPlayStatusChanged:
        {
            if(phone.state==="incoming")
            {
                hangAccept();
            }
        }
    }

    Connections{
        target: apiNetWork
        onSig_haveMissCall:
        {
            haveRedIcon = true;
            if(phone.state === "ready")
                redIcon.visible = true;
            redIconClicked = false
        }

        onSig_logoutSuccess:
        {
            qr.visible = true;
            player.stop();
        }

        onSig_appNotLogin:
        {
            if(phone.state === "ring")
            {
                player.stop();
                statip.height = 110
                statip.content = qsTr("作业帮智能App未登录")
                statip.opacity = 1;
                phone.state = "ready"
            }
        }

        onSig_appSupportPhone:
        {
            if(phone.state === "ring")
            {
                if(support)
                {
                    sslClient.sendRequestApply();
                }
                else
                {
                    player.stop();
                    statip.height = 110
                    statip.content = qsTr("作业帮智能App版本低，请升级")
                    statip.opacity = 1;
                    phone.state = "ready"
                }
            }
        }
    }

    Connections
    {
        target: phoneA2BManager
        onSig_startAgoraServiceFailed:
        {
            console.log("onSig_startAgoraServiceFailed");
            player.stop();
            recordStaus = 1
            statip.height = 70
            statip.content = qsTr("服务异常")
            statip.opacity = 1;
            incomeingTimer.stop();
            calloutTimer.stop();
            phoneA2BManager.stopAgoraThread();
            sslClient.sendApplyStatus(CallStatue.Call_hangup);
            phone.state = "ready"
        }

        onSig_txNetQuality:
        {
            statip.height = 70
            statip.content = qsTr("网络信号差")
            statip.opacity = 1;

            apiNetWork.sendErrorMonitor("Phone",2);
        }

        onSig_rxNetQuality:
        {
            statip.height = 70
            statip.content = qsTr("对方网络信号差")
            statip.opacity = 1;

            apiNetWork.sendErrorMonitor("Phone",3);
        }

        onSig_userLeaveNetWeak:
        {
            statip.height = 70
            statip.content = qsTr("对方网络信号差")
            statip.opacity = 1;

            apiNetWork.sendErrorMonitor("Phone",3);
        }

        onSig_userLeave:
        {
            statip.height = 70
//            if(uid === devManager.getDeviceId())
//            {
//                statip.content = qsTr("已挂断")
//            }
//            else
//            {
                statip.content = qsTr("对方已挂断")
//            }
            statip.opacity = 1;
            hangup();
        }

        onSigReConnecting:
        {
            statip.height = 70
            statip.content = qsTr("连接重新建立中")
            statip.opacity = 1;
        }

        onSig_connectionLast:
        {
            statip.height = 70
            statip.content = qsTr("连接已丢失")
            statip.opacity = 1;
            hangup();
        }

        onSig_userRejoined:
        {
            statip.height = 70
            statip.content = qsTr("已重新进入")
            statip.opacity = 1;
        }

        onSig_joinChanneled:
        {
            console.log("onSigChannelJoined")
            btncall.enabled = true
            player.stop();
        }

//        onSig_rxNetIsHave: //检测到频道对方网络
//        {
//            haveOther = true;
//            checkOtherIsInTimer.stop();
//        }

        onSigErrorCaptured:
        {
            console.log("onSigErrorCaptured",code,msg);
            statip.height = 70
            statip.content = msg;
            statip.opacity = 1;
            hangup();
            sslClient.sendApplyStatus(CallStatue.Call_hangup);
        }

        onSig_userJoined:
        {
            console.log("onSigRemoteUserJoined")
            phone.state = "calling"
            btncall.enabled = true
        }
    }

    Connections
    {
        target: sslClient
        onCallResEccept:
        {
            console.log("-----------------onCallResEccept")
            player.stop();
            if(phone.state !== "ring")
            {
                phoneA2BManager.stopAgoraThread();
                console.log("onCallResEccept state==ring")
                return;
            }

            var res = sslClient.startAgoraThread();
            if(res === -1)
            {
                console.log("onCallResEccept startAgoraThread==-1")
                return;
            }

            recordStaus = 3
            callingTime = 0;
            callStartTime = devManager.getCurStampMS();
            console.log("11----------------------",callStartTime);
            //accetpTimer.start();
            //countTimer.start();
            calloutTimer.stop();
        }

        onCallResBusy:
        {
            player.stop();
            statip.height = 70
            statip.content = qsTr("对方忙线")
            statip.opacity = 1;
            if(phone.state === "ready")
                return;
            phone.state = "ready"
//            statip.height = 70
//            statip.content = qsTr("对方忙线")
//            statip.opacity = 1;
            recordStaus = 2
            calloutTimer.stop();
            sendApiAddOneCallRecord();

            res = {};
            res["state"] = "busy"
            if(isCallout === true)
            {
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
            }
            else
            {
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
            }
        }

        onCallHangup:
        {
            player.stop();
            if(phone.state === "ready")
                return;
            if(phone.state === "calling")
            {
                countTimer.stop();
                recordStaus = 3
                statip.content = qsTr("对方已挂断")
            }
            else
            {
                recordStaus = 0
                statip.content = qsTr("对方已拒绝")

                res = {};
                res["state"] = "reject"
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);

            }

            sendApiAddOneCallRecord();
            calloutTimer.stop();
            phone.state = "ready"
            statip.height = 70
            statip.opacity = 1;
        }

        onCallTimeout:
        {
            player.stop();
            if(phone.state === "ready")
                return;
            phone.state = "ready"
            recordStaus = 1
            statip.height = 70
            statip.content = qsTr("对方无应答")
            statip.opacity = 1;
            sendApiAddOneCallRecord();
            calloutTimer.stop();
        }

        onCallIncomeingCancel:
        {
            player.stop();
            if(phone.state === "ready")
                return;
            onCallIncomeingCancelTimer.restart();

            res = {};
            res["state"] = "cancel"
            pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
        }

        onCallWhenIsTalking:
        {
            sslClient.sendApplyStatus(CallStatue.Call_busy);
            recordStaus = 2
            isCallout = false;
            sendApiAddOneCallRecord();

            res = {};
            res["network"] = "wifi";
            res["state"] = "busy"
            if(isCallout === true)
            {
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
            }
            else
            {
                pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
            }
        }

        onCallComeing:
        {
            if(phone.state !== "ready")
            {
                console.log("tttttttttttttttt",phone.state)
                sslClient.sendApplyStatus(CallStatue.Call_busy);
                recordStaus = 2
                isCallout = false;
                sendApiAddOneCallRecord();

                res = {};
                res["state"] = "busy"
                if(isCallout === true)
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_OUT,res);
                }
                else
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
                }
            }
            else
            {
                phone.state = "incoming"
                main.bEnterPhoneFormOut = false;
                calloutTimer.stop();
            }

        }
    }


    Timer {
        id: onCallIncomeingCancelTimer
        interval: 300;
        running: false;
        repeat: false

        onTriggered:
        {
            phoneA2BManager.stopAgoraThread();
            recordStaus = 4
            isCallout = false;
            haveRedIcon = true
            phone.state = "ready"
            statip.height = 70
            statip.content = qsTr("对方已取消")
            statip.opacity = 1;
            sendApiAddOneCallRecord();

            res = {};
            res["state"] = "time out"
            pingManager.addPingData(PingDefine.PING_EVENT_CALL_COME,res);
        }
    }

    Connections {
        target: dataManager;
        onSig_netLive:
        {
            if(sta === false)
            {
                statip.height = 70
                statip.content = qsTr("网络已断开")
                statip.opacity = 1;

                if(phone.state === "ring")
                {           
                    calloutTimer.stop();
                    phone.state = "ready"
                }
            }
        }

    }
    function initAudio()
    {
        if(phoneA2BManager.agoraIsStarted())
        {
            var v = phoneA2BManager.getPlayoutVolumn();
            console.log("get getPlayoutVolumn = ", v);
            if(v <=0)
                v = 0;
            volume.slider.value = v;
            //devManager.setPhoneOutVolumn(v);
            if(v > 0 && v <= 50)
            {
                img.source= "qrc:/images/control_icon_volume_low.png"
            }
            else if(v > 50)
            {
                img.source= "qrc:/images/soundon.png"
            }
            else
            {
                img.source= "qrc:/images/soundoff.png";
            }
        }
    }

    function initPhoneRecords()
    {
        var count = phoneA2BManager.getPhoneRecordsCount();
        if(recordPage.getRecordCount() === count )
            return;

        console.log("update records")
        recordPage.clearRecords();
        for(var i=0; i< count;i++)
        {
            var data_index = phoneA2BManager.getPhoneRecordByIndex(i);
            recordPage.addOneRecord(data_index["callTime"],data_index["isCallout"], data_index["isTimeout"]);
        }
    }


    Timer
    {
        id:initTimer
        repeat: false
        running: false
        interval: 50
        onTriggered:
        {
            btncall.enabled = true
            pingManager.addPingData(PingDefine.PING_EVENT_CALL_ENTER);
            formOrTo.text = devManager.getCurPareName();
            if(main.bEnterPhoneFormOut === true)
            {
                apiNetWork.sendApiGetCallRecords();
                apiNetWork.sendApiGetCallMiss();
                state = "incoming"

                main.bEnterPhoneFormOut = false;
            }
            else
            {
                if(dataManager.getLive())
                {
                    if(devManager.isLogin() === false)
                    {
                        qr.visible = true;
                    }
                    else
                    {
                        apiNetWork.sendApiGetCallRecords();
                        apiNetWork.sendApiGetCallMiss();
                        sslClient.setupSecureSocket();
                        sslClient.secureConnect();
                    }
                }
                else
                {
                    netWarnDig.open();
                }

            }

        }
    }

    Component.onCompleted:
    {
        dataManager.setUIMode(PageStatus.UI_Phone);
        initTimer.start();
    }

    Component.onDestruction:
    {
        engineSocket.sendEnableSysAutoOffScreen(true);
        devStateMonitor.setDevState(DevStatus.DevState_Normal);
        dataManager.setUIMode(PageStatus.UI_Main);
        phoneA2BManager.adjustPublishVolumn(85);
        phoneA2BManager.stopAgoraThread();
        //phoneA2BManager.muteLocalAudio(false)
        devManager.saveConfigFile();
        main.bEnterPhoneFormOut = false;
        sslClient.closeSocket();
        phoneA2BManager.setTalking(false);
        player.stop();
    }

}
