import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../ZybPages/Oxford/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import com.zyb.PingDefine 1.0

Rectangle{
    id:root
    color: Style.mainbgColor
    signal toMiaoHongPage();
    signal toEnChPage(var data);
    signal back();
    property var currentWord: ""
    property var dictFirst: 0 //优先展示词典
    property var currrentRes: new Object
    property var onlineTransRes: new Object
    property int resType: 0  //ench:0;chen:1
    property bool isOnLineTrans: false

    //查询结果
    property bool isHaveRes: false
    property bool isHaveEnRes: false
    property bool isScanQuery: true
    property bool isWordStored: false

    //词典结果
    property bool isgotoEnChPage: false
    property string strFrom: ""  //strTo
    property string strTo: ""

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
        y: Style.scanresult_volume_y
        z:21
        MouseArea{
            anchors.fill: parent
            onClicked: {
                toTop();
            }
        }
    }

    ZybStoreButton{
        id:storeButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 27
        visible: (isHaveRes)
        z:1
        onClicked: {
            isStored = !isStored;
            if(!isStored){
                unStore();
                main.showTip(qsTr("已取消收藏"));
            }
            else{
                store()
                main.showTip(qsTr("已收藏到生疏归纳"));
            }
        }
    }


    ZybVolumeButton{
        id: volumeButton
        y: Style.scanresult_volume_y
        anchors.right: parent.right
        anchors.rightMargin: 27
        z:1
        onClicked: {
            ScanViewLogic.gotoWordQueryVolumnPage();
        }
    }

    ZybMicrophoneButton{
        id: microPhoneButton
        visible: (isHaveEnRes)
        y: Style.scanresult_microphone_y
        anchors.right: parent.right
        anchors.rightMargin: 27
        z:1
        onClicked: {
            if(dataManager.getLive() === false){
                UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                return;
            }
            ScanViewLogic.gotoFollowView(currentWord);
        }
    }

    property var enchView: null
    Component{
        id:enchViewComponent
        ZybEnChPage{
        }
    }



    Flickable{
        id:flickable
        anchors.fill: parent
        contentHeight: colume.height + 50
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true
        property var contentCoordY: 0 //记录滚动条位置
        property var preContentY: 0 //判断滑动方向



        Timer{
            id:flicktimer
            interval: 1500;
            repeat: false;
            running: false
            onTriggered: {
                topbtn.visible = false;
            }
        }

        onFlickStarted:
        {
            if(contentY > Style.gHeight && preContentY >contentY){
                topbtn.visible = true;
                flicktimer.stop();
            }
        }

        onMovementEnded: {
            preContentY = contentY;
            flicktimer.restart();
        }



        Column{
            id:colume
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 27
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
                        QueryWordManager.queryStop();
                        QueryWordManager.playStop();
                        back();
                    }
                }

                ZybWordsControl{
                    id:wordControl
                    anchors.left: backButton.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 72
                    onSignalQuery: {
//                        if(dataManager.getLive() === true){
//                            UILogic.openWebSocket(2);
//                            websocketConnectTimer.start();
//                        }
                        root.currentWord = strData;
                        isHaveEnRes = false;
                        updateDictRes(strData);
                    }
                }
            }
            Item {
                height: 16
                width: parent.width
            }
            ChEnContainer{
                id:chenDictContainer
                width: colume.width - 72
            }
            EnChContainer{
                id:enchDictContainer
                width: colume.width - 72
            }
            TipControl{
                id:tip
                visible: true
                width: colume.width
            }

            TransControl{
                id:trans
                visible: false
                width: colume.width - 72
            }

            Item{
                height: 50
                width: colume.width
            }

            Item{
                id:errorControl
                width: colume.width
                height: 56
                RowLayout{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    ZybErrorButton{
                        id: errorButton
                        implicitWidth: 180
                        implicitHeight: 56
                        onReport: {
                            console.log("onReport")

                            var valueObj = new Object;
                            valueObj["word"] = root.currentWord;
                            if(Segmentation.isEnglishStr(root.currentWord)){
                                valueObj["wordType"] = "en";
                            }
                            else{
                                valueObj["wordType"] = "ch";
                            }
                            pingManager.addPingData(PingDefine.PING_EVENT_DICT_ERROR,valueObj);
                            WordHistoryManager.addErrorItem(root.currentWord);
                            if(dataManager.getLive()){
                                apiNetWork.sendApiWordPicFeedback();
                            }
                        }
                    }

                    HelpButton{
                        id: helpButton
                        implicitWidth: 180
                        implicitHeight: 56
                        onClicked: {
                            UILogic.openTipPage("scanword")
                        }
                    }
                }
            }
            Item{
                height: 30
                width: colume.width
            }
        }

        Timer{
            id:queryTimer
            interval: 1000
            running: false
            triggeredOnStart: false
            repeat: false
            onTriggered: {
                chenDictContainer.visible = false;
                enchDictContainer.visible = false;
                trans.visible = false;
                tip.visible = true;
                tip.tips = qsTr("正在查询......");
            }
        }

        Timer{
            id:onlineTransTimer
            interval: 1100
            running: false
            triggeredOnStart: false
            repeat: false
            onTriggered: {
                if(resType === 0){
                    if(root.currrentRes["word"] === onlineTransRes["org"]){
                        root.currrentRes["trans"] = onlineTransRes["trans"];
                        isOnLineTrans = true;
                    }
                    updateEnRes(root.currrentRes);
                    toTop();
                }
                else if(resType === 1){
                    if(root.currrentRes["word"] === onlineTransRes["org"]){
                        root.currrentRes["trans"] = onlineTransRes["trans"];
                        isOnLineTrans = true;
                    }
                    updateChRes(root.currrentRes);
                    toTop();
                }
            }
        }

