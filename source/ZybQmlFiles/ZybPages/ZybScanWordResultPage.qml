import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import com.zyb.PingDefine 1.0

Flickable{
    id:root
    contentHeight: colume.height + 50
    ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
    clip : true
    signal toMiaoHongPage();
    signal toWywPage(var data)
    signal toEnChPage(var data);
    signal back();
    signal isStored(var stored)
    signal topBtnVisible(var visible);
    property var currentWord: ""
    property var dictFirst: 0 //优先展示词典
    property var currrentRes: new Object
    property var contentCoordY: 0 //记录滚动条位置
    property var preContentY: 0 //判断滑动方向
    property var isHaveQueryRes: true
    property bool isScanQuery: true
    property bool isWordStored: false



    Timer{
        id:flicktimer
        interval: 1500;
        repeat: false;
        running: false
        onTriggered: {
            topBtnVisible(false);
        }
    }

    onFlickStarted:
    {
        console.log("contentY:",contentY,"preContentY:",preContentY);
        if(contentY > Style.gHeight){
            topBtnVisible(true);
            flicktimer.stop();
        }
    }

    onMovementEnded: {
        preContentY = contentY;
        console.log("contentY:",contentY);
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
//                    UILogic.backToHome()
                }
            }

//            ZybStoreButton{
//                id:storeButton
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.right: parent.right
//                visible: root.isHaveQueryRes
//                onClicked: {
//                    isStored = !isStored;
//                    if(!isStored){
//                        if(QueryWordManager.m_isEnglish){
//                            WordHistoryManager.removeStoreItem(root.currentWord,1);
//                        }
//                        else{
//                            WordHistoryManager.removeStoreItem(root.currentWord,0);
//                        }

//                    }
//                    else{
//                        if(QueryWordManager.m_isEnglish){
//                            WordHistoryManager.addStoreItem(root.currrentRes,1);
//                        }
//                        else{
//                            WordHistoryManager.addStoreItem(root.currrentRes,0);
//                        }

