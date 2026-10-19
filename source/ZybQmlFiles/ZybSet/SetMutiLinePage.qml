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
        text: qsTr("多行扫描")
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
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
            if(mode === true)
            {
                devManager.setScanLineMode(true);
                pingManager.addPingData(PingDefine.PING_EVENT_SET_MUTILINE_ON);
            }
            else
            {
                devManager.setScanLineMode(false);
                pingManager.addPingData(PingDefine.PING_EVENT_SET_MUTILINE_CLOSE);
            }

            console.log("muti line model changed")
        }
    }


    ZybText {
        id: content
        text: qsTr("开启后，查词模式下抬起笔头2秒内再次扫描,")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset : 5
    }

    ZybText {
        id: content2
        text: qsTr("将合并两次扫描内容")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: content.bottom
        anchors.topMargin: 9

    }

    Component.onCompleted: {
        if(devManager.getScanLineMode()){
            switchButton.state = "on"
        }
        else{
            switchButton.state = "off"
        }
    }

}