//        Timer{
//            id:websocketConnectTimer
//            interval: 800
//            running: false
//            triggeredOnStart: false
//            repeat: false
//            onTriggered: {

//            }
//        }

        Connections{
            target: Segmentation
            onSigSentChanged:{
                var wordModel = new Array;
                wordModel = Segmentation.getSentObj();
                wordControl.setData(wordModel);
            }
        }

        Connections{
            id:queryConnect
            target: QueryWordManager
            onQueryChFinished:{
                if(resObj["word"] === root.currentWord){
                    root.currrentRes = resObj;
                    isHaveEnRes = false;
                    resType = 1;
                    if(resObj["issent"] === 0 || resObj["issent"] === false){
                        updateChRes(root.currrentRes);
                        toTop();
                    }
                    else{
                        if(dataManager.getLive() === true){
                            if(resObj["word"] === onlineTransRes["org"]){
                                root.currrentRes["trans"] = onlineTransRes["trans"]
                                isOnLineTrans = true;
                                updateChRes(root.currrentRes);
                                toTop();
                            }
                            else{

                                onlineTransTimer.restart();
                            }
                        }
                        else{
                            updateChRes(root.currrentRes);
                            toTop();
                        }
                    }
                }
            }

            onQueryEngFinished:{
//                console.log("isgotoEnChPage:",isgotoEnChPage)

                if(!isgotoEnChPage){
                    if(resObj["word"] === root.currentWord){
                        root.currrentRes = resObj;
                        isHaveEnRes = false;
                        resType = 0;
                        if(resObj["issent"] === 0 || resObj["issent"] === false){
                            updateEnRes(root.currrentRes);
                            toTop();
                        }
                        else{
                            if(dataManager.getLive() === true){
                                if(resObj["word"] === onlineTransRes["org"]){
                                    root.currrentRes["trans"] = onlineTransRes["trans"]
                                    isOnLineTrans = true;
                                    updateEnRes(root.currrentRes);
                                    toTop();
                                }
                                else{
                                    onlineTransTimer.restart();
                                }
                            }
                            else{
                                updateEnRes(root.currrentRes);
                                toTop();
                            }
                        }

                    }
                }
                else{
                    topbtn.visible = false;
                    pingManager.addPingData(PingDefine.PING_EVENT_DICT_CH_TO_ENG_CLICK_ENG);
                    enchView = enchViewComponent.createObject(root,{currrentRes:resObj});
                    isgotoEnChPage = false;
                }

            }
        }

//        Connections {
//            target: websocket;

//            onGetNlpResult:
//            {
////                resPage.des = trans;
//                onlineTransRes["trans"] = trans;
//                onlineTransRes["org"] = src;
//            }

