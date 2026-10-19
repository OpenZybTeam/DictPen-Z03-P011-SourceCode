import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Style"

Pane {
    id:root

    width: Style.gHeight
    height: Style.gWidth

    background: Rectangle{
        anchors.fill: parent
        color: Style.mainbgColor
    }

    property color itemBgColor: "#993C3D42"
    property string source : ""
    property var vmargin : 20
    property var hmargin :0

    signal backToParent
    signal qrSuccess()

    function init()
    {
        console.log("test")
    }

    ZybBackButton{
        id:backButton
        enabled: true
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: hmargin
        onBackClicked: {
            backToParent();
        }
    }

    ZybText
    {
        id:title
        text: qsTr("语音通话")

        font.styleName: "Bold"
        anchors.left : backButton.right
        anchors.leftMargin: 15
        anchors.verticalCenter: backButton.verticalCenter
    }

    ZybText
    {
        id:tip
        text: qsTr("登录后可以拨打语音电话给绑定的APP")
        width: parent.width-2*hmargin
        anchors.left : backButton.left
        anchors.top: backButton.bottom
        anchors.topMargin: vmargin
        color: "#999999"
        wrapMode: Text.Wrap
    }

    ZybText
    {
        id:tip2
        text: qsTr("登录步骤")
        width: parent.width-2*hmargin
        font.styleName: "Bold"
        anchors.left : backButton.left
        anchors.top: tip.bottom
        anchors.topMargin: vmargin*3

    }


    ZybText
    {
        id:text1
        width: parent.width-2*hmargin
        //lineHeight: 40
        text: qsTr("1.手机扫描二维码下载作业帮智能App\n2.打开作业帮智能App->点击设备管理->立即添加->扫描二维码绑定")
        font.pixelSize: Style.tipFontPixel
        lineHeight: 1.3
        anchors.top: tip2.bottom
        anchors.topMargin : 9
        anchors.left : tip2.left
        wrapMode: Text.Wrap
    }


    Rectangle
    {
        id:bg
        color: "#FFFFFF"
        width: Style.highVersion ?228:238
        height: width
        radius: 6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: text1.bottom
        anchors.topMargin: 30

        Image {
            id: qr
            source: root.source
            anchors.fill: parent
            anchors.margins: 9
        }
    }



    Connections
    {
        id:apiConnections;
        target: apiNetWork;
        onSig_userBindSuccess:
        {
            console.log("onSig_userBindSuccess");
            qrSuccess();
        }
    }

    onVisibleChanged:
    {
        if(visible === true)
        {
            if(dataManager.getLive())
            {
                dataManager.setPollDevAlways(true);
                dataManager.startPollDevStatus();
            }
        }
        else
        {
            console.log("dataManager.setPollDevAlways(false)");
            dataManager.setPollDevAlways(false);
        }
    }

    Component.onDestruction:
    {
        console.log("Component.onDestruction  dataManager.setPollDevAlways(false)");
        dataManager.setPollDevAlways(false);
    }
}
