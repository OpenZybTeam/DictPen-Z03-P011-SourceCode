import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import "../Global"
import com.zyb.PingDefine 1.0

Item{
    id:root
    width: parent.width
    height: version.height + btn.height + (updateContent.visible ? updateContent.height : 0) + 40 + 10
    property var versionText: qsTr("当前版本：  ") + devManager.getVersion()
    property var updateText: ""
    signal cancelDownload()

    state:"normal"
    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    versionText = qsTr("当前版本：  ") + devManager.getVersion()
                    btn.text = qsTr("检查更新")
                    updateContent.visible = false;
                }
            }
        },

        State {
            name: "have_new_version"
            StateChangeScript {
                script: {
                    versionText = qsTr("检查到新版本：  ") + devManager.getNewVersion()
                    btn.text = qsTr("立即下载")
                    console.log("devManager.getNewVersion:",devManager.getNewVersion());
                    updateText = devManager.getNewFeature();
                    updateContent.visible = true;
                }
            }
        },

        State {
            name: "have_download"
            StateChangeScript {
                script: {
                    console.log("SetUpdateSubPage1.qml have_download")
                    versionText = qsTr("更新下载完成")
                    btn.text = qsTr("立即安装")
                    updateContent.visible = false;
                }
            }
        }
    ]


    Text {
        id: version
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        font.pixelSize: 28
        wrapMode: Text.WrapAnywhere
        color: "#FFFFFFFF"
        text: versionText
    }

    BasicButton
    {
        id:btn
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        font.pixelSize: 24
        text: qsTr("检查更新")
        backgroundTheme: Style.mainColor
        checked: true
        implicitWidth: 166
        implicitHeight: 56
        radius:6
        backgroundColor: "#FF12CFA7"
        checkable: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: version.bottom
        anchors.topMargin: 20

        onClicked:
        {

            console.log("onClicked state:",root.state);
//            UILogic.confirmOperator(qsTr("更新下载完成，是否立即安装"),qsTr("cancel"),qsTr("ok"),
//                                    function() {
//                                        console.log("Ok clicked");
//                                    },
//                                    function() {
//                                        console.log("cancel clicked");
//                                    },
//                                    true);
            if(root.state === "normal"){
                pingManager.addPingData(PingDefine.PING_EVENT_SET_CHECK_UPDATE);
                if(dataManager.getLive() === false){
                    UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                    return;
                }
                apiNetWork.sendApiOta();
            }
            else if(root.state === "have_new_version"){
                console.log("onClicked 1");
                if(dataManager.getLive() === false){
                    UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                    return;
                }


                console.log("onClicked 2");
                if((devManager.getNewVersionSize() + (1024*1024*1024 + 100*1024*1024))  >= devManager.getFreeDisk("/mnt/data") ){
                    devManager.rmLogFiles();
                    if((devManager.getNewVersionSize() + (1024*1024*1024 + 100*1024*1024))  >= devManager.getFreeDisk("/mnt/data") ){
                        main.showTip(qsTr("磁盘空间不足请删除收藏夹和历史记录内容"));
                        return;
                    }
                }
                if(dataManager.getCheckIntLiveMode() === 1){
                    UILogic.confirmOperator(qsTr("正在使用流量,是否连接WiFi下载"),qsTr("继续下载"),qsTr("连接WiFi"),
                                            function() {
                                                GlobalProperty.isOtaDownloadAbord = true;
                                                if(!GlobalProperty.isWifiPageVisible){
                                                    UILogic.openWifiPage(function(){
                                                        OtaManager.downLoad(devManager.getNewUrl());
                                                        devManager.setIsDownloading(true);
                                                    },
                                                    function(){
    //                                                    OtaManager.stopDownload();
    //                                                    devManager.setIsDownloading(false);
    //                                                    root.cancelDownload();
                                                    })
                                                }

                                            },
                                            function() {


                                                OtaManager.downLoad(devManager.getNewUrl());
                                                devManager.setIsDownloading(true);

                                            },
                                            false,true);
                }
                else{
                    OtaManager.downLoad(devManager.getNewUrl());
                    devManager.setIsDownloading(true);
                }

//                console.log("onClicked 4");
//                console.log("devManager.getNewUrl:",devManager.getNewUrl());

//                OtaManager.downLoad(devManager.getNewUrl());
//                devManager.setIsDownloading(true);
            }
            else if(root.state === "have_download"){
                if(devManager.getPowerNum() < 70)
                {
//                    main.showTip(qsTr("请将电量充至80%以上再升级"));
                    UILogic.confirmOperator(qsTr("请将电量充至70%以上再进行安装"),qsTr(" "),qsTr("知道了"),
                                            function() {
                                            },
                                            function() {
                                            },
                                            false,false);
                    devManager.setNeedShowUpdateBettery(true);
                    return;
                }
                devManager.setNeedShowUpdateBettery(false);
                devManager.setNewVersionForced(false);
                devManager.saveConfigFile();
                engineSocket.sendUpdate();
            }
        }
    }

    Text {
        id: updateContent
        anchors.top: btn.bottom
        anchors.topMargin: 0
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        font.pixelSize: 28
        color: "#FFFFFFFF"
        text: updateText
    }

}