//            onSig_websocketConnect:{
//                if(websocketConnectTimer.running){
//                    websocketConnectTimer.stop();
//                    websocket.sendApiSpeechTextData(root.currentWord);
//                }
//            }
//        }

        Connections {

            target: apiNetWork
            onSigNlpResult:
            {

                onlineTransRes["trans"] = strDstText;
                onlineTransRes["org"] = strAsrSrc;
            }

            onSigNlpErr:
            {
                UILogic.showTip("未识别到有效内容，请重试",3000);
            }
        }

        Component.onCompleted: {
            queryConnect.enabled = true;
            onlineTransRes["org"] = "";
        }

        onVisibleChanged: {
            if(visible){
                storeButton.enabled = false;
                queryConnect.enabled = true;
                contentY = contentCoordY;  //设置滚动条位置
                toTop();
                if(enchView !== null){
                    enchView.destroy();
                }
            }
            else{
                chenDictContainer.visible = false;
                enchDictContainer.visible = false;
                trans.visible = false;
                errorControl.visible = false;
                isHaveEnRes = false;
                queryConnect.enabled = false;
                topbtn.visible = false;
                contentCoordY = contentY; //记录滚动条位置
                currrentRes = new Object;
            }
        }

        function updateDictRes(strWord){
    //        console.log("---------------------updateDictRes")
            var queryRes;
            isHaveRes = false;
//            chenDictContainer.visible = false;
//            enchDictContainer.visible = false;
//            trans.visible = false;
            errorControl.visible = false;
//            if(websocket.isConnected()){
//                websocket.sendApiSpeechTextData(strWord);
//            }
//            else{
//                websocketConnectTimer.restart();
//            }

            if(dataManager.getLive() === true){

                if(Segmentation.isEnglishStr(strWord))
                {
                    strFrom = "en";
                    strTo = "zh";
                }
                else
                {
                    strFrom = "zh";
                    strTo = "en";
                }

                apiNetWork.sendApiGetNlpResult(strWord, strFrom, strTo);
            }

            isOnLineTrans = false;
            if(Segmentation.isEnglishStr(strWord)){
                queryRes = QueryWordManager.queryEnglish(strWord);
                queryTimer.start();
            }
            else{
                queryRes = QueryWordManager.queryChinese(strWord);
                queryTimer.start();
            }

        }
    }



    function updateChRes(resObj){
        QueryWordManager.playStop();
        errorButton.isReport = false;

        if(!visible){
            return;
        }
        console.log("onQueryChFinished+++++++++++++++")
        queryTimer.stop();
        tip.visible = false;
        root.currrentRes = resObj;
        var queryRes = resObj;
        if(WordHistoryManager.isWordStore(queryRes["word"])){
            storeButton.enabled = true;
            storeButton.isStored = true;
            isWordStored = true;
        }
        else{
            storeButton.enabled = true;
            storeButton.isStored = false;
            isWordStored = false;
        }
        isHaveRes = false;
        if(queryRes["issent"] === 0 || queryRes["issent"] === false){
            if(queryRes["ch_en_result"] !== undefined){
                isHaveRes = true;
            }

            if(queryRes["trans"] !== undefined){
                var transRes = new Object;//["trans"] = queryRes["trans"];
                transRes["trans"] = queryRes["trans"]
                isHaveRes = true;
            }


            if(queryRes["xiandai_result"] !== undefined){
                isHaveRes = true;
            }

            if(queryRes["xinhua_result"] !== undefined){
                isHaveRes = true;
            }


            if(queryRes["idiom_result"] !== undefined){
                isHaveRes = true;
            }
            if(queryRes["wyw_result"] !== undefined){
                isHaveRes = true;
            }
            enchDictContainer.visible = false;
            trans.visible = false;
            chenDictContainer.setData(queryRes);
            chenDictContainer.visible = true;
        }
        else if(queryRes["trans"] !== undefined){
            trans.setDataText(queryRes["trans"],queryRes["word"])
            enchDictContainer.visible = false;
            chenDictContainer.visible = false;
            trans.visible = true;
            isHaveRes = true;
            if(isOnLineTrans){
                pingManager.addPingData(PingDefine.PING_EVENT_TRANS_ONLINE);
            }
        }
        else{
            enchDictContainer.visible = false;
            chenDictContainer.visible = false;
            tip.visible = true;
            trans.visible = false;
            tip.tips = qsTr("抱歉，没有查询到结果");
        }

        if(isHaveRes && root.isScanQuery){
            root.isScanQuery = false;
            WordHistoryManager.addHistoryItem(Segmentation.getInputSent());
        }

        if(isHaveRes){
            tip.visible = false;
        }
        errorControl.visible = true;
        if(dataManager.getLive()){
            apiNetWork.sendApiSearchPic();
        }
        isOnLineTrans = false;
    }

    function updateEnRes(resObj){
        QueryWordManager.playStop();
        errorButton.isReport = false;
        if(!visible){
            return;
        }
        console.log("onQueryEngFinished+++++++++++++++")
        queryTimer.stop();
        tip.visible = false;
        root.currrentRes = resObj;
        var haveEnres = false;
        var queryRes = resObj;
        if(WordHistoryManager.isWordStore(queryRes["word"])){
            storeButton.enabled = true;
            storeButton.isStored = true;
            isWordStored = true;
        }
        else{
            storeButton.enabled = true;
            storeButton.isStored = false;
            isWordStored = false;
        }
        if(queryRes["issent"] === 0 || queryRes["issent"] === false){
            tip.visible = false;
            trans.visible = false;
            chenDictContainer.visible = false;
            enchDictContainer.setData(queryRes);
//            enchDictContainer.visible = true;
            haveEnres = true;
            isHaveRes = true;
        }
        else if(queryRes["trans"] !== undefined){
            trans.setDataText(queryRes["trans"],queryRes["word"])
            tip.visible = false;
            enchDictContainer.visible = false;
            chenDictContainer.visible = false;
            trans.visible = true;
            haveEnres = true;
            isHaveRes = true;
            if(isOnLineTrans){
                pingManager.addPingData(PingDefine.PING_EVENT_TRANS_ONLINE);
            }
        }
        else{
            haveEnres = false;
            trans.visible = false;
            enchDictContainer.visible = false;
            chenDictContainer.visible = false;
            tip.visible = true;
            tip.tips = qsTr("抱歉，没有查询到结果");
        }

        isHaveEnRes = haveEnres;
        if(isHaveEnRes && root.isScanQuery){
            root.isScanQuery = false;
            WordHistoryManager.addHistoryItem(Segmentation.getInputSent());
        }
        errorControl.visible = true;
        if(dataManager.getLive()){
            apiNetWork.sendApiSearchPic();
        }
        isOnLineTrans = false;
    }


    function updateDictRes(strWord){
        flickable.updateDictRes(strWord);
    }

    function toTop(){
        flickable.contentY = 0;
    }

    function toPos(pos){
        flickable.contentY = pos;
    }

    function getPos(){
        return flickable.contentY;
    }

    function store(){
        isWordStored = true;
        var valueObj = new Object;
        valueObj["store"] = "true"
        if(Segmentation.isEnglishStr(root.currentWord)){
            valueObj["wordType"] = "en"
            var highfre = false
            if(root.currrentRes["zybResult"] !== undefined){
                var zybdictRes = root.currrentRes["zybResult"];
                if(zybdictRes["highfreq"] !== undefined){
                    if(zybdictRes["highfreq"] === 1){
                        highfre = true;
                    }
                }
            }
            WordHistoryManager.addStoreItem(root.currrentRes,1,highfre);
        }
        else{
            valueObj["wordType"] = "ch"
            WordHistoryManager.addStoreItem(root.currrentRes,0);
        }
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_STORE,valueObj);
    }

    function unStore(){
        isWordStored = false;
        var valueObj = new Object;
        valueObj["store"] = "false"
        if(Segmentation.isEnglishStr(root.currentWord)){
            valueObj["wordType"] = "en"
            WordHistoryManager.removeStoreItem(root.currentWord,1);
        }
        else{
            valueObj["wordType"] = "ch"
            WordHistoryManager.removeStoreItem(root.currentWord,0);
        }
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_STORE,valueObj);
    }
    function start(scanRes){

//        console.log("start(scanRes)++++++++++++++++++++++++++++++")

//        scanRes = qsTr("晋陶渊明独爱菊")
//        Segmentation.setSentObj(str);
//        scanRes = qsTr("listen");

        Segmentation.setSentObj2(scanRes);
        root.isScanQuery = true;
        var valueObj = new Object;
        if(Segmentation.isEnglishStr(scanRes)){
            valueObj["wordType"] = "en";
        }
        else{
            valueObj["wordType"] = "ch";
        }
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_NUM,valueObj);
        helpButton.visible = true;
        devManager.moveWordPic();
    }

    function startNoHistory(strInput){
//        if(dataManager.getLive() === true){
//            UILogic.openWebSocket(2);
//            websocketConnectTimer.start();
//        }
        Segmentation.setSentObj2(strInput);
        root.isScanQuery = false;
        helpButton.visible = false;
    }
}
