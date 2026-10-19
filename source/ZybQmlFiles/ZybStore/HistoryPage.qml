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
    id:historyUI
    anchors.fill: parent
    color: Style.mainbgColor
    property color bgColor: Qt.rgba(60/255,61/255,66/255,0.6) //"#3C3D42"
    property alias hisModel : view1.model
    property var pageType: "historypage"
    property bool delVisibel : false
    signal backClicked()
    signal gotoWordPage()
    property  var res : new Object;

    state: "normal"
    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    console.log("normal state")
                    rotionImg.visible = false
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
            name: "NoPermission"
            StateChangeScript {
                script: {
                    console.log("NoPermission state")
                }
            }
        },
        State {
            name: "searchResult"
            StateChangeScript {
                script: {
                    console.log("searchResult state")
                }
            }
        },

        State {
            name: "searchNoResult"
            StateChangeScript {
                script: {
                    console.log("searchNoResult state")
                }
            }
        },

        State {
            name: "printPreview"
            StateChangeScript {
                script: {
                    console.log("printPreview state")
                }
            }
        }
    ]

    onStateChanged:
    {
        topbtn.visible = false
    }

    Loading
    {
        id:rotionImg
        anchors.centerIn: parent
        visible: false
        z:900
    }

    PopupDialog
    {
        id:dig
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
            dataManager.clearQuesHistoryList();
            historyUI.state = "normal"
            dig.close();
            initTip();
        }



    }

    ZybTextTipPage
    {
        id:noPermission
        anchors.fill: parent
        visible: historyUI.state === "NoPermission"

        onBackToParent:
        {
            historyUI.state = "normal"
        }
    }

    PopupDialog
    {
        id:noResTip
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("抱歉，没有找到这道题目哦～")
        leftTxtVisble: false
        visible: historyUI.state === "searchNoResult"

        onRightClicked:
        {
            historyUI.state = "normal"
            noResTip.close();
        }

        onClosed:
        {
            historyUI.state = "normal";
        }
    }

    Connections {
        target: apiNetWork;
        onSig_updateQuesResult:
        {
            console.time("wmm: onSig_updateQuesResult");
            moreRes.init(api.getListNum());

            if(devManager.isLeftHand === false)
                moreRes.x = historyUI.width - moreRes.width +15
            else
                moreRes.x = historyUI.width +15

            rotionImg.visible = true;
            apiresultpage.curResultIndex = 0;
            apiresultpage.imgPath = imgFullPath;
            loadtimer.start();
        }

        onSig_noQuesResultFind:
        {
            if(code == 417)
            {
                noResTip.content = qsTr("老师累了，亲你也歇会儿！")
            }
            else
            {
                noResTip.content = qsTr("抱歉，没有找到这道题目哦～")
            }

            historyUI.state = "searchNoResult"
            hideRotationImg();
        }

        onSig_noPermission:
        {
            hideRotationImg();
            historyUI.state = "NoPermission"
        }

        onSig_noToken:
        {
            hideRotationImg();
            historyUI.state = "normal"
            main.showTip(qsTr("网络异常，请检查后重试"))
        }

        onSig_searchTimeout:
        {
            hideRotationImg();
            historyUI.state = "normal"
            main.showTip(qsTr("网络超时，请稍后重试"))
        }
    }


    function hideRotationImg()
    {
        rotionImg.visible = false
    }


    ApiResultPage{
        id : apiresultpage
        anchors.fill: parent
        isHistory: true
        visible: historyUI.state === "searchResult"
        z:100

        onBackClicked:
        {
            historyUI.state = "normal"
            moreRes.visible = false;
        }

        onMoreClicked:{
            moreRes.visible = true;
        }

        onWebLoadFinshed:
        {
            if(api.getListNum() > 0)
            {
                historyUI.state = "searchResult"
            }
            else
            {
                historyUI.state = "searchNoResult"
            }

            hideRotationImg();
        }

        onPrintBtnClicked:
        {
            rotionImg.visible = true
            topbtn.visible = false;
            startAsyncCreatePrintPage();
            res = {};
            pingManager.addPingData(PingDefine.PING_EVENT_PRINT_PREVIEW_SIGNAL);
        }
    }

    Timer {
        id:loadtimer
        interval: 200; running: false; repeat: false
        onTriggered:
        {
            var storePath = api.getStorePath(apiresultpage.curResultIndex);
            apiresultpage.storedPath = storePath;
            apiresultpage.startUpdateHtml();
        }
    }

    function backedFunc()
    {
        loader.source = "";
        historyUI.state = "searchResult";
        rotionImg.visible = false
    }

    function printLoadFinished()
    {
        rotionImg.visible = false
    }

    function setPrintPreviewState()
    {
        historyUI.state = "printPreview";
    }

    function startAsyncCreatePrintPage()
    {
        setPrintPreviewState();
        loader.source = "qrc:/ZybQmlFiles/ZybCamera/ResultPrintPage.qml";
//        var backedFunc = historyUI.backedFunc;
//        var printPreviewFunc = historyUI.setPrintPreviewState;
//        var fin = historyUI.printLoadFinished;
//        UILogic.async_createPrintPage(historyUI,backedFunc,printPreviewFunc,fin,false);
    }


    Loader
    {
        id: loader
        anchors.fill: parent
        visible: historyUI.state === "printPreview"
        onLoaded:
        {
            loader.item.backClicked.connect(backedFunc);
            loader.item.h5LoadFinished.connect(printLoadFinished);
            //setPrintPreviewState();
        }
    }

    MoreResultPage
    {
        id:moreRes
        visible: false
        x: parent.width - width
        y:devManager.isLeftHand?(parent.height-60):60
        z:103

        onNumClicked:
        {
            moreRes.visible = false
            if(apiresultpage.curResultIndex === num)
                return;
            rotionImg.visible = true;
            apiresultpage.curResultIndex = num;
            loadtimer.start();
        }
    }

    ZybText {
        id: tiptext
        text:  qsTr("还没有历史记录哦")
        font.pixelSize: Style.tipFontPixel
//        font.weight: Font.Bold
        font.styleName: "Normal"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 25
        z:2
        visible: view1.model.rowCount()===0 && view1.visible===true
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
    GridView {
        id:view1


        cellWidth: Style.itemWidth; cellHeight: 80
        clip: true
        anchors.fill: parent
        anchors.margins: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible:  historyUI.state === "normal" || historyUI.state === "edit"

        header: Item {

            id:toplayout
            width:parent.width
            height: 66

            ZybBackButton
            {
                id :back
                anchors.top: parent.top
                anchors.left: parent.left
                visible:  historyUI.state === "normal"
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
                visible: historyUI.state === "edit"
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -26
                    onClicked: {
                        historyUI.state = "normal"
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
                    text: qsTr("查词")
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
                    text: devManager.getNetMainTitle()
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
                id :del
                source: "qrc:/images/del26x26.png"
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -10
                visible: historyUI.state === "normal" && view1.count>0
                z:100
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -26
                    onClicked: {
                        historyUI.state = "edit"
                        //del.visible = false
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
                visible: historyUI.state === "edit"
                z:100
                MouseArea{
                    anchors.fill: parent
                    anchors.margins: -26
                    onClicked: {
                        dig.visible = true;
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
                height: 70
                color: mouseArea.pressed ? Qt.darker(bgColor) : bgColor
                opacity: mouseArea.pressed ? 0.49:1

                MouseArea {
                    id:mouseArea
                    anchors.fill: parent
                    onClicked:
                    {
                        if(rotionImg.visible === true)
                        {
                            return;
                        }

                        if(dataManager.getLive() === false)
                        {
                            netDig.open();
                            return;
                        }

                        rotionImg.visible = true
                        ocrManager.setScanPicMode(false);
                        apiNetWork.sendApiSearchQuesResults(pic.img_src);

                    }
                }

//                Image {
//                    id: pic
//                    asynchronous : true
//                    sourceSize.width: parent.width
//                    sourceSize.height: parent.height
//                    anchors.fill: parent
//                    fillMode:   Image.PreserveAspectCrop
//                    source: "file:///"  + imagePath
//                }

                CircularImage {
                    id: pic
                    radius: 6
                    anchors.fill: parent
                    img_src: "file:///"  + imagePath
                }

                Image{
                    z:2
                    source: "qrc:/images/close44x44.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter:  parent.verticalCenter
                    visible: historyUI.state == "edit"
                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: -25
                        onClicked: {
                            console.log("cur clicked index",index);
                            dataManager.delOneQuesHistoryItem(index);
                            initTip();

                            if(hisModel.rowCount() === 0)
                                historyUI.state = "normal";

                        }
                    }
                }
            }
        }

        //model: quesHisModel
        delegate: imgDelegate
        focus: true

        footer:Rectangle {

            width: view1.width
            height: 0.7 * view1.cellHeight
            //color: "transparent"
            color: Style.mainbgColor
            visible: view1.model.rowCount()>4
            ZybText {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
                color:"#999999"
                text:qsTr("已经到底")
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

    Timer {
        id:initTimer
        interval: 1; running: false; repeat: false
        onTriggered:
        {
            loadModelData();
            //view1.contentY = -76;
            hideRotationImg();

        }
    }

    function initTip()
    {
        view1.footerItem.visible = (hisModel.rowCount()>4)
        tiptext.visible = (hisModel.rowCount()===0)
    }

    function loadModelData()
    {
        dataManager.initQuesHisModelData();
        initTip();
    }

    Component.onCompleted:
    {
        apiresultpage.scanMode = true;
        dataManager.setUIMode(PageStatus.UI_History);
        hisModel = quesHisModel;
        rotionImg.visible = true;
        initTimer.start();
        view1.positionViewAtBeginning()
    }

    Component.onDestruction:
    {
        rotionImg.visible = false
        console.log("historyPage  Component.onDestruction")
    }

}
