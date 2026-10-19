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
        text: qsTr("亮度")
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

    property  var res : new Object;

    BasicSlider
    {
        id : volunm
        width: 640
        height: 70
        from: 0
        to:1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset : 6
        leftImageSource: "qrc:/images/control_icon_bright_low.png"
        rightImageSource: "qrc:/images/control_icon_bright_high.png"
        rightImageVisible:true
        incompleteColor: "#993C3D42"  //Qt.rgba(60,61,66)
        value: devManager.getLightVal();
        onPositionChanged:
        {
            engineSocket.sendLightChanged(position);
        }
        //opacity: 0.6
        property int num: 0
        onPressedChanged:
        {
            num++;
            if(num%2 === 0)
            {
                res = {};
                res["value"] = position;
                pingManager.addPingData(PingDefine.PING_EVENT_SET_CHANGE_LIGHT,res);
            }
        }
    }


    RowLayout
    {
        id:bottomLay
        width: volunm.width
        x: volunm.x+20
        y: volunm.y+90
        ZybText
        {
            text: qsTr("自动息屏：")
        }

        BasicRaidoButton
        {
            id: ms30
            checked: devManager.getLightIndex() === 1
            mytext: qsTr("30秒")
            implicitWidth: 140
            autoExclusive: true

            //onCheckedChanged:
            onToggled:
            {
                if(checked === true)
                {
                     console.log("redio 1 checked");
                    devManager.setLightIndex(1);
                    engineSocket.sendOffScreenTime(30);
                    res = {};
                    res["time"] = 30;
                    pingManager.addPingData(PingDefine.PING_EVENT_SET_CHANGE_AUTO_SCREEN,res);
                }
            }
        }

        BasicRaidoButton
        {
            id:ms60
            checked: devManager.getLightIndex() === 2
            mytext: qsTr("1分钟")
            implicitWidth: 140
            autoExclusive: true
            //onCheckedChanged:
            onToggled:
            {
                if(checked === true)
                {
                     console.log("redio 2 checked");
                    devManager.setLightIndex(2);
                    engineSocket.sendOffScreenTime(60);
                    res = {};
                    res["time"] = 60;
                    pingManager.addPingData(PingDefine.PING_EVENT_SET_CHANGE_AUTO_SCREEN,res);
                }
            }
        }

        BasicRaidoButton
        {
            id:ms180
            checked: devManager.getLightIndex() === 3
            mytext: qsTr("3分钟")
            implicitWidth: 140
            autoExclusive: true

            //onCheckedChanged:
            onToggled:
            {
                if(checked === true)
                {
                     console.log("redio 3 checked");
                    devManager.setLightIndex(3);
                    engineSocket.sendOffScreenTime(180);
                    res = {};
                    res["time"] = 180;
                    pingManager.addPingData(PingDefine.PING_EVENT_SET_CHANGE_AUTO_SCREEN,res);
                }
            }
        }

    }


    Component.onCompleted:
    {
        var lightval = devManager.getLightIndex();
        switch(lightval)
        {
        case 1:
        case 0:
            ms30.checked = true;
            break;
        case 2:
            ms60.checked = true;
            break;
        case 3:
            ms180.checked = true;
            break;
        default:
            ms30.checked = true;
            break;
        }
    }
}
