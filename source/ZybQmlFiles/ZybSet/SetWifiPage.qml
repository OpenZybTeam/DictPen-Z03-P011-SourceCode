import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "./"
import "../Style"
import "../Global"
import "../ZybStore"
import DevConnection.StatusDefine 1.0
import com.zyb.PingDefine 1.0

Rectangle {
    id:wifiInfo
    property string curWifi : wifiManager.getLastConnString()
    property bool isConnecting : false
    property string applyType: "set"
    property int curConnectIndex : 0
    signal backTo();
    signal wifiConnected();

    color: Style.mainbgColor



    function getCurStatus()
    {
        switch(wifiManager.getStatus())
        {
        case ConnectStatus.Status_Close:
            return "close"
        case ConnectStatus.Status_Scaning:
            return "scaning"
        case ConnectStatus.Status_Connecting:
            return "connecting"
        }
    }

    state: wifiManager.getStatus() === ConnectStatus.Status_Close ? "close":"scaning"

    states: [
        State {
            name: "close"
            StateChangeScript {
                script: {
                    console.log("close state")
                }
            }
        },
        State {
            name: "scaning"
            StateChangeScript {
                script: {
                    console.log("scaning state")
                    //                    scantimer.start();
                    //                    console.log("scantimer.start()")
                }
            }
        },

        State {
            name: "connecting"
            StateChangeScript {
                script: {
                    console.log("connecting state")
                }
            }
        },

        State {
            name: "scanResult"
            StateChangeScript {
                script: {
                    console.log("scanResult state")
                }
            }
        },

        State {
            name: "scanNoResult"
            StateChangeScript {
                script: {
                    console.log("scanNoResult state")
                }
            }
        }
    ]


    RotationImage
    {
        id:img
        source: "qrc:/images/setLoading46x44.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 28
        visible: wifiInfo.state === "scaning"
        z:100
    }

    ZybText
    {
        id:searchtext
        text: qsTr("搜索中")
        font.pixelSize: Style.tipFontPixel
        anchors.horizontalCenter: img.horizontalCenter
        anchors.top:img.bottom
        anchors.topMargin: 8

        visible: wifiInfo.state === "scaning"
    }

    ZybText
    {
        id:noResulttext
        text: qsTr("无可用网络")
        font.pixelSize: Style.tipFontPixel
        anchors.centerIn: parent

        visible: wifiInfo.state === "scanNoResult"
    }

    property int connectTime : 0
    Timer
    {
        id:connectTimer
        interval: 1000
        repeat: true
        onTriggered:
        {
            connectTime++;
        }
    }

    function connectToSsid(ssid,key)
    {
        wifiManager.setStatus(ConnectStatus.Status_Connecting);
        resetStatus();
        view.model.get(view.currentIndex).state = "connecting";
        console.log("connectToSsid =",ssid,key);
        engineSocket.sendWifiConnect(ssid,key);
        connectTimer.start();
        connectTime = 0;
    }

    PopupDialog
    {
        id:ignoreDig
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)

        onLeftClicked:
        {
            ignoreDig.close();
        }

        onRightClicked:
        {
            ignore.visible = false
            console.log("sendWifiIgnore:",wifiManager.getLastConnString());
            engineSocket.sendWifiIgnore(wifiManager.getLastConnString());
            ignoreDig.close();
            view.visible = true;
        }
    }

    SetOneBtn
    {
        id:ignore
        anchors.fill: parent
        str1: qsTr("已连接: ")
        str2: wifiManager.getLastConnString()
        bottomBtnString:qsTr("忽略此网络")
        visible: false
        title:qsTr("WLAN")
        //z:2

        onBackToParent:
        {
            visible = false
            view.visible = true;
        }

        onBtnClicked:
        {
            ignoreDig.content = qsTr("要忽略")+str2+qsTr("网络吗");
            ignoreDig.open();

        }
    }

    ListModel {
        id:wifimodel
    }

    ListView {
        id:view
        focus: true
        anchors.fill: parent
        clip: true
        spacing: 10
        topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        visible: view.contentHeight > 0
        header:Item {
            id: header
            width: parent.width
            height: 65
            ZybBackButton{
                id:backButton
                anchors.top: parent.top
                anchors.left: parent.left

                onBackClicked: {
                    console.log("wifiInfo.applyType:",wifiInfo.applyType)
                    if(wifiInfo.applyType === "set"){
                        wifiInfo.visible = false
                        UILogic.backToSetPage();
                    }
                    else if(wifiInfo.applyType === "init"){
                        backTo();
                    }
                }

            }

            ZybText {
                text: qsTr("仅支持2.4G网络")
                font.pixelSize: Style.tipFontPixel
                color: "#999999"
                anchors.left: backButton.right
                anchors.leftMargin: 32
                anchors.verticalCenter: backButton.verticalCenter
            }

            ZybText {
                id: title
                text: qsTr("WLAN")
                font.styleName: "Bold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: backButton.verticalCenter
            }

            BasicSwitchButton
            {
                id:switchButton
                anchors.right: parent.right
                anchors.verticalCenter: backButton.verticalCenter
                state: wifiManager.getStatus() !== ConnectStatus.Status_Close ? "on":"off"
                onModelChanged:
                {
                    if(mode === true)
                    {

                        engineSocket.sendWifiOn();
                        wifiInfo.state = "scaning";
                    }
                    else
                    {
                        wifiInfo.state = "close";
                        engineSocket.sendWifiOff();
                        wifiManager.setIsReOpen(true);
                        view.model.clear();
                        wifimodel.clear();
                        pingManager.addPingData(PingDefine.PING_EVENT_SET_WIFI_CLOSE);
                    }

                    console.log("wifi model changed")
                }
            }

            onVisibleChanged: {
                if(visible){
                    switchButton.state = wifiManager.getStatus() !== ConnectStatus.Status_Close ? "on":"off"
                }
            }

        }

        delegate: WifiListItem {
            width: parent.width
            height: 70
            radius: 6
            ltext: model.ssid
            signalNum: model.signalnum
            hasKey: model.key ? 1:0
            state: model.state
            color: mouse.pressed ? Qt.darker("#993C3D42") : "#993C3D42"
            //opacity: 0.6
            MouseArea {
                id:mouse
                anchors.fill: parent
                onClicked:
                {
                    view.currentIndex = index
                    console.log(index);
                    if(wifiInfo.state === "scaning")
                    {
                        main.showTip(qsTr("wifi正在扫描中...,请稍等"))
                        return;
                    }

                    if(wifiManager.getStatus() === ConnectStatus.Status_Connecting)
                    {
                        main.showTip(qsTr("wifi正在连接中...,请稍等"))
                        return;
                    }

                    curWifi = model.ssid;

                    if(wifiManager.getLastConnString() === curWifi  && wifiManager.getStatus()=== ConnectStatus.Status_Connected)
                    {
                        ignore.str2 = curWifi;
                        ignore.visible = true;
                        view.visible = false;
                        return;
                    }

                    if(wifiManager.isSaved(model.ssid))
                    {
                        //curConnectIndex  = index;
                        connectToSsid(model.ssid,"");
                        return;
                    }

                    if(model.key === false)
                    {
                        //curConnectIndex  = index;
                        connectToSsid(model.ssid,"");
                    }
                    else
                    {
                        //curConnectIndex  = index;
                        vk.showKeyboard();
                    }
                }
            }

        }


        model: wifimodel

        ScrollIndicator.vertical: ScrollIndicator { }
    }

    Connections
    {
        target: vk;
        onCommitInput:
        {
            if(t1.length <8)
            {
                main.showTip(qsTr("密码输入错误"));
                return;
            }

            connectToSsid(curWifi,t1);
        }
    }

    function wifiOn(){
        engineSocket.sendWifiOn();
        wifiInfo.state = "scaning";
    }

    function wifiOff(){
        wifiInfo.state = "close";
        engineSocket.sendWifiOff();
        wifiManager.setIsReOpen(true);
        view.model.clear();
        wifimodel.clear();
    }

    function resetStatus()
    {
        for(var i=0;i<view.model.count;i++)
        {
            view.model.get(i).state = "normal"
        }
    }

    function initStatusExcep(row)
    {
        for(var i=0;i<view.model.count;i++)
        {
            if(i !== row)
                view.model.get(i).state = "normal"
        }
    }

    function getConnectModelIndex()
    {
        for(var i=0;i<view.model.count;i++)
        {
            console.log(view.model.get(i).ssid);
            if(view.model.get(i).ssid === wifiManager.getLastConnString())
                return i;
        }
        return -1;
    }

    function isHaveItem(ssid)
    {
        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).ssid === ssid)
                return i;
        }

        return -1;
    }

    function removeNotExistItem()
    {
        console.log("removeNotExistItem",wifilist);
        for(var i=0;i<view.model.count;i++)
        {
            if(wifilist.indexOf(view.model.get(i).ssid) < 0)
            {
                console.log("removeNotExistItem",view.model.get(i).ssid);
                view.model.remove(i);
                i--;
            }
        }
    }

    function updateConnectedItem()
    {
        resetStatus();
        var have = false;

        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).ssid === wifiManager.getLastConnString())
            {
                console.log("update connected item",i,wifiManager.getLastConnString() );
                view.model.get(i).state = "connected"
                have = true;

                if(i !== 0)
                {
                    console.log("move connected item to top");
                    wifimodel.move(i,0,1);
                }
            }
        }

        if(have === false)
        {
            addFirstConnectedItem();
        }

    }

    function addFirstConnectedItem()
    {
        var ssid = wifiManager.getLastConnString();
        if(ssid === "")
            return;
        var signalnum = wifiManager.getLastConnectedSignalNum();
        var haskey = wifiManager.getLastConnectedHasKey();

        wifimodel.insert(0,{"ssid":ssid,"key":haskey,"signalnum":signalnum,"state":"connected"});
    }

    Timer
    {
        id:refreshTimer
        interval: 30000; running: false; repeat: false
        onTriggered:
        {
            engineSocket.sendWifiScan();
            wifilist = [];
            console.log("refreshTimer triggered");
        }
    }

    property var wifilist:[]
    Connections
    {
        target: engineSocket
        onSig_wifiError:
        {
            main.showTip(err);
        }

        onSig_scanStart:
        {
            wifiInfo.state = "scaning";

        }

        onSig_scanEnd:
        {
            wifiManager.setIsReOpen(false);
            if(wifimodel.count === 0 && switchButton.state === "on")
            {
                wifiInfo.state = "scanNoResult"
            }
            else
            {
                if(wifiManager.getStatus() === ConnectStatus.Status_Connected)
                    updateConnectedItem();
            }

            console.info("scan end start refresh timer");
            removeNotExistItem();
            view.forceLayout();
            refreshTimer.restart();
        }

        onSig_wifiScaned: //ssid haskey signalnum
        {
            if(wifiInfo.state === "close")
                return;
            wifiInfo.state = "sacnResult"
            var status = "normal"
            wifilist.push(ssid);

            var vindex = isHaveItem(ssid);
            console.log("wifi scaned",ssid,vindex);
            if(vindex >= 0)
            {
                var beforestatus = wifimodel.get(vindex).state;
                wifimodel.set(vindex,{"key":haskey,"signalnum":signalnum,"state":""});
                wifimodel.set(vindex,{"key":haskey,"signalnum":signalnum,"state":beforestatus});
                view.forceLayout();
            }
            else
            {
                wifimodel.append({"ssid":ssid,"key":haskey,"signalnum":signalnum,"state":status});
            }

//            if(ssid === wifiManager.getLastConnString() && getConnectModelIndex() >=0)
//            {
//                var myindex = getConnectModelIndex();
//                wifiManager.setLastConnectedSignalNum(signalnum);
//                wifiManager.setLastConnectedHasKey(haskey);
//                wifimodel.set(myindex,{"key":haskey,"signalnum":signalnum});
//                return;
//            }

//            if(ssid === wifiManager.getLastConnString() && wifiManager.getStatus() === ConnectStatus.Status_Connected)
//            {
//                wifimodel.insert(0,{"ssid":ssid,"key":haskey,"signalnum":signalnum,"state":"connected"});
//            }
//            else
//            {
//                wifimodel.append({"ssid":ssid,"key":haskey,"signalnum":signalnum,"state":status});
//            }

        }

        onSig_wifiDisconnect: //val
        {
            console.log("onSig_wifiDisconnect");
            resetStatus();
            connectTimer.stop();
        }

        onSig_wifiDisconnectFailed:
        {
            main.showTip(qsTr("忽略网络失败"));
            connectTimer.stop();
        }

        onSig_wifiConnectSuccess:
        {
            connectTimer.stop();
            var res = new Object;
            res["time"] = connectTime;

            pingManager.addPingData(PingDefine.PING_EVENT_WIFI_CONNECT_LAST,res);
            connectTime = 0;
        }

        onSig_wifiConnected:
        {
            connectTimer.stop();
            console.log("------------------------------------- onSig_wifiConnected")
            if(wifiManager.getStatus() === ConnectStatus.Status_Close)
            {
                return;
            }

            console.log("onSig_wifiConnected");
            updateConnectedItem();
            wifiConnected();
        }

        onSig_wifiConnectFailed:
        {
            connectTimer.stop();
            if(wifiManager.getStatus() === ConnectStatus.Status_Close)
            {
                return;
            }

            console.log("onSig_wifiConnectFailed");
            resetStatus();
            main.showTip(qsTr("网络连接失败"));
        }

        onSig_wifiStatusChanged:
        {
            connectTimer.stop();
//            if(sta === 1)
//            {
//               resetStatus();
//            }
        }

    }

    onVisibleChanged:{
        if(visible){
            GlobalProperty.isWifiPageVisible = true;
        }
        else{
            GlobalProperty.isWifiPageVisible = false;
        }
    }
    Component.onCompleted:
    {
        GlobalProperty.isWifiPageVisible = true;
        console.log("Component.onCompleted  ",wifiManager.getStatus())
        if(wifiManager.getStatus() !== ConnectStatus.Status_Close)
        {
            engineSocket.sendWifiScan();
            if(wifiManager.getStatus() === ConnectStatus.Status_Connected)
            {
                addFirstConnectedItem();
            }
        }

    }

    Component.onDestruction:{
        GlobalProperty.isWifiPageVisible = false;
    }
}
