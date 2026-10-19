import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybPages/"
import "../ZybPages/ZybDict"
import "../ZybControls"
import "../ZybPages/Oxford"
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
    visible: false

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    GradeSelectDialog{
        id:gradeDlg
        parent: scanWordView
    }

    property var followUpView: null
    Component{
        id:followupComponent
        FollowUpView{
//            anchors.fill: parent
        }
    }

    property var scanTipView: null
    Component{
        id:scantipComponent
        ZybScanTipPage{
        }
    }

//    property var scanShowView: null
//    Component{
//        id:scanShowComponent
//        ZybScanPage{
//        }
//    }

    property var miaoHongView: null
    Component{
        id:miaohongComponent
        ZybMiaoHongPage{
        }
    }

    property var volumnView: null
    Component{
        id:volumnComponent
        WordQueryVolumnPage{
        }
    }

    property var oxfordMoreView: null
    Component{
        id:oxfordMoreViewComponent
        OxfordMorePage{}
    }


    ZybScanWordResultPage2{
        id:scanResultPage
        anchors.fill: parent
        visible: false

        onBack: {
            if(scanWordView.showType === "scan"){
                UILogic.backToHome();
            }
            else if(scanWordView.showType === "history"){
                UILogic.closeWordResView();
            }
            playqueryStop();
        }

        onVisibleChanged: {
            if(!visible){
                playqueryStop();
            }
        }
    }

    ZybScanPage{
        id:scanShowView
        anchors.fill: parent
        visible: false
    }


//    DictTiPage{
//        id:tiPage
//        anchors.fill: parent
//        visible: false
//        z:5
//    }

    property var zybDictTiView: null
    Component{
        id:zybDictTiViewComponent
        DictTiPage{
            z:5
        }
    }




    onVisibleChanged: {
        if(!visible){
            if(gradeDlg.opened){
                gradeDlg.close();
            }

//            tiPage.visible = false;
            if(zybDictTiView !== null){
                zybDictTiView.destroy()
            }
            scanManager.cleanScanRes();
            closeTempView();
            playqueryStop();
            engineSocket.sendEnableSysAutoOffScreen(true);
        }
        else{
            if(devManager.getSelDictGrade() === 3 && !gradeDlg.opened){
                gradeDlg.open();
            }

        }
    }

    Connections {
        target: engineSocket;

        onSig_offScreenKey:{
//            playqueryStop();
            QueryWordManager.playStop();
        }

    }

    Connections{
        target: scanManager
        onSig_scanUp:{
            if(visible){
//                if(dataManager.getLive() === true){
//                    UILogic.openWebSocket(2);
//                }
            }
        }
    }

    function goToTipPage(){
        scanResultPage.visible = false;
        scanShowView.visible = false;
//        tiPage.visible = false;
        if(zybDictTiView !== null){
            zybDictTiView.destroy()
        }
        QueryWordManager.playStop();
        if(scanTipView === null){
            scanTipView = scantipComponent.createObject(scanWordView);
        }
    }

    function goToScanPage(){
        scanResultPage.visible = false;
//        tiPage.visible = false;
        if(zybDictTiView !== null){
            zybDictTiView.destroy()
        }
        scanShowView.visible = true;
        QueryWordManager.playStop();
//        if(scanShowView === null){
//            console.log("goToScanPage+++++++++++++++++++++++++++++++1")
//            scanShowView = scanShowComponent.createObject(scanWordView);
//        }
//        else{
//            console.log("goToScanPage+++++++++++++++++++++++++++++++2")
//            scanShowView.destroy();
//            scanShowView = scanShowComponent.createObject(scanWordView);
//        }
    }

    function goToWordResultPage(word,isHistory){
        scanShowView.visible = false;
        scanResultPage.visible = true;
        if(isHistory){
            scanResultPage.startNoHistory(word);
        }
        else{
            scanResultPage.start(word);
        }
    }

    function goToMiaoHongPage(){
        QueryWordManager.playStop();
        if(miaoHongView === null){
            miaoHongView = miaohongComponent.createObject(scanWordView);
        }
    }


    function gotoWordQueryVolumnPage(){
        if(volumnView === null){
            volumnView = volumnComponent.createObject(scanWordView);
        }
    }

    function gotoFollowUpView(data){
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_FOLLOWUP_NUM);
        QueryWordManager.playStop();
        if(followUpView === null){
            followUpView = followupComponent.createObject(scanWordView,{worddata:data});
        }
    }

    function gotoOxfordMorePage(data,curWordIndex,curPosIndex){
        QueryWordManager.playStop();
        if(oxfordMoreView === null){
            oxfordMoreView = oxfordMoreViewComponent.createObject(scanWordView,{controlData:data,curWordIndex:curWordIndex,curPosIndex:curPosIndex});
        }
    }

    function setWord(historyWord){
        scanResultPage.visible = true;
        storeButton.enabled = false;
        scanResultPage.startNoHistory(historyWord);
    }

    function playqueryStop(){
        QueryWordManager.queryStop();
        QueryWordManager.playStop();
    }

    function closeTempView(){
        if(followUpView !== null){
            followUpView.destroy();
        }
        if(volumnView !== null){
            volumnView.destroy();
        }
        if(miaoHongView !== null){
            miaoHongView.destroy();
        }
        if(scanTipView !== null){
            scanTipView.destroy();
        }
        if(oxfordMoreView !== null){
            oxfordMoreView.destroy();
        }
    }

    function setIsGotoEnchPage(bgo){
        scanResultPage.isgotoEnChPage = bgo;
    }

    function resViewToPos(pos){
        scanResultPage.toPos(pos);
    }

    function getResPos(){
        return scanResultPage.getPos();
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

    Connections{
        target:apiNetWork
        onSig_getZybDictTiRes:{
            if(zybDictTiView === null){
                zybDictTiView = zybDictTiViewComponent.createObject(scanWordView,{curResultIndex:0});
            }
//            tiPage.visible = true
//            tiPage.curResultIndex = 0;
            api.setDataFormStoreResMap(res);
//            tiPage.startUpdateHtml();
            zybDictTiView.startUpdateHtml();
        }
    }
}
