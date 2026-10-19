import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import "../Global"

Flickable{
    id:root
    contentHeight: colume.height + 50
    ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
    clip : true
    property string version: ""
    property bool isLastVer: true

    state:"normal"
    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    showPage.visible = true;
                    downloadPage.visible = false;
                    showPage.state = "normal"
                    downloadPage.progressIndeterminate = false;
                }
            }
        },

        State {
            name: "have_new_version"
            StateChangeScript {
                script: {
                    showPage.visible = true;
                    downloadPage.visible = false;
                    showPage.state = "have_new_version"
                    downloadPage.progressIndeterminate = false;
                }
            }
        },

        State {
            name: "have_download"
            StateChangeScript {
                script: {
                    showPage.visible = true;
                    downloadPage.visible = false;
                    showPage.state = "have_download"
                    downloadPage.progressIndeterminate = false;
                }
            }

        },
        State {
            name: "is_downloading"
            StateChangeScript {
                script: {
                    showPage.visible = false;
                    downloadPage.visible = true;
                    downloadPage.progressIndeterminate = false;
                }
            }

        }
    ]

    Column{
        id:colume
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        spacing: 0

        Item{
            id: header
            width:colume.width
            height: 56
            ZybBackButton{
                id:backButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                onBackClicked: {
                    root.visible = false
                    UILogic.backToSetPage();
                }
            }

            ZybText {
                id: title
                text: qsTr("升级")
                font.styleName: "Bold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: backButton.verticalCenter
            }
        }

        SetUpdateSubPage1{
            id:showPage
            visible: root.state !== "is_downloading"//false
            width: colume.width

            onCancelDownload: {
                showPage.visible = true;
                downloadPage.visible = false;
                showPage.state = "have_new_version"
            }
        }

        SetUpdateSubPage2{
            id:downloadPage
            visible: root.state === "is_downloading"
            width: colume.width
        }
    }

    Connections {
        target: engineSocket;

        onSig_updateSuccess:
        {
            main.showTip(qsTr("固件升级成功"));
        }

        onSig_updateErr:{
            switch(err)
            {
            case 1:
                main.showTip(qsTr("存储空间不足！"));
                break;
            case 2:
                main.showTip(qsTr("内存不足"));
                break;
            }
        }
    }

    Connections{
        target: devManager
        onLastVersionChanged:{
            updateState()
        }

        onOtaCheckFinshed:{
            var isLastVersion = devManager.getLatested();
            if(isLastVersion === true || isLastVersion){
                UILogic.showTip("已是最新版本");
            }
            else{
                devManager.setNewVerDlgVer(devManager.getNewVersion());
                console.log("isNweVerDownload = ",devManager.getNewVerDownload())
                updateState();
            }
        }
    }

    Connections{
        target: OtaManager
        onDownLoadFinished:{
//            var strPath = filePath;
            if(OtaManager.checkOtaPackge()){
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
                    root.state = "have_download"
                    return;
                }
                if(devManager.getNewVersionForced()){
                    root.state = "have_download";
                    return;
                }
//                root.state = "have_download"
                devManager.setNewVersionForced(false);
                devManager.saveConfigFile();
                engineSocket.sendUpdate();
            }
            else{
                root.state = "have_new_version";
            }
        }

        onSig_downloadProgress:{
            root.state = "is_downloading"
//            var byteReceived = bytesReceived;
//            var byteTotal = devManager.getNewVersionSize();
//            var pencent = (bytesReceived / bytesTotal)*100;
            console.log("progressValue:",OtaManager.getPersent());
            downloadPage.progressValue = OtaManager.getPersent();
        }

        onSig_downLoadError: {
            console.log("onSig_downLoadError")
            root.state = "have_new_version";
//            devManager.setIsDownloading(false);
//            devManager.setNewVerDownload(false);
        }

        onSig_cancelDownload:{
            root.state = "have_new_version";
        }
    }

    onVisibleChanged: {
        if(visible){
            GlobalProperty.isUpdatePageVisible = true;
            updateState()
        }
        else{
            GlobalProperty.isUpdatePageVisible = false;
        }
    }

    Component.onCompleted: {
        GlobalProperty.isUpdatePageVisible = true;
        updateState()
        devManager.setUpdateRedEntered(true);
        if(visible){
//            GlobalProperty.isUpdatePageVisible = true;
//            updateState()
        }
    }

    Component.onDestruction: {
        GlobalProperty.isUpdatePageVisible = false;
    }

    function updateState(){
        var isLastVersion = devManager.getLatested();
        var isNweVerDownload = devManager.getNewVerDownload();
        var isDownloading = devManager.getIsDownloading();
        if(isDownloading === true || isDownloading){
            downloadPage.progressValue = OtaManager.getPersent();
            state = "is_downloading"
        }
        else{
            if(isNweVerDownload === true || isNweVerDownload){
                state = "have_download"
                return;
            }
            if(isLastVersion === true || isLastVersion){
                state = "normal"
            }
            else{
                if(isNweVerDownload === true || isNweVerDownload){
                    state = "have_download"
                }
                else{
                    state = "have_new_version"
                }
            }
        }
    }
}
