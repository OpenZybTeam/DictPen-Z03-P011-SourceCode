import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybCamera"
import "../ZybControls"
import "./"
import DataManager.PageModeDefine 1.0
import RemoteDataManager.PermissionDefine 1.0
import com.zyb.PingDefine 1.0
Rectangle {
    id:storeUI
    anchors.fill: parent
    color: Style.mainbgColor
    property var pageType: "storepage"
    property alias storeModel : view1.model
    property string notext: ""
    property color bgColor:  "#3C3D42"
    property bool isAllLoaded:false
    property bool isSearching:false
    property bool isDownloading : false
    property string curClickTid : ""
    property bool delVisibel : false
    property  var res : new Object;
    property string frontState : ""

    signal gotoWordPage()
    signal backClicked()
    state: "normal"


    PopupDialog
    {
        id:dig
        //        x: (parent.width - width) / 2
        //        y: (parent.height - height) / 2
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("确定清空所有内容?")
        onLeftClicked:
        {
            dig.close();
        }

        onRightClicked:
        {
            dig.visible = false
            dataManager.clearQuesStoreList();
            storeUI.state = "normal"
            dig.close();
            initTips();
            pingManager.addPingData(PingDefine.PING_EVENT_STORE_TID_CLEAR);
        }

    }

    ZybText {
        id: tiptext
        text:  qsTr("还没有收藏的内容哦")
        font.pixelSize: Style.tipFontPixel
        //        font.weight: Font.Bold
        font.styleName: "Normal"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 25
        z:2
        visible: false
    }


    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    console.log("normal state")
                    //cancel.visible = false
                    //printCheckedArray = [];
                    if(storeModel)
                        storeModel.clearChecked();
                }
            }
        },
        State {
            name: "edit"
            StateChangeScript {
                script: {
                    console.log("edit state")
                    //back.visible = false
                }
            }
        },

        State {
            name: "print"
            StateChangeScript {
                script: {
                    console.log("print state")
                    //back.visible = false
                }
            }
        },

        State {
            name: "printPreview"
            StateChangeScript {
                script: {
                    console.log("printPreview state")
                    //back.visible = false
                }
            }
        },

        State {
            name: "searchResult"
            StateChangeScript {
                script: {
                    console.log("searchResult state")
                    //back.visible = false
                }
            }
        },

        State {
            name: "searchNoResult"
            StateChangeScript {
                script: {
                    console.log("searchNoResult state")
                    //back.visible = false
                }
            }
        }
    ]

    onStateChanged:
    {
        topbtn.visible = false
    }

    PopupDialog
    {
        id:noResTip
        //        x: (parent.width - width) / 2
        //        y: (parent.height - height) / 2
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("抱歉，没有找到这道题目哦～")
        leftTxtVisble: false
        visible: storeUI.state === "searchNoResult"

        onRightClicked:
        {
            storeUI.state = "normal"
            noResTip.close();
        }
    }

    ApiResultPage{
        id : apiresultpage
        anchors.fill: parent
        isHistory: true
        visible: storeUI.state === "searchResult"
        z:100
        onBackClicked:
        {
            storeUI.state = "normal"
        }

        onWebLoadFinshed:
        {
            storeUI.state = "searchResult"
            storebusyIndicator.visible = false;
            isSearching = false
        }

        onPrintBtnClicked:
        {
            frontState = "searchResult";
            storebusyIndicator.visible = true
            startAsyncCreatePrintPage(false);
            res = {};
            pingManager.addPingData(PingDefine.PING_EVENT_PRINT_PREVIEW_SIGNAL);
        }
    }

    Image{
        id : topbtn
        source: "qrc:/images/top66x56.png"
        //visible: view.flicking
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 26
        z:9
        MouseArea{
            anchors.fill: parent
            anchors.margins: -10
            onClicked: {
                view1.positionViewAtBeginning()
            }
        }
    }

    Timer{
        id:flicktimer
        interval: 2000;
        repeat: false;
        running: false
        onTriggered: {
            topbtn.visible = false
        }
    }


    property int nPullHeight: 48


    function funDownRefresh(){
        if(isAllLoaded === false)
        {
            console.debug(qsTr("启动下刷新..."))
            //console.info("view1.contentHeight=",view1.contentHeight,"view1.contentY=",view1.contentY,"view1.height=",view1.height, nPullHeight)
            view1.y = -nPullHeight;

            if(devManager.isLogin())
            {
                if(isDownloading === true)
                    return;
                isDownloading = true;
                dataManager.getNextPageStoreList();
            }

            busyDownRefresh.running = false;
            timerDownRefresh.start();
        }
        else
        {
            console.debug(qsTr("启动下刷新...isAllLoaded=true"))
        }
    }

    BusyIndicator {
        id: busyDownRefresh
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: 48
        implicitHeight: 48
        opacity: running ? 0.0 : 1.0
        z:18
        contentItem: QmlBusyIndicator{}
    }

    Timer{
        id: timerDownRefresh
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            busyDownRefresh.running = true;
            aniDownRefresh.start();
        }
    }

    NumberAnimation {
        id: aniDownRefresh
        target: view1
        property: "y"
        duration: 200
        from: -nPullHeight
        to: 0
        onStopped: {
            view1.contentY = view1.contentHeight - view1.height;
        }
    }

    Timer {
        id:clickTimer
        interval: 20; running: false; repeat: false
        onTriggered:
        {
            if(devManager.isLogin())
            {
                apiNetWork.sendApiGetQuesStore(curClickTid);
            }
            else
            {
                if(apiresultpage.zybhtmlLoaded === false)
                {
                    main.showTip(qsTr("网页加载中，已重试"));
                    loadTidDataTimer.start();
                    return;
                }
                loadTidData();
            }
        }
    }

    Timer
    {
        id:loadTidDataTimer
        repeat: false
        interval: 2000
        onTriggered:
        {
            loadTidData();
        }
    }

    function loadTidData()
    {
        if(apiresultpage.mywebview.loading === true  && apiresultpage.zybhtmlLoaded===true)
        {
            console.log("mywebview.stop()");
            apiresultpage.mywebview.stop();
        }
        apiresultpage.stopLatexTimer();
        apiresultpage.hideVideoItem();
        apiresultpage.hideQrSet();
        apiresultpage.curResultIndex = 0;
        api.setDataFormStoreTid(curClickTid);
        apiresultpage.startUpdateHtml();
    }

    function printConfirmClicked()
    {
        var list = storeModel.getCheckedList();
        console.log("list=",list);
        if(list.length === 0)
        {
            main.showTip(qsTr("未选中任何题！"));
            return;
        }

        if(dataManager.getLive() === false)
        {
            netDig.open();
            return;
        }

        frontState = "print";

        storebusyIndicator.visible = true
        var arrTids = storeModel.getTids(list);
        //console.log(arrTids);
        if(devManager.isLogin() === true)
        {
            apiNetWork.sendApiGetQuesStoreByTidList(arrTids);
        }
        else
        {
            api.setDataFormStoreTids(arrTids);
            startAsyncCreatePrintPage(true);
        }

        res = {};
        pingManager.addPingData(PingDefine.PING_EVENT_PRINT_PREVIEW_MUTI);
    }

    function startAsyncCreatePrintPage(b)
    {
        loader.setSource("qrc:/ZybQmlFiles/ZybCamera/ResultPrintPage.qml",{"muti":b})
    }

    function backedFunc()
    {
        storeUI.state = frontState;
        loader.source = "";
        storebusyIndicator.visible = false
    }

    function setPrintPreviewState()
    {
        storeUI.state = "printPreview";
    }

    function printLoadFinished()
    {
        storebusyIndicator.visible = false
    }

    Loader
    {
        id: loader
        anchors.fill: parent

        onLoaded:
        {
            loader.item.backClicked.connect(backedFunc);
            loader.item.h5LoadFinished.connect(printLoadFinished);
            setPrintPreviewState();
        }
    }


    GridView {
        id:view1

        anchors.fill: parent
        cellWidth: Style.itemWidth; cellHeight: 80
        //cacheBuffer: 20000
        clip: true
        anchors.margins: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible:  storeUI.state === "normal" || storeUI.state === "edit" || storeUI.state==="print"

        header: Item
        {
            id:toplayout
            width:parent.width
            height: 66

            ZybBackButton
            {
                id :back
                anchors.top: parent.top
                anchors.left: parent.left
                visible:  storeUI.state === "normal"
                onBackClicked: {
                    UILogic.backToHome();
                }
            }

            ZybText{
                id :cancel
                text: "取消"
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.verticalCenterOffset: -10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Style.tipFontPixel
                font.weight: Font.Normal
                visible: storeUI.state === "edit" || storeUI.state === "print"
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -26
                    onClicked: {
                        storeUI.state = "normal"
                        initTips();
                    }
                }
            }

            RowLayout
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                BasicButton
                {
                    id:transNaviBtn
                    text: qsTr("生词本")
                    backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                    implicitWidth: 140
                    implicitHeight: 56
                    radius:6
                    fontsize:28
                    autoExclusive: true
                    checked: false
                    checkable: false
                    onClicked: {
                        gotoWordPage();
                    }
                }

                BasicButton
                {
                    id:questionNaviBtn
                    text: qsTr("错题本")
                    backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                    implicitWidth: 140
                    implicitHeight: 56
                    radius:6
                    fontsize:28
                    autoExclusive: true
                    checked: true
                }


            }

            Image{
                id :printBtn
                source: "qrc:/images/print.png"
                anchors.right: del.left
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                //anchors.verticalCenterOffset: -10
                visible: storeUI.state === "normal" && view1.count>0 && questionNaviBtn.checked===true
                objectName: "printBtn"
                z:100
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -15
                    onClicked: {
                        storeUI.state = "print"
                    }
                }

            }

            Image{
                id :del
                source: "qrc:/images/del40x40.png"
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                //anchors.verticalCenterOffset: -10
                visible: storeUI.state === "normal" && view1.count>0
                objectName: "delBtn"
                z:100
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -15
                    onClicked: {
                        storeUI.state = "edit"
                        //del.visible = false;
                        console.log("del onclicked")
                    }
                }

            }



            Image{
                id :clear
                source: "qrc:/images/clear48x36.png"
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -10
                visible: storeUI.state === "edit"
                z:100
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -26
                    onClicked: {
                        dig.visible = true;
                    }
                }
            }

            ZybText
            {
                id:printConfirm
                font.pixelSize: 24
                font.styleName: "Bold"
                color: Style.mainColor
                text: qsTr("确认")
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -10
                visible: storeUI.state === "print"
                z:100
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -26
                    onClicked: {
                        printConfirmClicked();
                    }
                }
            }

        }

        Component {
            id:imgDelegate
            Rectangle {
                radius: 6
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                width: Style.itemWidth-10
                function getCheckStatus()
                {
                    return checkPrint.checked;
                }
                function setCheckedStatus()
                {
                    checkPrint.checked = true;
                }

                height: 70
                //color: "#3C3D42"
                color: mouseArea.pressed ? Qt.darker(bgColor) : bgColor
                opacity: mouseArea.pressed ? 0.49:1
                MouseArea {
                    id:mouseArea
                    anchors.fill: parent

                    onClicked:
                    {
                        if(storeUI.state == "print" || storeUI.state == "edit")
                        {
                            return;
                        }

                        if(isSearching === true)
                        {
                            return;
                        }
                        if(dataManager.getLive() === false)
                        {
                            netDig.open();
                            return;
                        }
                        curClickTid = tid;
                        isSearching = true;
                        storebusyIndicator.visible = true
                        ocrManager.setScanPicMode(false);
                        console.info("Get store tid =", tid);
                        clickTimer.start();
                    }
                }


                CircularImage {
                    id: pic
                    radius: 6
                    anchors.fill: parent
                    img_src: "file:///"  + imagePath
                }

                AppCheckBox
                {
                    id:checkPrint
                    z:2
                    anchors.left : parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.verticalCenterOffset: 6
                    visible: storeUI.state == "print"
                    checked: printChecked

                    onCheckStateChanged:
                    {
                        //console.log("onCheckStateChanged",index,checked)
                        //storeModel.setChecked(index,checked);
                        if(checked)
                        {
                            if(storeModel.checkIsMax(index))
                            {
                                main.showTip(qsTr("每次打印最多选择10道题"));
                                storeModel.setChecked(index,false);
                                checked = false;
                                return;
                            }
                            storeModel.setChecked(index,checked);
                        }
                        else
                        {
                            storeModel.setChecked(index,checked);
                        }
                    }

                    onVisibleChanged:
                    {
                        if(storeUI.state === "normal")
                        {
                            checked = false;
                        }

                    }
                }

                Image {
                    id: highfre
                    visible: bikao===1
                    anchors.top: parent.top
                    anchors.right: parent.right
                    source: "qrc:/images/highfre.png"
                }

                Image{
                    z:3
                    source: "qrc:/images/close44x44.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter:  parent.verticalCenter
                    visible: storeUI.state == "edit"
                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: -25
                        onClicked: {
                            //var path = view.model.data(index).imagePath;
                            pingManager.addPingData(PingDefine.PING_EVENT_STORE_TID_DEL);

                            console.log("cur clicked index",index);
                            if(devManager.isLogin() === true)
                            {
                                if(dataManager.getLive() === false)
                                {
                                    netDig.open();
                                    return;
                                }
                            }

                            dataManager.delOneQuesStoreItem(index);

                            if(devManager.isLogin() === false)
                            {
                                initTips();
                                if(storeModel.rowCount() === 0)
                                    storeUI.state = "normal";
                            }

                        }
                    }
                }
            }


        }

        states: [
            State {
                id: downRefresh
                name: "downRefresh";
                when: isAllLoaded===false && (view1.contentHeight > 0  && view1.contentY > 66 ) && (view1.contentY > (view1.contentHeight - storeUI.height + nPullHeight-20))
                //when: isAllLoaded===false && (view1.contentHeight > 0  && view1.contentY > 66 ) && (view1.contentY > (view1.contentHeight - view1.height))
                StateChangeScript {
                    name: "funDownRefresh"
                    script: funDownRefresh()
                }
            }//,
            //            State {
            //                id: upRefresh
            //                name: "upRefresh"; when: (listView.contentY < -nPullHeight)
            //                StateChangeScript {
            //                    name: "funUpRefresh"
            //                    script: funUpRefresh()
            //                }
            //            }
        ]

        model: storeModel
        delegate: imgDelegate
        focus: true

        footer:Rectangle {
            width: view1.width
            height: 0.7 * view1.cellHeight
            color: "transparent"
            ZybText {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
                color:"#999999"
                text:qsTr("已经到底")
                visible: isAllLoaded===true && view1.model.rowCount() >= 4
            }
        }


        onFlickStarted:
        {
            if(view1.model.rowCount() > 8)
                topbtn.visible = true
        }

        onFlickEnded:
        {
            flicktimer.restart();
        }
    }


    Connections
    {
        target: apiNetWork

        onSig_getStoreAnswerFailed:
        {
            storeUI.state = "searchNoResult";
            isSearching = false
            storebusyIndicator.visible = false
        }

        onSig_getStoreAnswerSuccess:
        {
            apiresultpage.stopLatexTimer();
            apiresultpage.hideVideoItem();
            if(apiresultpage.zybhtmlLoaded === false)
            {
                isSearching = false
                storebusyIndicator.visible = false
                return;
            }
            //如果正在加载
            if(apiresultpage.mywebview.loading === true  && apiresultpage.zybhtmlLoaded===true)
            {
                console.log("mywebview.stop()");
                apiresultpage.mywebview.stop();
            }
            apiresultpage.curResultIndex = 0;
            api.setDataFromStoreResJson(res);
            apiresultpage.startUpdateHtml();
        }
        onSig_getStoreListSuccess:
        {
            console.log("onSig_getStoreListSuccess");
            //storebusyIndicator.visible = true;
            startAsyncCreatePrintPage(true);
        }

        onSig_searchTimeout:
        {
            storebusyIndicator.visible = false
            main.showTip(qsTr("网络超时，请稍后重试"))
        }

        onSig_getStoreListFirst:
        {
        }

        onSig_getStoreListFailed:
        {
            console.log("onSig_getStoreListFailed");
        }

        onSig_getQuesStoreError:
        {
            initTips();
        }
    }

    Connections {
        target: dataManager;
        onSig_allGeted:
        {
            //-66 122 238
            console.log("onSig_allGeted initTips",view1.contentY,view1.contentHeight,view1.height);
            //
            if(storeModel.rowCount() > 0)
                //view1.contentY = view1.contentHeight - view1.height;
                isAllLoaded = true;

            if(isDownloading === false)
            {
                initTips();
            }
            else
            {
                //view1.footerItem.visible = (storeModel.rowCount()>4 && isAllLoaded===true)
            }

            isDownloading = false;
        }

        onSig_storePageDownloadFinished:
        {
            if(downloaded)
                view1.contentY = view1.contentHeight - view1.height;
            console.info("view1.contentY =",view1.contentY);
            initTips();
            isDownloading = false;
            if(storeModel.rowCount() <= 20)
                view1.positionViewAtBeginning()
        }

        onSig_updateStorePageTip:
        {
            console.log("onSig_updateStorePageTip initTips");
            isDownloading = false;
            initTips();
            if(storeModel.rowCount() === 0)
                storeUI.state = "normal";
        }

        onSig_updateStorePage:
        {
            tiptext.visible = (storeModel.rowCount()===0)
        }

    }

    function initTips()
    {
        console.log("onSig_storePageDownloadFinished initTips",isAllLoaded,storeModel.rowCount());
        view1.footerItem.visible = (storeModel.rowCount()>=4 && isAllLoaded===true)
        tiptext.visible = (storeModel.rowCount()===0)
        storebusyIndicator.visible = false;
    }

    Loading
    {
        id:storebusyIndicator
        anchors.centerIn: parent
        visible: false
        z:1900
    }

    Timer {
        id:initTimer
        interval: 1; running: false; repeat: false
        onTriggered:
        {
            console.log("init timer triggered for store page");
            loadModelData();
        }
    }

    function loadModelData()
    {
        dataManager.initQuesStoreModelData();
        if(devManager.isLogin())
        {
            if(dataManager.getLive())
            {
                tiptext.text = qsTr("还没有收藏的内容哦");
                isDownloading = true;
                dataManager.getFirstPageQuesStoreData();
            }
            else
            {
                tiptext.text = qsTr("请联网更新");
                initTips();
            }
        }
        else
        {
            isAllLoaded = true;
            if(dataManager.getLive() === false)
            {
                tiptext.text = qsTr("请联网更新");
            }

            console.log("loadModelData isLogin=false initTips");
            initTips();
        }

        view1.positionViewAtBeginning()
    }


    Component.onCompleted:
    {
        dataManager.setUIMode(PageStatus.UI_Store);
        apiresultpage.scanMode = false;
        storebusyIndicator.visible = true;
        if(devManager.isLogin())
        {
            storeModel = quesStoreUserModel;
        }
        else
        {
            storeModel = quesStoreTempModel;
        }

        initTimer.start();
    }

    onVisibleChanged:
    {
        if(visible === false)
        {
            isSearching = false;
            storebusyIndicator.visible = false;
        }

    }

    Component.onDestruction:
    {
        isDownloading = false
        isSearching = false;
        storebusyIndicator.visible = false;
        storeModel.clear();
    }

}
