import QtQuick 2.0
import QtQuick.Controls 2.3
import DevStateMonitor.DevStateDefine 1.0
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybSet"

Item {
    id:root
    property var pageType: "initpage"
    property var pageState: 0
    property var prePageState: 0
    property var isOverTime: false
    property var is4g: true
    property var f4OnTimes: 0

    state: "netselect"
    states: [
        State {
            name: "agreement"
        },

        State {
            name: "netselect"
            StateChangeScript {
                script: {
//                    mtimer.running = true;
                }
            }
        },

        State {
            name: "inittip"
            StateChangeScript {
                script: {
//                    mtimer.running = true;
                }
            }
        },

        State {
            name: "wifi"
            StateChangeScript {
                script: {
//                    mtimer.running = true;
                }
            }
        },

        State {
            name: "login"
            StateChangeScript {
                script: {
//                    mtimer.running = false;
                }
            }

        },
        State {
            name: "guide"
            StateChangeScript {
                script: {
//                    mtimer.running = false;
                }
            }

        }
    ]

    Timer{
        id:loginTimer
        interval: 240000
        running: false
        triggeredOnStart: false
        repeat: false
        onTriggered: {
            isOverTime = true;
            engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
            wifiPage.wifiOff();
            engineSocket.send4GOff();
            if(root.is4g){
                setTip(qsTr("4G连接超时，请切换为WLAN再次激活"));
            }
            else{
                setTip(qsTr("WLAN连接超时，请切换为4G再次激活"));
            }
        }
    }

    Timer{
        id:fgTimer
        interval: 10000
        running: false
        triggeredOnStart: false
        repeat: false
        onTriggered: {
            if(f4OnTimes < 3){
                f4OnTimes = f4OnTimes + 1;
                engineSocket.send4GOff();
                UILogic.sleep(2000);
                engineSocket.send4GOn();
                fgTimer.start();
            }
        }
    }

    Timer{
        id:errorSendTimer
        interval: 1000
        running: false
        triggeredOnStart: false
        repeat: false
        onTriggered: {
            engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
            wifiPage.wifiOff();
            engineSocket.send4GOff();
        }
    }



    AgreementPage{
        id:agreementPage
        visible: root.state === "agreement"
        anchors.fill: parent
        onToNext: {
            root.state = "netselect"
//            engineSocket.send4GOn();
        }
    }

    NetSelectPage{
        id:netselectPage
        visible: root.state === "netselect"
        anchors.fill: parent

        onBack: {
            root.state = "agreement"
        }

        onToNext: {
            root.is4g = is4g
            engineSocket.sendEnableSysAutoOffScreen(false);
            if(is4g){
                engineSocket.send4GOn();
                fgTimer.start();
                loginTimer.running = true;
                root.state = "inittip"
                tipPage.state = "loading"
            }
            else{
//                engineSocket.sendWifiOn();
                root.state = "wifi"
            }
        }
    }

    InitTipPage{
        id:tipPage
        visible: root.state === "inittip"
        anchors.fill: parent
        onBack: {
            isOverTime = false;
            root.state = "netselect"
        }
    }

    SetWifiPage{
        id:wifiPage
        applyType: "init"
        visible: root.state === "wifi"
        anchors.fill: parent
        onBackTo: {
            root.state = "netselect"
            wifiOff();
        }

        onWifiConnected: {
            if(root.state === "wifi"){
                root.state = "inittip"
                tipPage.state = "loading"
                loginTimer.running = true;
            }

        }
    }

    LoginPage{
        id:loginPage
        visible: root.state === "login"
        anchors.fill: parent
//        source: "file:///"+currentPath + "/qr.png"
        onToNext: {
            root.state = "guide"
        }

//        onToPre: {
//            root.state = "wifi"
//        }

        onQrSuccess: {
            if(!visible)
                return;
            root.state = "guide"
        }
    }

    GuidePage{
        id:guidePage
        visible: root.state === "guide"
        anchors.fill: parent
        onToNext: {
            devManager.setInitStatus(2);
            devStateMonitor.setDevState(DevStatus.DevState_Normal);
            engineSocket.sendEnableSysAutoOffScreen(true);
            UILogic.backToHome();
        }

        onToPre: {
            root.state = "login"
        }
    }

    Component.onCompleted: {
        engineSocket.sendEnableSysAutoOffScreen(false);
        if(devManager.getInitStatus() === 0){
            engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
            wifiPage.wifiOff();
            engineSocket.send4GOff();
            state = "netselect";
        }
        else if(devManager.getInitStatus() === 1){
            state = "guide";
        }
    }

    Connections {
        target: dataManager;
        onSig_wifiNetOnline:{
            if(root.isOverTime === true || root.isOverTime){
                console.log("isOverTime:",isOverTime)
                return;
            }
            if(status === true)
            {
                engineSocket.sendEnableSysAutoOffScreen(false);
                apiNetWork.sendGetSysTime();
//                if(root.state !== "guide"){
//                    apiNetWork.sendApiLogin();
//                }
            }
//            else
//            {
//                setTip(qsTr("Wifi联网失败，请切换为4G再次激活"));
//            }
        }

        onSig_4gNetOnline:{
//            f4OnTimes = 0;
            fgTimer.stop();
            f4OnTimes = 4;
            if(root.isOverTime === true || root.isOverTime){
                console.log("isOverTime:",isOverTime)
                return;
            }
            if(status === true)
            {
                engineSocket.sendEnableSysAutoOffScreen(false);
                apiNetWork.sendGetSysTime();
//                if(root.state !== "guide"){
//                    apiNetWork.sendApiLogin();
//                }

            }
//            else
//            {
//                engineSocket.send4GOff();
//                setTip(qsTr("4G联网失败，请切换为Wifi再次激活"));
//            }
        }
    }

    Connections{
        target: engineSocket
        onSig_4gConnected:{
            fgTimer.stop();
        }
    }

    Connections{
        target: apiNetWork
        onSig_loginSuccess:{
            console.log()<<"onSig_loginSuccess+++++++++++++++++++++++++++";
            var authRes = QueryWordManager.autherInit();
            console.log()<<"onSig_loginSuccess+++++++++++++++++++++++++++"<<authRes;
            if(authRes === 8700 || authRes === 8701 || authRes === 8702 || authRes === 8703 || authRes === 20210010 || authRes === 20210101
                    || authRes === 20210102 || authRes === 10001){
                authRes = QueryWordManager.autherInit();
            }
            if(authRes !== 0){
//                engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
//                wifiPage.wifiOff();
//                engineSocket.send4GOff();
                apiNetWork.sendErrorMonitorStr("auth_error",authRes);
                errorSendTimer.start();
                if(authRes === 8700 || authRes === 8701 || authRes === 8702 || authRes === 8703 || authRes === 20210101
                        || authRes === 20210102 || authRes === 10001){
                    setTip(qsTr("网络不稳鉴权失败") + authRes + qsTr("\n请返回切换网络或使用手机热点重试"));
                }
                else{
                    setTip(qsTr("鉴权失败错误码：") + authRes + qsTr("\n设备SN:") + devManager.getSN() + qsTr("\n请联系客服"));
                }
//                UILogic.showTip("鉴权失败，请检查网络是否连通")
                return;
            }
            else{
                var xfDeviceId = devManager.getXFDeviceId();
                if(xfDeviceId.length > 0){
                    apiNetWork.sendErrorMonitorStr("xfDeviceId",xfDeviceId);
                }
                loginTimer.running = false;
                root.state = "login"
                devManager.setInitStatus(1);
                if(root.state === "guide")
                    return;
                console.log()<<"onSig_loginSuccess+++++++++++++++++++++++++++"<<3;

            }
        }

        onSig_recvErr:{
            apiNetWork.sendErrorMonitorStr("login_error",code);
            errorSendTimer.start();
//            engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
//            wifiPage.wifiOff();
//            engineSocket.send4GOff();
//            loginTimer.running = false;
            setTip(qsTr("激活失败错误码：") + code + qsTr("\n设备SN:") + devManager.getSN() + qsTr("\n请联系客服"))
//            UILogic.showTip(qsTr("激活失败，请检查网络是否连通"))
        }

        onSig_netTimeHaveSet:{
            if(root.state !== "guide"){
                console.log()<<"onSig_netTimeHaveSet+++++++++++++++++++++++++++";
                var strSn = devManager.getSN();
                if(strSn.length < 18){
                    apiNetWork.sendErrorMonitorStr("sn_error",507);
                    errorSendTimer.start();
                    setTip(qsTr("激活失败错误码：507") + qsTr("\n设备SN获取失败") + qsTr("\n请联系客服"))
//                    engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
//                    wifiPage.wifiOff();
//                    engineSocket.send4GOff();
                    return;
                }
                var strSecret = devManager.getSecret()
                if(strSecret.length < 32){
                    apiNetWork.sendErrorMonitorStr("secret_error",508);
                    errorSendTimer.start();
                    setTip(qsTr("激活失败错误码：508") + qsTr("\n设备Secret获取失败") + qsTr("\n设备SN:") + devManager.getSN() + qsTr("\n请联系客服"))
//                    engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
//                    wifiPage.wifiOff();
//                    engineSocket.send4GOff();
                    return;
                }
                console.log("onSig_netTimeHaveSet sendApiLogin");
                apiNetWork.sendApiLogin();
            }
        }
    }

    function setTip(strTip){
        loginTimer.running = false;
        root.state = "inittip"
        tipPage.state = "tip"
        tipPage.tipText = strTip;
    }
}
