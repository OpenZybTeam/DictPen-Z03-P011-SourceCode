import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Style"

Pane {
    id:root


    background: Rectangle{
        anchors.fill: parent
        color: Style.mainbgColor
    }

    property bool isForBind : true
    property color itemBgColor: "#993C3D42"
    property string source : ""
    signal backToParent
    signal qrSuccess()

    function setModeForParentMode()
    {
        isForBind = false;
        text2.visible = false
        if(api.isChildrenMode())
        {
            text1.text=qsTr("1.手机扫描二维码下载作业帮智能App\n2.打开作业帮智能App->点击设备管理->立即添加->扫描二维码绑定\n3.进入设备详情页，切换显示解答\n4.切换完成后，将设备息屏再亮屏即可生效")
        }
        else
        {
            text1.text=qsTr("1.手机扫描二维码下载作业帮智能App\n2.打开作业帮智能App->点击设备管理->立即添加->扫描二维码绑定\n3.进入设备详情页，切换关闭解答\n4.切换完成后，将设备息屏再亮屏即可生效")
        }
    }

    function setModeForBind()
    {
        text2.visible = true
        text1.text = qsTr("1.手机扫描二维码下载作业帮智能App\n2.打开作业帮智能App->点击设备管理->立即添加->扫描二维码绑定")
    }

    function init()
    {
        console.log("test")
    }

    ZybBackButton{
        id:backButton
        enabled: true
        anchors.top: parent.top
        //anchors.topMargin: 20
        anchors.left: parent.left
        //anchors.leftMargin: 20
        onBackClicked: {
            backToParent();
        }
    }

    Rectangle
    {
        id:bg
        color: "#FFFFFF"
        width: Style.highVersion ?228:238
        height: width
        radius: 6
        anchors.left : backButton.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 0
        //border.

        Image {
            id: qr
            source: root.source
            anchors.fill: parent
            anchors.margins: 9
        }
    }

//    ZybText
//    {
//        id:title
//        text: qsTr("下载APP绑定设备")

//        font.weight:  Font.Medium
//        anchors.left : bg.right
//        anchors.leftMargin: 30
//        anchors.top: parent.top
//        anchors.topMargin: 20
//    }


    ZybText
    {
        id:text1
        width: Style.highVersion ?600:446
        //lineHeight: 40
        text: qsTr("1.手机扫描二维码下载作业帮智能App\n2.打开作业帮智能App->点击设备管理->立即添加->扫描二维码绑定")
        font.pixelSize: Style.tipFontPixel
        lineHeight: 1.3
        anchors.top: parent.top
        anchors.topMargin : 12
        anchors.left : bg.right
        anchors.leftMargin: 30
        wrapMode: Text.Wrap
    }

    ZybText
    {
        id:text2
        text: qsTr("登录后会员用户可以观看题目视频讲解")
        font.pixelSize: Style.tipFontPixel
        color: "#999999"
        anchors.top: text1.bottom
        anchors.topMargin : 15
        anchors.left : bg.right
        anchors.leftMargin: 30
    }

    Connections
    {
        id:apiConnections;
        target: apiNetWork;
        onSig_userBindSuccess:
        {
            if(isForBind === true)
            {
                console.log("onSig_userBindSuccess");
                qrSuccess();
            }
        }
    }

    onVisibleChanged:
    {
        if(visible === true)
        {
            if(isForBind === true)
            {
                dataManager.setPollDevAlways(true);
                dataManager.startPollDevStatus();
            }
        }
        else
        {
            console.log("dataManager.setPollDevAlways(false)");
            isForBind = true;
            dataManager.setPollDevAlways(false);
        }
    }

    Component.onDestruction:
    {
        console.log("Component.onDestruction  dataManager.setPollDevAlways(false)");
        dataManager.setPollDevAlways(false);

    }
}
