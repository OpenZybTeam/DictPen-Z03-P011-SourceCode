import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import com.zyb.PingDefine 1.0
Rectangle {

    id:root
    color: Style.mainbgColor

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        onBackClicked: {
            root.visible = false
            UILogic.backToSetPage();
        }

    }


    ZybText {
        id: title
        text: qsTr("蜂窝网络")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
        font.pixelSize: Style.normalFontPixel
        font.styleName: "Bold"
    }

    BasicSwitchButton
    {
        id:switchButton
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: backButton.verticalCenter
        state: "on"
        onModelChanged:
        {
            var res = new Object;
            if(mode === true)
            {
                engineSocket.send4GOn();
                res["state"] = "on"
            }
            else
            {
                engineSocket.send4GOff();
                res["state"] = "off"
            }

            pingManager.addPingData(PingDefine.PING_EVENT_SET_4G_SWITCH,res);
            console.log("change 4g mode",mode);
        }
    }


    Connections
    {
        target: apiNetWork;
        onSig_getFlow4GSuccess:
        {
            console.info("refresh 4g page")
            initPageData();
        }
    }

    ZybText {
        id: flowRemainDate
        text: qsTr("流量有效期：")
        x:120
        y:Style.highVersion ? 85:95
        visible: false
    }

    ZybText {
        id: flowRemainDays
        text: qsTr("剩余时间：天")
        x:Style.highVersion ?570:470
        y:Style.highVersion ?85:95
        visible: false
    }

    ZybText {
        id: usedFLow
        text: qsTr("已使用流量：GB")
        anchors.top: flowRemainDate.bottom
        anchors.topMargin: 15
        anchors.left: flowRemainDate.left
        visible:false
    }

    ZybText {
        id: unUsedFlow
        text: qsTr("流量剩余：GB")
        anchors.top: flowRemainDays.bottom
        anchors.topMargin: 15
        anchors.left: flowRemainDays.left
        visible: false
    }

    ZybText {
        id: nonetwork
        text: qsTr("网络未连接，请先连接网络")
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -12
        visible: false
    }

    ZybText {
        id: overdue
        text: qsTr("流量服务不可用")
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -12
        visible: false
    }

    ZybText {
        id: tip1
        font.pixelSize: Style.mainModePixel
        color: "#999999"
        text: qsTr("VIP权益将在10天后过期，请在（作业帮智能App或设备端）充值续费")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: tip2.top
        anchors.bottomMargin: 8
    }

    ZybText {
        id: tip2
        font.pixelSize: Style.mainModePixel
        color: "#999999"
        text: qsTr("*流量到期后，182天内不续费设备将不可再开通流量服务")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 9
    }

    function initPageData()
    {
        usedFLow.visible = true;
        unUsedFlow.visible = true;
        flowRemainDate.visible = true;
        flowRemainDays.visible = true;
        tip1.visible = (devManager.getFlow4GAlertMsg().length > 0);
        tip1.text = devManager.getFlow4GAlertMsg();
        overdue.visible = false;
        if(devManager.getFlow4GAlertMsg().length > 0)
        {
            devManager.set4GRedEntered();
        }

        console.log( "devManager.getGprsStatus()",devManager.getGprsStatus())
        if(devManager.getGprsStatus()) //1： 已关闭 0：正常
        {
            console.log( "enter devManager.getGprsStatus()")
            usedFLow.visible = false;
            unUsedFlow.visible = false;
            flowRemainDate.visible = false;
            flowRemainDays.visible = false;
            overdue.visible = true;
            overdue.text = devManager.getFlow4GAlertMsg();
            nonetwork.visible = false;
            tip1.visible = false;
            devManager.set4GRedEntered();
            return;
        }

        var used = (devManager.getFlowUsedTraffic()/1024/1024);
        var ramin = (devManager.getFlowRaminTraffic()/1024/1024);
        console.info("used=",used,"ramin=",ramin);
        if(used > 1024)
        {
            usedFLow.text = qsTr("已使用流量：")+(used/1024).toFixed(1)+"GB";
        }
        else
        {
            usedFLow.text = qsTr("已使用流量：")+used.toFixed(1)+"MB";
        }

        if(ramin > 1024)
        {
            unUsedFlow.text = qsTr("流量剩余：")+(ramin/1024).toFixed(1)+"GB";
        }
        else
        {
            unUsedFlow.text = qsTr("流量剩余：")+ramin.toFixed(1)+"MB";
        }

        flowRemainDate.text = qsTr("流量有效期：")+devManager.getFlowExpireData();
        flowRemainDays.text = qsTr("剩余时间：")+devManager.getFlowRemainDays()+qsTr("天");

        unUsedFlow.visible = devManager.getShowRemainTraffic();
        usedFLow.visible = devManager.getShowRemainTraffic();
        nonetwork.visible = false

    }

    Component.onCompleted:
    {
        switchButton.state = (flow4GManager.isOpen()===true?"on":"off");
        if(dataManager.getLive())
        {
            initPageData();
        }
        else
        {
            nonetwork.visible = true;
            tip1.text = devManager.getFlow4GAlertMsg();
        }

    }

}
