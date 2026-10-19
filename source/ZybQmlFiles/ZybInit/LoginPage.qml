import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Style"
import com.zyb.PingDefine 1.0

Rectangle {
    id:root
    //anchors.fill: parent
    color: Style.mainbgColor
    property color itemBgColor: "#993C3D42"
    property string source : ""
    signal toPre
    signal toNext
    signal qrSuccess

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: false
        onBackClicked: {
            toPre();
        }
    }

    ZybBackButton{
        id:nextButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        rotation: 180
        onBackClicked: {
            pingManager.addPingData(PingDefine.PING_EVENT_SKIP_LOGIN);
            toNext();
        }
    }

    Rectangle
    {
        id:bg
        color: "#FFFFFF"
        width: 238
        height: 238
        radius: 6
        anchors.left : backButton.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 5
        //border.

        Image {
            id: qr
            source: root.source
            anchors.fill: parent
            anchors.margins: 9
        }
    }

    ZybText
    {
        id:title
        text: qsTr("下载APP绑定设备")
        font.pixelSize: 28
        font.styleName: "Bold"
        anchors.left : bg.right
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 20
    }


    ZybText
    {
        id:text1
        width: 446
        text: qsTr("1.手机扫描二维码下载作业帮智能App\n2.打开作业帮智能App->点击设备管理->立即添加->扫描二维码绑定")
        font.pixelSize: Style.tipFontPixel
        lineHeight: 1.5
        anchors.top: title.bottom
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
        anchors.topMargin : 12
        anchors.left : bg.right
        anchors.leftMargin: 30
    }


    Connections
    {
        target: apiNetWork;
        onSig_userBindSuccess:
        {
            console.log("onSig_getDevInfoSuccess");
            qrSuccess();
        }
    }

    onVisibleChanged:
    {
        if(visible === true)
        {
            source = "file:///"+"/home/userdata/qr.png"
            dataManager.setPollDevAlways(true);
            dataManager.startPollDevStatus();
        }
        else
        {
            console.log("dataManager.setPollDevAlways(false)");
            dataManager.setPollDevAlways(false);
//            dataManager.stopPollDevInfo();
        }
    }

    Component.onDestruction:
    {
        console.log("Component.onDestruction  dataManager.setPollDevAlways(false)");
        dataManager.setPollDevAlways(false);
    }

}
