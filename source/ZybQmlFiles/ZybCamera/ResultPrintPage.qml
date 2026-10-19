import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtWebView 1.1
import QtWebChannel 1.0
import QtWebEngine 1.4
import "../ZybControls"
import "../ZybSet"
import DataManager.PageModeDefine 1.0
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0
import RemoteDataManager.PermissionDefine 1.0
import BtManager.BtStatusDefine 1.0
import MMPrintManager.MMPrintStatusDefine 1.0
import "../Funcs/UILogics.js" as UILogic
import "../Global"
import "../Style"

Item {
    id: root
    anchors.fill: parent
    z:1000
    property bool printHtmlLoaded : false
    property bool muti:false
    signal backClicked
    signal printStart
    signal h5LoadFinished
    property  var res : new Object;

    PopupDialog
    {
        id:tipDig
        x:(parent.width - width) / 2
        y:(parent.height - height) / 2
        z:1000
        content:qsTr("F2S在此设备仅支持4寸耗材打印")
        rightTxt:qsTr("知道了")
        leftTxtVisble: false
        onLeftClicked:
        {
            devManager.setF2STipTimes(devManager.getF2sTipTimes() + 1);
            devManager.saveConfigFile();
            close();
        }

        onRightClicked:
        {
            devManager.setF2STipTimes(devManager.getF2sTipTimes() + 1);
            devManager.saveConfigFile();
            if(mmPrintManager.getStatus() !== MMConnectStatus.MM_Connected){
                printH5Object.printState(false);
                close();
                return;
            }

            printH5Object.printState(true);
            close();
        }
    }

    QtObject {
        id: printH5Object

        // 注册方法 1
        // 使用注册方法 2 时不需要此行代码
        WebChannel.id: "foo" //这个 id 可以在 html 中使用

        // 以下为 JavaScript 代码可以访问的信号、方法和属性
        signal webLoadFinshed();
        signal addPrintContent(string message)
        signal addPrintListContent(string message)
        signal printState(bool sta)



        function back()
        {
            backClicked();
        }

        function getPrintStates()
        {

            if(mmPrintManager.getStatus() !== MMConnectStatus.MM_Connected){
                printState(false);
                return;
            }

            //Paperange_F2S
            console.log("LastConnBtSsid:",mmPrintManager.getLastConnBtSsid(),devManager.getF2sTipTimes())
            if(mmPrintManager.getLastConnBtSsid() === "Paperang_F2S" && devManager.getF2sTipTimes() < 3){
                tipDig.open();
                return;
            }

            printState(true);
        }

        function openConnectCompent()
        {
            console.log("mm status:",mmPrintManager.getStatus())
            mmconnectComponent.createObject(root,{isSetMode:false});
            apiResBusyIndicator.visible = false;
        }

        function printImageData(data,ismuti,checklist)
        {
            console.log("printImageData",data.length)
            //api.setCurPrintMat(data);
            api.base64_string_2_img(data);
            apiResBusyIndicator.visible = false;
            res = {};
            res["muti"] = ismuti?"true":"false"
            res["course"] = api.getPrintCourseList();
            res["printItem"] = checklist;
            console.log("checklist =",checklist);
            pingManager.addPingData(PingDefine.PING_EVENT_PRINT_RES,res);
        }

        function loadFinish()
        {
            h5LoadFinished();
            showPrintWarnTip();
        }

        function printStart(){
            console.log("------------- print clicked");
            apiResBusyIndicator.visible = true;
            //loadTimer.running = true;
        }

        function selectedCheckbox(key)
        {
            if(key === "siludianbo")
            {
                showPrintWarnTip();
            }
        }

        function jslog(msg)
        {
            console.log(msg)
        }
    }

    function showPrintWarnTip()
    {
        var tip = api.getPrinTip();
        if(tip.length > 0)
        {
            main.showTip(tip);
        }
    }

    function startUpdatePrintHtml()
    {
        console.warn("startUpdatePrintHtml");
        if(printHtmlLoaded === false)
        {
            console.warn("print RetryTimer start");
            printRetryTimer.start();
            return;
        }

        if(devStateMonitor.getDevState() === DevStatus.DevState_Scaning
                || devStateMonitor.getDevState() === DevStatus.DevState_Cameraing )
        {
            console.warn("devStateMonitor.getDevState()",devStateMonitor.getDevState());
            webView.stop();
            return;
        }

        printH5Object.updateLatex("contentOthers",api.getOthers(curResultIndex));
        printH5Object.webLoadFinshed();
        //latexTimer.restart();

    }

    Timer{
        id:loadTimer
        repeat: false
        running: false
        interval: 10000
        onTriggered:
        {
            apiResBusyIndicator.visible = false;
        }
    }

    Timer
    {
        id: printRetryTimer
        repeat: false
        running: false
        interval: 1200
        onTriggered:
        {
            console.warn("retryTimer onTriggered");
            startUpdatePrintHtml();
        }
    }

    WebEngineView {
        id: printWebView;
        anchors.fill : parent
        url:"qrc:/print-preview.html"
        webChannel: WebChannel {
            id: webChannel
            registeredObjects: [printH5Object]
        }

        onLoadingChanged: {
            console.log("onLoadingChanged =",loadRequest.status);
            if (loadRequest.status === WebEngineView.LoadSucceededStatus
                    || loadRequest.status === WebEngineView.LoadFailedStatus
                    || loadRequest.status === WebEngineView.LoadStoppedStatus ) {

                printHtmlLoaded = true;
                if(loadRequest.status === WebEngineView.LoadSucceededStatus)
                {
                    console.log("muti=",muti)
                    if(muti)
                    {
                        var obj = api.getAllPrintData()
                        var res = JSON.stringify(obj);
                        printH5Object.addPrintListContent(res);
                    }
                    else
                    {
                        var obj2 = api.getPrintData();
                        var res2 = JSON.stringify(obj2);
                        printH5Object.addPrintContent(res2);
                    }


                }


                console.log("webview cache path:",printWebView.profile.cachePath)
            }

        }
    }

    Loading
    {
        id:apiResBusyIndicator
        anchors.centerIn: parent
        visible: false
        z:100
    }

    Component{
        id:mmconnectComponent
        SetMMPrintPage{
            anchors.fill: parent
        }
    }

    Connections{
        target: mmPrintManager
        onSig_sendImageStart:{
            loadTimer.running = true;
        }
        onSig_mmPrintStart:{
            UILogic.showTip(qsTr("发送成功"));
            apiResBusyIndicator.visible = false;
        }
        onSig_mmNormal:{
            UILogic.showTip(qsTr("喵喵机恢复了，正在打印中..."));
        }
    }


    Component.onCompleted:
    {
    }

    Component.onDestruction:
    {
        console.log("print Page onDestruction")
    }
}