//                    }
//                }
//            }

            ZybWordsControl{
                id:wordControl
                anchors.left: backButton.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 72
                onSignalQuery: {
//                    console.log("colume.width=",colume.width)
                    root.currentWord = strData;
                    updateDictRes(strData);
//                    var str = qsTr("12345678");
//                    updateDictRes(str);
                }
            }
        }
        Item {
            height: 16
            width: parent.width
        }
        Item {
            id: dictContainer
            width:colume.width - 72
            height: (enChexplain.visible ?  enChCol.height : 0) + (chEnDict.visible ?  chEnCol.height : 0) + (xinhuaDict.visible ?  xinhuaCol.height : 0) + (xiandaiDict.visible ?  xiandaiCol.height : 0) + (idiomDict.visible ?  idiomCol.height : 0) + (wywDict.visible ?  wywCol.height : 0)
            Column{
                id:enChCol
//                width:parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.right: parent.right
                anchors.rightMargin: 16
                height: enChexplain.visible ? enChexplain.height : 0
                EnChDictControl{
                    id:enChexplain
                    visible: false
                    width:parent.width
                }
            }



            Column{
                id:chEnCol
                width:parent.width
                anchors.top: enChCol.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                height: chEnDict.visible ? (chEnDict.height + chenSpliter.height) : 0
                ChEnDictControl{
                    id:chEnDict
                    visible: false
                    width:parent.width
                    onShowDetailed: {
//                        console.log("enchControl clicked");
                        toEnChPage(data);
                    }
                }
                PageSpliter{
                    id: chenSpliter
                    visible: chEnDict.visible
                }
            }

            Column{
                id:xiandaiCol
                width:parent.width
                anchors.top: chEnCol.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                height: xiandaiDict.visible ? (xiandaiDict.height + xiandaiSpliter.height) : 0
                XianDaiDictControl{
                    id:xiandaiDict
                    visible: false
                    width:parent.width
                    onToMiaoHongPage1: {
//                        console.log("onToMiaoHongPage1")
                        toMiaoHongPage();
                    }
                }
                PageSpliter{
                    id: xiandaiSpliter
                    visible: xiandaiDict.visible
                }
            }

            Column{
                id:xinhuaCol
                width:parent.width
                anchors.top: xiandaiCol.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                height: xinhuaDict.visible ? (xinhuaDict.height + xinhuaSpliter.height) : 0
                XinHuaDictControl{
                    id:xinhuaDict
                    visible: false
                    width:parent.width
                    onToMiaoHongPage1: {
//                        console.log("onToMiaoHongPage1")
                        toMiaoHongPage();
                    }
                }

                PageSpliter{
                    id: xinhuaSpliter
                    visible: xinhuaDict.visible
                }
            }

            Column{
                id:idiomCol
                property var contentVisible: false
                width:parent.width
                anchors.top: xinhuaCol.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                height: idiomDict.visible ? (idiomDict.height + idiomSpliter.height) : 0
                IdiomControl{
                    id:idiomDict
                    visible: false
                    width:parent.width
                }
                PageSpliter{
                    id: idiomSpliter
                    visible: idiomDict.visible
                }
            }

            Column{
                id:wywCol
//                width:parent.width
                anchors.top: idiomCol.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                height: wywDict.visible ? (wywDict.height + wywSpliter.height) : 0
                WywControl{
                    id:wywDict
                    visible: false
                    width:parent.width
                    onShowDetailed: {
                        toWywPage(data);
                    }
                }
                PageSpliter{
                    id: wywSpliter
                    visible: wywDict.visible
                }
            }
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
            ZybErrorButton{
                id: errorButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                onReport: {
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
//            console.log("queryTimer onTriggered")
            tip.visible = true;
            tip.tips = qsTr("正在查询......");
        }
    }

    Connections{
        target: Segmentation
        onSigSentChanged:{
//            console.log("onSigSentChanged+++++++++++++++++++++++++++++++++++++")
            var wordModel = new Array;
            wordModel = Segmentation.getSentObj();
            wordControl.setData(wordModel);
            //updateDictRes(qsTr("安抚"));
        }
    }

    property var isHaveChEnRes: false
    property var isHaveXinhuaXiandaiRes: false
    property var isHaveIdiomRes: false
    property var isHaveWywRes: false

    Connections{
        id:queryConnect
        target: QueryWordManager
        onQueryChFinished:{
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
                isStored(true);
                isWordStored = true;
//                storeButton.isStored = true;
            }
            else{
                isStored(false);
                isWordStored = false;
//                storeButton.isStored = false;
            }
            var isHaveRes = false;
            if(queryRes["issent"] === 0 || queryRes["issent"] === false){
                isHaveChEnRes = false;
                isHaveXinhuaXiandaiRes = false;
                isHaveIdiomRes = false;
                isHaveWywRes = false;
                if(queryRes["ch_en_result"] !== undefined){
                    isHaveChEnRes = true;
                    var chenRes = queryRes["ch_en_result"];
//                    console.log("chquer++++++++++++2")
                    if(dictFirst === 0){
                        var chWordObj = new Object;
                        if(queryRes["xiandai_result"] !== undefined){
                            var xiandaiData = queryRes["xiandai_result"];
                            var xiandaiExplains = xiandaiData["explains"];
                            var xiadaiExplainItem = xiandaiExplains[0];
                            chWordObj["word"] = xiandaiData["word"];
                            chWordObj["phonetic"] = xiadaiExplainItem["phonetic"];
                            chenRes["chword"] = chWordObj;
                        }

                        if(queryRes["xinhua_result"] !== undefined){
                            var xinhuaData = queryRes["xinhua_result"];
                            var xinhuaExplains = xinhuaData["explains"];
                            if(xinhuaExplains.length === 1){
                                var xinhuaExpItem = xinhuaExplains[0];
                                chWordObj["word"] = xinhuaData["word"];
                                chWordObj["phonetic"] = xinhuaExpItem["phonetic"];
                                chenRes["chword"] = chWordObj;
                            }
                        }
                        if(queryRes["idiom_result"] !== undefined){
                            var idiomData = queryRes["idiom_result"];
                            chWordObj["word"] = idiomData["word"];
                            chWordObj["phonetic"] = idiomData["phonetic"];
                            chenRes["chword"] = chWordObj;
                        }

                    }
                    chEnDict.setData(chenRes,false);
                    chEnDict.visible = true;
                    isHaveRes = true;
                }

                if(queryRes["trans"] !== undefined){
                    isHaveChEnRes = true;
                    var transRes = new Object;//["trans"] = queryRes["trans"];
                    transRes["trans"] = queryRes["trans"]
//                    console.log("chquer++++++++++++2")
                    if(dictFirst === 0){
                        chWordObj = new Object;
                        if(queryRes["xiandai_result"] !== undefined){
                            xiandaiData = queryRes["xiandai_result"];
                            xiandaiExplains = xiandaiData["explains"];
                            xiadaiExplainItem = xiandaiExplains[0];
                            chWordObj["word"] = xiandaiData["word"];
                            chWordObj["phonetic"] = xiadaiExplainItem["phonetic"];
                            transRes["chword"] = chWordObj;
                        }

                        if(queryRes["xinhua_result"] !== undefined){
                            xinhuaData = queryRes["xinhua_result"];
                            xinhuaExplains = xinhuaData["explains"];
                            if(xinhuaExplains.length === 1){
                                xinhuaExpItem = xinhuaExplains[0];
                                chWordObj["word"] = xinhuaData["word"];
                                chWordObj["phonetic"] = xinhuaExpItem["phonetic"];
                                transRes["chword"] = chWordObj;
                            }
                        }
                        if(queryRes["idiom_result"] !== undefined){
                            idiomData = queryRes["idiom_result"];
                            chWordObj["word"] = idiomData["word"];
                            chWordObj["phonetic"] = idiomData["phonetic"];
                            transRes["chword"] = chWordObj;
                        }

                    }
                    chEnDict.setData(transRes,true);
                    chEnDict.visible = true;
                    isHaveRes = true;
                }


                if(queryRes["xiandai_result"] !== undefined){
                    isHaveXinhuaXiandaiRes = true;
//                    console.log("chquer++++++++++++3")
                    xiandaiDict.visible = true;
                    if(dictFirst === 0){
                        if(isHaveChEnRes === false){
                            xiandaiDict.setData(queryRes["xiandai_result"],true);
                        }
                        else{
                            xiandaiDict.setData(queryRes["xiandai_result"],false);
                        }

                    }
                    else if(dictFirst === 1)
                    {
                        xiandaiDict.setData(queryRes["xiandai_result"],true);
                    }

                    isHaveRes = true;
                }

                if(queryRes["xinhua_result"] !== undefined){
//                    console.log("chquer++++++++++++xinhua")
                    isHaveXinhuaXiandaiRes = true;
                    xinhuaDict.visible = true;
                    if(dictFirst === 0){
                        if(isHaveChEnRes === false){
                            xinhuaDict.setData(queryRes["xinhua_result"],true);
                        }
                        else{
                            xinhuaDict.setData(queryRes["xinhua_result"],false);
                        }

                    }
                    else if(dictFirst === 1)
                    {
                        xinhuaDict.setData(queryRes["xinhua_result"],true);
                    }
                    isHaveRes = true;
                }


                if(queryRes["idiom_result"] !== undefined){
                    isHaveIdiomRes = true;
//                    console.log("chquer++++++++++++4")
                    idiomDict.visible = true;

                    if(dictFirst === 0){
                        if(isHaveChEnRes === false){
                            idiomDict.setData(queryRes["idiom_result"],true);
                        }
                        else{
                            idiomDict.setData(queryRes["idiom_result"],false);
                        }

                    }
                    else if(dictFirst === 1)
                    {
                        idiomDict.setData(queryRes["idiom_result"],true);
                    }

                    isHaveRes = true;
                }
                if(queryRes["wyw_result"] !== undefined){
                    isHaveWywRes = true;
//                    console.log("chquer++++++++++++6")
                    wywDict.setData(queryRes["wyw_result"]);
                    wywDict.visible = true;
                    isHaveRes = true;
                }

                chEnDict.isTitleViseble = true;
                xinhuaDict.isTitleViseble = true;
                xiandaiDict.isTitleViseble = true;
                idiomDict.isTitleViseble = true;
                wywDict.isTitleViseble = true;
                dictFirst = devManager.getSelCurDict();
                if(dictFirst === 0){
                    chEnDict.isTitleViseble = false;
                    if(isHaveChEnRes === false){
                        xiandaiDict.isTitleViseble = false;
                        xinhuaDict.isTitleViseble = false;
                    }
                    if(isHaveXinhuaXiandaiRes === false && isHaveChEnRes === false){
                        idiomDict.isTitleViseble = false;
                    }
                    if(isHaveXinhuaXiandaiRes === false && isHaveChEnRes === false && isHaveIdiomRes === false){
                        wywDict.isTitleViseble = false;
                    }
                }
                else if(dictFirst === 1){
                    xiandaiDict.isTitleViseble = false;
                    xinhuaDict.isTitleViseble = false;
                    if(isHaveXinhuaXiandaiRes === false){
                        idiomDict.isTitleViseble = false;
                    }
                    if(isHaveXinhuaXiandaiRes === false && isHaveIdiomRes === false){
                        wywDict.isTitleViseble = false;
                    }
                    if(isHaveXinhuaXiandaiRes === false && isHaveIdiomRes === false && isHaveWywRes === false){
                        chEnDict.isTitleViseble = false;
                    }
                }
                isHaveQueryRes = true;
            }
            else if(queryRes["trans"] !== undefined){
//                trans.orgText = queryRes["word"];
                trans.setDataText(queryRes["trans"],queryRes["word"])
//                trans.transText = queryRes["trans"];

                trans.visible = true;
                isHaveRes = true;
                isHaveQueryRes = true;

            }
            else{
                isHaveQueryRes = false;
                tip.visible = true;
                tip.tips = qsTr("抱歉，没有查询到结果");
            }

            if(isHaveQueryRes && root.isScanQuery){
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
        }

        onQueryEngFinished:{
            QueryWordManager.playStop();
            errorButton.isReport = false;
            if(!visible){
                return;
            }
            console.log("onQueryEngFinished+++++++++++++++")
            queryTimer.stop();
            tip.visible = false;
            root.currrentRes = resObj;
            var queryRes = resObj;
            if(WordHistoryManager.isWordStore(queryRes["word"])){
                isStored(true);
                isWordStored = true;
//                storeButton.isStored = true;
            }
            else{
                isStored(false);
                isWordStored = false;
//                storeButton.isStored = false;
            }
            if(queryRes["issent"] === 0 || queryRes["issent"] === false){

                enChexplain.wordText = queryRes["word"];
                enChexplain.setData(queryRes["result"]);
                enChexplain.visible = true;
                tip.visible = false;
                isHaveQueryRes = true;
            }
            else if(queryRes["trans"] !== undefined){
//                trans.transText = queryRes["trans"];
                trans.setDataText(queryRes["trans"],queryRes["word"])
//                trans.setTransText(queryRes["trans"])
//                trans.orgText = queryRes["word"];
                trans.visible = true;
                tip.visible = false;
                isHaveQueryRes = true;
            }
            else{
                isHaveQueryRes = false;
                tip.visible = true;
                tip.tips = qsTr("抱歉，没有查询到结果");
            }

            if(isHaveQueryRes && root.isScanQuery){
                root.isScanQuery = false;
                WordHistoryManager.addHistoryItem(Segmentation.getInputSent());
            }
            errorControl.visible = true;
            if(dataManager.getLive()){
                apiNetWork.sendApiSearchPic();
            }

        }
    }

    Component.onCompleted: {
        resetDictPosition();
        queryConnect.enabled = true;
    }

    onVisibleChanged: {
        if(visible){
            resetDictPosition();
            queryConnect.enabled = true;
            contentY = contentCoordY;  //设置滚动条位置
        }
        else{
            queryConnect.enabled = false;
            contentCoordY = contentY; //记录滚动条位置
        }
    }

    function toTop(){
        root.contentY = 0;
    }

    function store(){
        isWordStored = true;
        var valueObj = new Object;
        valueObj["store"] = "true"
        if(QueryWordManager.m_isEnglish){
            valueObj["wordType"] = "en"
            WordHistoryManager.addStoreItem(root.currrentRes,1);
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
        if(QueryWordManager.m_isEnglish){
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

//        scanRes = qsTr("徼")
//        Segmentation.setSentObj(str);
//        scanRes = qsTr("a lot of");

        Segmentation.setSentObj2(scanRes);
        var valueObj = new Object;
        if(Segmentation.isEnglishStr(scanRes)){
            valueObj["wordType"] = "en";
        }
        else{
            valueObj["wordType"] = "ch";
        }
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_NUM,valueObj);
        root.isScanQuery = true;
    }

    function startNoHistory(strInput){
        Segmentation.setSentObj2(strInput);
        root.isScanQuery = false;
    }

    function getText(){
        var explainText;
        explainText = "<font color=\"#FF0000\">" + "在河南省    内乡县时" + "</font>" +  "<font color=\"#FFFFFF\">" + "___他看到这里的群众生活困苦就写信给自己的妻子" + "</font>"  ;
        return explainText;
    }

    function updateDictRes(strWord){
//        console.log("---------------------updateDictRes")
        var queryRes;
        enChexplain.visible = false;
        chEnDict.visible = false;
        xiandaiDict.visible = false;
        xinhuaDict.visible = false;
        idiomDict.visible = false;
        trans.visible = false;
        wywDict.visible = false;
        errorControl.visible = false;

        //if(Segmentation.isEnglishStr())
        if(Segmentation.isEnglishStr(strWord)){
            queryRes = QueryWordManager.queryEnglish(strWord);
            queryTimer.start();
        }
        else{
            queryRes = QueryWordManager.queryChinese(strWord);
            queryTimer.start();
        }

//        busyImg.visible = true;

    }

    function resetDictPosition(){
        dictFirst = devManager.getSelCurDict();

        if(dictFirst === 0){
            chEnDict.isTitleViseble = false;
            chEnCol.anchors.top = enChCol.bottom;
            if(isHaveChEnRes === false){
                xiandaiDict.isTitleViseble = false;
                xinhuaDict.isTitleViseble = false;
            }
            xiandaiCol.anchors.top = chEnCol.bottom;
            xinhuaCol.anchors.top = xiandaiCol.bottom;
            if(isHaveXinhuaXiandaiRes === false && isHaveChEnRes === false){
                idiomDict.isTitleViseble = false;
            }
            idiomCol.anchors.top = xinhuaCol.bottom;
            if(isHaveXinhuaXiandaiRes === false && isHaveChEnRes === false && isHaveIdiomRes === false){
                wywDict.isTitleViseble = false;
            }
            wywCol.anchors.top = idiomCol.bottom;
        }
        else if(dictFirst === 1){
            xiandaiDict.isTitleViseble = false;
            xinhuaDict.isTitleViseble = false;
            xiandaiCol.anchors.top = enChCol.bottom;
            xinhuaCol.anchors.top = xiandaiCol.bottom;
            if(isHaveXinhuaXiandaiRes === false){
                idiomDict.isTitleViseble = false;
            }
            idiomCol.anchors.top = xinhuaCol.bottom;
            if(isHaveXinhuaXiandaiRes === false && isHaveIdiomRes === false){
                wywDict.isTitleViseble = false;
            }
            wywCol.anchors.top = idiomCol.bottom;
            if(isHaveXinhuaXiandaiRes === false && isHaveIdiomRes === false && isHaveWywRes === false){
                chEnDict.isTitleViseble = false;
            }
            chEnCol.anchors.top = wywCol.bottom;
        }
        else if(dictFirst === 2){
            idiomCol.anchors.top = enChCol.bottom;
            xiandaiCol.anchors.top = idiomCol.bottom;
            xinhuaCol.anchors.top = xiandaiCol.bottom;
            wywCol.anchors.top = xinhuaCol.bottom;
            chEnCol.anchors.top = wywCol.bottom;
        }
        else if(dictFirst === 3){
            wywCol.anchors.top = enChCol.bottom;
            xiandaiCol.anchors.top = wywCol.bottom;
            xinhuaCol.anchors.top = xiandaiCol.bottom;
            idiomCol.anchors.top = xinhuaCol.bottom;
            chEnCol.anchors.top = idiomCol.bottom;
        }
    }
}



