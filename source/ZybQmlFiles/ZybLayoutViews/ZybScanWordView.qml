import QtQuick 2.0
import "../ZybPages/"
import "../ZybControls"
import "../Style"
import "../Funcs/UILogics.js" as UILogic
import com.zyb.PingDefine 1.0

Rectangle {
    id:scanWordView
    color: Style.mainbgColor
    property var pageType: "wordpage"
    property var pageState: 0
    property var prePageState: 0
    property var showType: "scan" //scan,history

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    Image{
        id : topbtn
        source: "qrc:/images/top66x56.png"
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        z:21
        MouseArea{
            anchors.fill: parent
            onClicked: {
                scanResultPage.toTop();
            }
        }
    }

    ZybStoreButton{
        id:storeButton
        //anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 27
        visible: scanResultPage.isHaveQueryRes && (scanWordView.pageState === 2 || scanWordView.pageState === 5)
        z:20
        onClicked: {
            isStored = !isStored;
            if(!isStored){
                if(scanWordView.pageState === 2){
                    scanResultPage.unStore();
                }
                else if(scanWordView.pageState === 5){
                    enchPage.unStore();
                }
                main.showTip(qsTr("已取消收藏"));
            }
            else{
                if(scanWordView.pageState === 2){
                    scanResultPage.store();
                }
                else if(scanWordView.pageState === 5){
                    enchPage.store();
                }
                main.showTip(qsTr("已收藏到生疏归纳"));
            }
        }
    }


    ZybVolumeButton{
        id: volumeButton
        visible: ((pageState !== 0) &&  (pageState !== 1) && (pageState !== 3) && (pageState !== 6) && (pageState !== 7) && (pageState !== 8))
        y: Style.scanresult_volume_y
        anchors.right: parent.right
        anchors.rightMargin: 27
        enabled: !topbtn.visible
        z:20
        onClicked: {
            prePageState = pageState;
            pageState = 6;
            //console.log("volumeButton clicked")
        }
    }

    ZybMicrophoneButton{
        id: microPhoneButton
        visible: (pageState === 2 && QueryWordManager.m_isEnglish && scanResultPage.isHaveQueryRes) || (pageState === 5)
        y: Style.scanresult_microphone_y
        anchors.right: parent.right
        anchors.rightMargin: 27
        enabled: !topbtn.visible
        z:20
        onClicked: {
            if(dataManager.getLive() === false){
                UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                return;
            }
            prePageState = pageState;
            playqueryStop();
            if(pageState === 2){
                followStartPage.setData(scanResultPage.currentWord);
            }
            else{
                followStartPage.setData(enchPage.wordText);
            }
            pingManager.addPingData(PingDefine.PING_EVENT_DICT_FOLLOWUP_NUM);
            pageState = 7;

//            console.log("microPhoneButton clicked")
        }
    }

    ZybScanTipPage{
        id:scanTipPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 0)
        onToNext: {
            pageState = 1
        }
    }

    ZybScanPage{
        id:scanPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 1)
        onToNext: {
            var scanres = scanManager.getScanResult();
            console.log("++++++++++++scanres:",scanres);
            pageState = 2;
            storeButton.enabled = false;
            scanResultPage.start(scanres);
        }

        onBack: {
            pageState = 0;
        }

    }

    ZybMiaoHongPage{
        id:miaoHongPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 3)
        onBack: {
            pageState = 2;
        }
    }

    ZybScanWordResultPage{
        id:scanResultPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 2)
        onToMiaoHongPage: {
            QueryWordManager.playStop();
            pageState = 3;
//            console.log("onToMiaoHongPage2")
            playqueryStop();
        }

        onToWywPage: {
            QueryWordManager.playStop();
            pageState = 4;
            wywPage.setData(data);
//            console.log("onToWywPage2")
            playqueryStop();
        }

        onToEnChPage: {
            QueryWordManager.playStop();
            pageState = 5;
            enchPage.preIsEnglish = QueryWordManager.m_isEnglish;
            enchPage.setData(data);
//            console.log("onToEnchPage2")
//            playqueryStop();
        }

        onBack: {
            if(scanWordView.showType === "scan"){
                UILogic.backToHome();
            }
            else if(scanWordView.showType === "history"){
                UILogic.closeWordResView();
            }

            playqueryStop();
        }

        onIsStored: {
            storeButton.enabled = true;
            if(stored){
                storeButton.isStored = true;
            }
            else{
                storeButton.isStored = false;
            }
        }

        onVisibleChanged: {
            if(visible){
                storeButton.isStored = scanResultPage.isWordStored;
            }
        }

        onTopBtnVisible: {
            topbtn.visible = visible;
        }
    }

    ZybWywPage{
        id:wywPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 4)
        onBack: {
            pageState = 2;
            playqueryStop();
        }
    }

    ZybEnChPage{
        id:enchPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 5)
        property var preIsEnglish: true
        onBack: {
            console.log("preIsEnglish:",preIsEnglish);
            QueryWordManager.m_isEnglish = preIsEnglish;
            pageState = 2;
            playqueryStop();
        }

        onIsStored: {
            storeButton.enabled = true;
            if(stored){
                storeButton.isStored = true;
            }
            else{
                storeButton.isStored = false;
            }
        }

        onVisibleChanged: {
            if(visible){
                storeButton.isStored = enchPage.isWordStored;
            }
        }
    }

    WordQueryVolumnPage{
        id:volumnpage
        anchors.fill: parent
        visible: (scanWordView.pageState === 6)
        onBack: {
            pageState = prePageState;
        }
    }

    FollowUpStartPage{
        id:followStartPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 7)
        onBack: {
            pageState = prePageState;
            playqueryStop();
        }
        onGotoResultPage: {
            followResultPage.setData(resObj);
            pageState = 8;
            playqueryStop();
        }
    }

    FollowUpResultPage{
        id:followResultPage
        anchors.fill: parent
        visible: (scanWordView.pageState === 8)
        onBack: {
//            scanWordView.pageState = 7;
            pageState = prePageState;
            playqueryStop();
        }
        onBackToFollowStart: {
            scanWordView.pageState = 7;
            playqueryStop();
        }
    }



    Connections {
        target: scanManager;
        onSig_scanDown:{
            if(!visible){
                return;
            }

            if(devManager.getScanForWhat() !== 0){
                return;
            }
            console.log("+++++++++++++++++++++++++++++++++++onSig_scanDown");
            playqueryStop();
            pageState = 1;

        }

    }

    onPageStateChanged: {
//        console.log("ZybScanWordView onPageStateChanged")
//        if(pageState !== 6){
//            QueryWordManager.queryStop();
//            QueryWordManager.playStop();
//        }

    }

    onVisibleChanged: {
        if(!visible){
            playqueryStop();
            engineSocket.sendEnableSysAutoOffScreen(true);
        }
    }

    Connections {
        target: engineSocket;

        onSig_offScreenKey:{
            playqueryStop();
        }

    }

    function playqueryStop(){
        QueryWordManager.queryStop();
        QueryWordManager.playStop();
    }

    function goToTipPage(){
        pageState = 0;
    }

    function goToScanPage(){
        pageState = 1;
    }

    function goToResultPage(){
        pageState = 2;
        scanResultPage.start();
    }

    function goToMiaoHongPage(){
        pageState = 3;
    }

    function setWord(historyWord){
        pageState = 2;
        storeButton.enabled = false;
        scanResultPage.startNoHistory(historyWord);
    }

    Component.onCompleted: {
//        console.log("scanWordView init")
    }

    Component.onDestruction: {
        QueryWordManager.queryStop();
        QueryWordManager.playStop();
    }

    Connections{
        id:soundPlayConnect
        target:QueryWordManager
        onAudioStart:{
            if(visible){
                engineSocket.sendEnableSysAutoOffScreen(false);
            }
        }
        onAudioStop:{
            if(visible){
                engineSocket.sendEnableSysAutoOffScreen(true);
            }
        }
    }
}

