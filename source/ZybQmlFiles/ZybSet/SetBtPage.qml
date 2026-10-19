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
import BtManager.BtStatusDefine 1.0
import com.zyb.PingDefine 1.0

Rectangle {
    id:btInfo
    property string curBtMac : btManager.getLastConnBtMac()
    property string curBtSsid : ""
    property bool isConnecting : false
    property int curConnectIndex : 0
    property string strPaired: qsTr("已配对")
    property string strNotPaired: qsTr("可用设备")
    property bool isConnectedItem : false
    signal backToParent();
    signal btConnected();

    color: Style.mainbgColor



    function getCurStatus()
    {
        switch(btManager.getStatus())
        {
        case BtConnectStatus.Bt_Close:
            return "close"
        case BtConnectStatus.Bt_Scaning:
            return "scaning"
        case BtConnectStatus.Bt_Connecting:
            return "connecting"
        }
    }

    state: btManager.getStatus() === BtConnectStatus.Bt_Close ? "close":"scaning"

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


    ZybText
    {
        id:noResulttext
        text: qsTr("通信范围内没有搜索到蓝牙设备")
        font.pixelSize: Style.tipFontPixel
        anchors.centerIn: parent

        visible: btInfo.state === "scanNoResult"
    }

    Timer
    {
        id:connectTimer
        onTriggered:
        {
            if(btManager.getStatus() === BtConnectStatus.Bt_Connecting)
            {
                btManager.setStatus(BtConnectStatus.Bt_UnKown);
            }
        }
    }

    function connectToSsid(mac)
    {
        btManager.setStatus(BtConnectStatus.Bt_Connecting);
        resetStatus();
        view.model.get(view.currentIndex).state = "connecting";
        console.log("connectToBtSsid =",mac);
        engineSocket.sendBtConnect(mac);
        connectTimer.start();
    }

    PopupDialog
    {
        id:ignoreDig
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        isVertical:false
        btnWidth : 150
        closeBtnVisible:true
        onLeftClicked:
        {
            ignoreDig.close();
            if(isConnectedItem)
            {
                engineSocket.sendBtDisconnect();
            }
            else
            {
                connectToSsid(curBtMac);
            }
        }

        onRightClicked:
        {
            ignoreDig.close();
            engineSocket.sendBtIgnore(curBtMac);

        }
    }


    PopupDialog
    {
        id:errDig
        width: 580
        height: 220
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        isVertical:false
        btnWidth : 120
        closeBtnVisible:false
        content2Visible:true
        leftTxtVisble: false
        titleFontBold: true
        content: qsTr("蓝牙配对失败")
        content2: qsTr("请确定“") + curBtSsid +"”" +qsTr("已打开而且在通信范围内。")
        rightTxt: qsTr("好")


        onRightClicked:
        {
            errDig.close();
        }
    }

    ListModel {
        id:btmodel
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
                    if(btManager.getStatus() !== BtConnectStatus.Bt_Close)
                    {
                        console.log("sendBtScan(false)");
                        engineSocket.sendBtScan(false);
                    }
                    UILogic.backToSetPage();
                }

            }


            ZybText {
                id: title
                text: qsTr("蓝牙")
                font.styleName: "Bold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: backButton.verticalCenter
            }

            BasicSwitchButton
            {
                id:btswitchButton
                anchors.right: parent.right
                anchors.verticalCenter: backButton.verticalCenter
                state: btManager.getStatus() !== BtConnectStatus.Bt_Close ? "on":"off"
                onModelChanged:
                {
                    if(mode === true)
                    {
                        engineSocket.sendBtOn();
                        btInfo.state = "scaning";

                    }
                    else
                    {
                        btInfo.state = "close";
                        engineSocket.sendBtOff();
                        btManager.setIsReOpen(true);
                        view.model.clear();
                        btmodel.clear();
                    }

                }
            }

            onVisibleChanged: {
                if(visible){
                    btswitchButton.state = btManager.getStatus() !== BtConnectStatus.Bt_Close ? "on":"off"
                }
            }

            Connections
            {
                target: engineSocket
                onSig_btOn:
                {
                    if(!res)
                    {
                        btswitchButton.state = "off";
                        main.showTip(qsTr("打开蓝牙失败"));
                    }
                }
            }
        }

        section{
            //以哪个属性分组
            property: "group"
            //可以指定为完全字符串匹配或者首字母匹配
            criteria: ViewSection.FullString
            //分组标题
            delegate: Rectangle{
                width: ListView.view.width
                height: 70
                color: "transparent"
                radius: 6
                Text {
                    id: groupText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: 24
                    color: "#999999"
                    text: section //对应section.property指定的字段
                }

                RotationImage
                {
                    id: imgRefresh
                    source: "qrc:/images/connecting56x56.png"
                    running: visible
                    anchors.left: groupText.right
                    anchors.leftMargin: 30
                    anchors.verticalCenter: groupText.verticalCenter
                    duration: 1000
                    visible: section === strNotPaired
                }

            }
            //位置
            labelPositioning: ViewSection.InlineLabels
        }

        model: btmodel
        delegate: Rectangle {
            id:control
            width: parent.width
            height: (model.ssid.length > 0) ?70:0
            radius: 6
            state: model.state
            color: mouse.pressed ? Qt.darker("#993C3D42") : "#993C3D42"
            ZybText {
                id: ltext
                font.styleName: "Bold"
                text: model.ssid
                anchors.left: parent.left
                anchors.leftMargin: 33
                anchors.verticalCenter: parent.verticalCenter
                visible: model.ssid.length > 0
            }

            ZybText {
                id: rtext
                text: qsTr("连接中")
                color: "#FFFFFF"
                visible: control.state === "connecting" && model.ssid.length > 0
                anchors.right: imgLoading.left
                anchors.rightMargin: 9
                anchors.verticalCenter: parent.verticalCenter
            }

            ZybText {
                id: rtext2
                text: qsTr("未连接")
                color: "#FFFFFF"
                visible: control.state === "normal" && model.group === strPaired  && model.ssid.length > 0
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            RotationImage
            {
                id: imgLoading
                source: "qrc:/images/connecting56x56.png"
                running: visible===true
                duration: 1000
                visible: control.state === "connecting"  && model.ssid.length > 0

                anchors.right: parent.right
                anchors.rightMargin: 33
                anchors.verticalCenter: parent.verticalCenter
            }


            Image {
                id: imgStatus
                fillMode: Image.PreserveAspectFit
                clip: true
                source: "qrc:/images/wifi_set_connected.png"
                visible: control.state === "connected"  && model.ssid.length > 0
                anchors.right: parent.right
                anchors.rightMargin: 33
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id:mouse
                anchors.fill: parent
                onClicked:
                {
                    view.currentIndex = index
                    console.log(index,model.ssid);
                    if(btManager.getStatus() === BtConnectStatus.Bt_Connecting)
                    {
                        main.showTip(qsTr("蓝牙正在配对中...,请稍等"))
                        return;
                    }

                    curBtMac = model.mac;
                    curBtSsid = model.ssid;

                    if(btManager.getStatus()=== BtConnectStatus.Bt_Connected)
                    {
                        if(btManager.getLastConnBtMac() === curBtMac) //断开
                        {
                            isConnectedItem = true
                            ignoreDig.leftTxt = qsTr("断开连接")
                            ignoreDig.rightTxt = qsTr("忽略此设备")
                            ignoreDig.content = model.ssid;
                            ignoreDig.open();
                        }
                        else    //忽略
                        {
                            if(model.group === strPaired)
                            {
                                isConnectedItem = false
                                ignoreDig.leftTxt = qsTr("连接此设备")
                                ignoreDig.rightTxt = qsTr("忽略此设备")
                                ignoreDig.content = model.ssid
                                ignoreDig.open();
                            }
                            else
                            {
                                connectToSsid(model.mac);
                            }


                        }
                    }
                    else
                    {
                        if(model.group === strPaired)
                        {
                            isConnectedItem = false
                            ignoreDig.leftTxt = qsTr("连接此设备")
                            ignoreDig.rightTxt = qsTr("忽略此设备")
                            ignoreDig.content = model.ssid
                            ignoreDig.open();
                        }
                        else
                        {
                            connectToSsid(model.mac);
                        }
                    }
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }

    function isPairedItem(index)
    {
       return  view.model.get(index).group === strPaired
    }

    function getPairedItemCount()
    {
        var c=0;
        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).group === strPaired)
                c++;
        }

        return c;
    }

    function disconnected()
    {
        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).state === "connected")
            {
                view.model.get(i).state ="normal";
                break;
            }
        }

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
            if(view.model.get(i).mac === btManager.getLastConnBtMac())
                return i;
        }
        return -1;
    }

    function isHaveItem(mac)
    {
        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).mac === mac)
                return i;
        }

        return -1;
    }

    function removeItem(mac)
    {
        var index = btMacList.indexOf(mac);
        btMacList.splice(index,1);
        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).mac === mac )
            {
                console.log("removeItem",view.model.get(i).ssid);
                view.model.remove(i);
                break;
            }
        }
    }

    function updateConnectedItem()
    {
        resetStatus();
        var have = false;

        for(var i=0;i<view.model.count;i++)
        {
            if(view.model.get(i).mac === btManager.getLastConnBtMac())
            {
                console.log("update connected item",i,btManager.getLastConnBtMac() );
                if(view.model.get(i).group === strPaired )
                {
                    view.model.get(i).state = "connected"
                }
                else
                {
                    view.model.get(i).group = strPaired;
                    view.model.get(i).state = "connected"
                }


                have = true;

                if(i !== 0)
                {
                    console.log("move connected item to top");
                    btmodel.move(i,0,1);
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
        var mac = btManager.getLastConnBtMac();
        var ssid = btManager.getLastConnBtSsid();
        if(mac === "")
            return;

        btmodel.insert(0,{group: strPaired,"ssid":ssid,"mac":mac,"state":"connected"});
    }

    property var btMacList: []

    Connections
    {
        target: engineSocket
        onSig_btError:
        {
            main.showTip(err);
        }

        onSig_btOn:
        {
            if(res)
            {
                btMacList = [];
                btInfo.state = "scaning"
                btmodel.append({group:strNotPaired,"ssid":"","mac":"","state":""});
            }
            else
            {
                //btswitchButton.state = "off";
                //main.showTip(qsTr("打开蓝牙失败"));
            }
        }

        onSig_btOff:
        {
            btMacList = [];
            view.model.clear();
            btmodel.clear();
        }


        onSig_btScaned: //
        {
            if(btInfo.state === "close")
                return;
            btInfo.state = "sacnResult"
            var status = "normal"
            var sgroup = paired?strPaired:strNotPaired
            var vindex = isHaveItem(mac);
            console.log("bt scaned",ssid,mac,vindex);
            if(vindex < 0)
            {
                if(sgroup === strPaired)
                {
                    var count = getPairedItemCount();
                    if(mac === btManager.getLastConnBtMac() && btManager.getStatus()=== BtConnectStatus.Bt_Connected)
                    {
                        status = "connected";
                    }

                    btmodel.insert(count,{group: strPaired,"ssid":ssid,"mac":mac,"state":status});
                }
                else
                {
                    btmodel.append({group:sgroup,"ssid":ssid,"mac":mac,"state":status});
                }
                btMacList.push(mac);
            }

        }

        onSig_btRemoved:
        {
            removeItem(mac);
        }

        onSig_btDisconnect: //val
        {
            console.log("onSig_btDisconnect",val);
            resetStatus();
            connectTimer.stop();
        }

        onSig_btDisconnectFailed:
        {
            main.showTip(qsTr("断开蓝牙设备失败"));
            connectTimer.stop();
        }

        onSig_btConnected:
        {
            connectTimer.stop();
            if(btManager.getStatus() === BtConnectStatus.Bt_Close)
            {
                return;
            }

            console.log("onSig_BTConnected");
            updateConnectedItem();
            btConnected();

            pingManager.addPingData(PingDefine.PING_EVENT_SET_BT_CONNECT);
        }

        onSig_btConnectFailed:
        {
            connectTimer.stop();
            if(btManager.getStatus() === BtConnectStatus.Bt_Close)
            {
                return;
            }

            console.log("onSig_BTConnectFailed");
            resetStatus();
            errDig.open();
            //main.showTip(qsTr("蓝牙配对失败"));
        }

        onSig_btStatusChanged:
        {
            connectTimer.stop();
            if(sta === 1)
            {
                disconnected();
            }
        }

        onSig_btIgnore:
        {
            removeItem(mac);
        }

    }

    Timer
    {
        id:initTimer
        repeat: false
        running: false
        interval: 30
        onTriggered:
        {
            console.log("bt initTimer ",btManager.getStatus(),BtConnectStatus.Bt_Close)
            if(btManager.getStatus() !== BtConnectStatus.Bt_Close)
            {
                btmodel.append({group:strNotPaired,"ssid":"","mac":"","state":""});
                engineSocket.sendBtScan(true);
                if(btManager.getStatus() === BtConnectStatus.Bt_Connected)
                {
                    addFirstConnectedItem();
                }
            }
        }
    }

    Component.onCompleted:
    {
        initTimer.start();
    }

    Component.onDestruction:
    {
        console.log("bt page Component.onDestruction")
        btmodel.clear();
    }
}
