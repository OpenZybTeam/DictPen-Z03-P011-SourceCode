import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Style"
import "../Funcs/UILogics.js" as UILogic

Rectangle {
    id:root
    //anchors.fill: parent
    color: Style.mainbgColor

    signal backToParent


    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            backToParent();
        }
    }


    ZybText
    {
        id:textAdb
        text: "ADB"
        anchors.top: backButton.bottom
        anchors.topMargin : 20
        anchors.left :backButton.left


    }

    BasicSwitchButton
    {
        id:adbBtn
        x:200
        anchors.verticalCenter: textAdb.verticalCenter
        onModelChanged:
        {
            if(mode === true)
            {
                devManager.openADB();
            }
            else
            {
                devManager.closeADB();
            }

            devManager.saveConfigFile();
            main.showTip(qsTr("请重启生效"));
        }
    }


    ZybText
    {
        id:textServer
        text: qsTr("测试服")
        anchors.top: textAdb.bottom
        anchors.topMargin : 40
        anchors.left :backButton.left

    }

    BasicSwitchButton
    {
        id:testServerBtn
        x:200
        anchors.verticalCenter: textServer.verticalCenter
        onModelChanged:
        {
            devManager.setIsOnlineServer(!mode);
            apiNetWork.serverChanged();
            apiNetWork.sendApiLogin();
            devManager.saveConfigFile();
            main.showTip(qsTr("请重启生效"));
        }
    }

    ZybText
    {
        id:textVersion
        text: qsTr("编译日期:   ") + devManager.getBuildTime()
        anchors.verticalCenter: textAdb.verticalCenter
        x:350

    }

    ZybText
    {
        id:textV2
        text: qsTr("当前版本:   ") + devManager.getVersion()
        anchors.verticalCenter: testServerBtn.verticalCenter
        x:350
    }


    Component.onCompleted:
    {
        adbBtn.state = (devManager.getADBStatus()=== true?"on":"off");
        testServerBtn.state = (devManager.getIsOnlineServer()=== true?"off":"on");
    }

}
