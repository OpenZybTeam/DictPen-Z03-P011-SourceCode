import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import "../ZybStore"
import com.zyb.PingDefine 1.0

Rectangle {
    id:devInfo
    //anchors.fill: parent
    color: Style.mainbgColor

    property color itemBgColor: "#993C3D42"
    property bool isLogin : false
    property int clickSnCnt: 0
    signal backClicked()

    property string devname: Style.highVersion? qsTr("作业帮学习笔（大屏版）"): qsTr("作业帮学习笔")

    function updateDevInfo()
    {
        isLogin = devManager.isLogin();
        console.log("islogin =",isLogin);
        if(dataManager.getLive())
        {
            devmodel.get(0).righttext = isLogin===false?qsTr("未登录"):devManager.getCurUserName();
            devmodel.get(0).icon = isLogin===false?"qrc:/images/right28x28.png":"";
        }
        else
        {
            if(devManager.getCurUserName().length)
            {
                devmodel.get(0).righttext = devManager.getCurUserName().length?devManager.getCurUserName():qsTr("未登录");
                devmodel.get(0).icon = "";
            }
            else
            {
                devmodel.get(0).righttext = isLogin===false?qsTr("未登录"):devManager.getCurUserName();
                devmodel.get(0).icon = isLogin===false?"qrc:/images/right28x28.png":"";
            }
        }

        devmodel.get(1).righttext = devname;
        devmodel.get(2).righttext = Style.highVersion?qsTr("P010"):qsTr("P011")
        devmodel.get(3).righttext = devManager.getSN()
        devmodel.get(4).righttext = devManager.getWifiMac()
        devmodel.get(5).righttext = devManager.getIccId()
        devmodel.get(6).righttext = devManager.getVersion();
    }

    SetLoadingPage
    {
        id:loading
        anchors.fill: parent
        visible: false
        z:3
    }

    function initLoadingPageForQr()
    {
        loading.titleVisible = false;
        loading.bottomTextVisible = false;
        loading.autoHide = true;
    }

    function initLoadingPageForReset()
    {
        loading.titleVisible = true;
        loading.bottomTextVisible = true;
        loading.autoHide = false;
        loading.titleText = qsTr("恢复出厂设置");
        loading.bottomText = qsTr("恢复中");
    }

    SetQrPage
    {
        id:qr
        anchors.fill: parent
        visible: false
        z:2
        source: "file:///"+"/home/userdata/qr.png"
        onBackToParent:
        {
            visible = false
            //console.log(source)
        }

        onQrSuccess:
        {         
            updateDevInfo();

            if(qr.visible === true)
            {
                initLoadingPageForQr();
                loading.visible = true
                if(loading.autoHide)
                {
                    loading.hidePage();
                    qr.visible = false;
                }
            }
        }
    }

    PopupDialog
    {
        id:logoutDig
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("确定退出登录？?")
        visible: false

        onLeftClicked:
        {
            logoutDig.close();
        }

        onRightClicked:
        {
            apiNetWork.sendApiLogout();
            logoutDig.close();
            //busyimg.visible = true;
        }

    }

    Connections
    {
        target: apiNetWork
        onSig_logoutSuccess:
        {

            //busyimg.visible = false;
            dataManager.setQuesLastTime(0);
            devManager.logout();
            loginInfo.visible = false;
            updateDevInfo();
        }
    }

    SetOneBtn
    {
        id:loginInfo
        anchors.fill: parent
        visible: false
        title:qsTr("登录")
        str1: qsTr("已登录账号：")
        str2: devManager.getCurUserName();
        bottomBtnString:qsTr("退出登录")
        z:2

        onBackToParent:
        {
            visible = false
        }

        onBtnClicked:
        {
            logoutDig.visible = true
        }
    }

    SetOneBtn
    {
        id:reset
        anchors.fill: parent
        visible: false
        title:qsTr("恢复出厂设置")
        str1: qsTr("恢复出厂设置后，将清除设备上的所有数据")
        str2: "";
        bottomBtnString:qsTr("确认恢复")
        z:2

        onBackToParent:
        {
            visible = false
        }

        onBtnClicked:
        {
            initLoadingPageForReset();
            engineSocket.sendReset();
            loading.visible = true;
            pingManager.addPingData(PingDefine.PING_EVENT_SET_RESET);
        }
    }

    SetDebugPage
    {
        id:debugPage
        anchors.fill: parent
        z:10
        visible: false

        onBackToParent:
        {
            visible = false;
            clickSnCnt = 0;
        }
    }

    Connections
    {
        target: vk;
        onCommitInput:
        {
            if(t1 ==  "abort@@zyb#.spee")
            {
                debugPage.visible = true;
            }

        }
    }

    ListModel {
        id:devmodel
        ListElement { lefttext: qsTr("登录"); righttext:qsTr("NULL"); icon: "qrc:/images/right28x28.png";mycolor:"#12CFA7";}
        ListElement { lefttext: qsTr("设备名称:");righttext:qsTr("作业帮全科学习笔"); icon: "";mycolor:"";}
        ListElement { lefttext: qsTr("型号:"); righttext:qsTr("XXXX");icon: "";mycolor:"";}
        ListElement { lefttext: qsTr("SN号:"); righttext:qsTr("test4");icon: "";mycolor:"";}
        ListElement { lefttext: qsTr("MAC地址:"); righttext:qsTr("test5");icon: "";mycolor:"";}
        ListElement { lefttext: qsTr("iccid:"); righttext:qsTr("test6");icon: "";mycolor:"";}
        ListElement { lefttext: qsTr("版本:"); righttext:qsTr("test7");icon: "";mycolor:"";}
        ListElement { lefttext: qsTr("恢复出厂设置:");righttext:qsTr(""); icon: "qrc:/images/right28x28.png";mycolor:"";}
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

        header:Item {
            id: header
            width: parent.width
            height: 65

            ZybBackButton{
                id:backButton
                anchors.top: parent.top
                anchors.left: parent.left
                onBackClicked: {
                    UILogic.backToSetPage();
                }
            }

            ZybText {
                id: title
                text: qsTr("关于设备")
                font.styleName: "Bold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: backButton.verticalCenter
            }
        }

        delegate: SetListItem {
            width: parent.width
            height: 70
            radius: 6
            ltext: model.lefttext
            rtext: model.righttext
            rcolor: model.mycolor
            iconsource: model.icon
            MouseArea {
                anchors.fill: parent
                enabled:  index===0 || index===7 || index===3
                onClicked:
                {
                    view.currentIndex = index
                    //跳转到页面
                    if(index === 0)
                    {
                        if(dataManager.getLive() === false)
                        {
                            netDig.open();
                            return;
                        }

                        if(isLogin == false)
                        {
                            qr.setModeForBind();
                            qr.visible = true
                        }
                        else
                        {
                            return;
                        }
                        clickSnCnt =0;
                    }
                    else if(index === 7)
                    {
                        reset.visible = true;
                        clickSnCnt =0;
                    }
                    else if(index === 3)
                    {
                        clickSnCnt++
                    }

                    if(clickSnCnt >5)
                    {
                        vk.showKeyboard();
                        clickSnCnt = 0;
                    }

                }
            }

        }


        model: devmodel

        ScrollIndicator.vertical: ScrollIndicator { }
    }

    onVisibleChanged:
    {
        if(visible)
        {
            updateDevInfo();
        }
    }

    Component.onCompleted:
    {
        updateDevInfo();
    }
}
