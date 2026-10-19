import QtQuick 2.0
import "../ZybCamera"
import "../ZybControls"
import "../Style"
import "../Global"
import "../Funcs/UILogics.js" as UILogic
import DataManager.PageModeDefine 1.0
import RemoteDataManager.PermissionDefine 1.0
import DevStateMonitor.DevStateDefine 1.0
import com.zyb.PingDefine 1.0

Item {
    id:scanPicView
    property var pageType: "picSearchPage"
    property var pageState: 0
    property  var res : new Object;

    function init()
    {
        pageState = 1;
        picContent.state = "tip"
    }

    ScanTipPage
    {
        id: picTip;
        anchors.fill: parent
        visible: pageState === 0
    }

    ScanPicContentPage
    {
        id:picContent
        anchors.fill: parent
        visible: pageState === 1 /*|| pageState === 3*/
    }

    MsgTip
    {
        id:resTip
        y:Style.gHeight
        content : qsTr("抱歉，没有找到这道题目哦～")
        visible: false
    }

    Loading
    {
        id:scanPicbusyIndicator
        anchors.centerIn: parent
        visible: false
        z:900
    }

    ZybTextTipPage
    {
        id:noPermission
        anchors.fill: parent
        visible: pageState === 4

        onBackToParent:
        {
            pageState = 0;
        }
    }


    ApiResultPage
    {
        id:tidResult
        isHistory: false
        visible: pageState === 2

        onZybhtmlNotLoaded:
        {
            pageState = 0;
            scanPicbusyIndicator.visible = false;
            picContent.state = "scanEnd"
            main.showTip(qsTr("抱歉，没有找到这道题目哦～"));
        }

        onWebLoadFinshed:
        {
            console.log("onWebLoadFinshed",devStateMonitor.getDevState());
            if(devStateMonitor.getDevState() === DevStatus.DevState_Scaning )
            {
                return;
            }
            scanPicbusyIndicator.visible = false
            pageState = 2;
        }

        onBackClicked:{
            //console.log("pic page onbackclicked",tidResult.bFormKey)
            if(tidResult.bFormKey === true)
            {
                UILogic.backToHome();
            }
            else
            {
                pageState = 0
            }
        }

        onMoreClicked:{
            moreRes.visible = true;
        }

        onPrintBtnClicked:
        {
            scanPicbusyIndicator.visible = true
            startAsyncCreatePrintPage();
            res = {};
            pingManager.addPingData(PingDefine.PING_EVENT_PRINT_PREVIEW_SIGNAL);
        }
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
            if(tidResult.curResultIndex === num)
                return;

            scanPicbusyIndicator.visible = true
            tidResult.curResultIndex = num;
            loadtimer.start();
        }
    }


    function backedFunc()
    {
        loader.source = "";
        pageState = 2;
        scanPicbusyIndicator.visible = false
    }

    function printLoadFinished()
    {
        scanPicbusyIndicator.visible = false
    }


    function setPrintPreviewState()
    {
        pageState = 5; //打印预览
    }


    function startAsyncCreatePrintPage()
    {
        loader.source = "qrc:/ZybQmlFiles/ZybCamera/ResultPrintPage.qml";
        //        var backedFunc = scanPicView.backedFunc;
        //        var printPreviewFunc = scanPicView.setPrintPreviewState;
        //        var fin = scanPicView.printLoadFinished;
        //        objPrintPrivew = UILogic.async_createPrintPage(scanPicView,backedFunc,printPreviewFunc,fin,false);
    }


    Timer {
        id:loadtimer
        interval: 200; running: false; repeat: false
        onTriggered:
        {
            var storePath = api.getStorePath(tidResult.curResultIndex);
            GlobalProperty.isCameraQuestion = false;
            tidResult.storedPath = storePath;
            tidResult.startUpdateHtml();
        }
    }


    Connections{
        target: ocrManager

        onSig_imageInvalid:
        {
            //console.log("onSig_imageInvalid")
            pageState = 0;
            picContent.state = "scanEnd"
            scanPicbusyIndicator.visible = false;
        }

        onSig_getSearchImage:
        {
            //console.log("onSig_getSearchImage");
            picContent.state = "scanEnd"
            scanPicbusyIndicator.visible = true;
            //ocrManager.sendApiSearch();
        }

    }

    Connections {
        target: scanManager;

        onSig_timeout:
        {
            if(ocrManager.getGetedImage() === false)
            {
                console.log("onSig_timeout ---------------------- **********************")
                pageState = 0;
            }
            else
            {
                console.log("istoo small",ocrManager.getImageIsTooSmall());
                if(ocrManager.getImageIsTooSmall())
                {
                    pageState = 0;
                }
            }
        }

        onSig_scanDownContinuous:
        {
            picContent.setImagePre();
        }

        onSig_scanDown:{
            apiNetWork.stopSearchTidPost();
            main.closeTip();

            if(scanManager.isFirstScanDown())
            {
                picContent.clearPreImage();
            }

            console.log("----------------destroy print priview page",loader.item)
            if(loader.item)
            {
                loader.source = "";
                console.log("destroy print priview page")
            }
            //如果正在加载
            if(tidResult.mywebview.loading === true  && tidResult.zybhtmlLoaded===true)
            {
                console.log("mywebview.stop()");
                tidResult.mywebview.stop();
            }
            loadtimer.stop();
            tidResult.stopLatexTimer();
            tidResult.hideVideoItem();
            tidResult.hideQrSet();
            tidResult.scanMode = true;
            pageState = 1;
            moreRes.visible = false;
            if(scanManager.isFirstScanDown())
                scanPicbusyIndicator.visible = false;
            picContent.clearPic();
            picContent.state = "tip";
        }

        onSig_scanUp:{
            pageState = 1;
            picContent.state = "scanEnd"
            console.log("onSig_scanUp")
            //            if(ocrManager.getGetedImage() === false)
            //            {
            //                console.log("---------------------- **********************")
            //                pageState = 0;
            //            }
        }
    }


    Connections {
        target: apiNetWork;

        onSig_updateQuesResultAndUuid:
        {
            console.log("onSig_updateQuesResult state",picContent.state);
            if(picContent.state !== "scanEnd")
                return;

            moreRes.init(api.getListNum());
            if(devManager.isLeftHand === false)
                moreRes.x = scanPicView.width - moreRes.width +15
            else
                moreRes.x = scanPicView.width +15


            tidResult.uuid = uuid;
            tidResult.curResultIndex = 0;
            tidResult.imgPath = imgFullPath;

            loadtimer.restart();
        }

        onSig_noQuesResultFindUuid:
        {
            pageState = 0;
            scanPicbusyIndicator.visible = false;
            picContent.state = "scanEnd"
            if(code == 417)
            {
                main.showTip(qsTr("老师累了，亲你也歇会儿！"));
            }
            else
            {
                main.showTip(qsTr("抱歉，没有找到这道题目哦～"));
            }

        }

        onSig_noPermission:
        {
            scanPicbusyIndicator.visible = false
            pageState = 4
        }

        onSig_noToken:
        {
            scanPicbusyIndicator.visible = false
            pageState = 0
            main.showTip(qsTr("网络异常，请检查后重试"))
        }

        onSig_searchTimeout:
        {
            scanPicbusyIndicator.visible = false
            pageState = 0
            main.showTip(qsTr("网络超时，请稍后重试"))
        }

        onSig_netManagerReseted:
        {
            if(scanPicbusyIndicator.visible === true)
            {
                scanPicbusyIndicator.visible = false
                pageState = 0
                main.showTip(qsTr("网络异常，请稍后重试"))
            }
        }

    }


    Component.onCompleted:
    {
        console.log("enter picSearch page")
        dataManager.setUIMode(PageStatus.UI_Scan);
        tidResult.scanMode = true;
        //pingManager.addPingData(PingDefine.PING_EVENT_TID_SCAN_NUM);
        if(main.bEnterPicFormKey  === true)
        {
            tidResult.bFormKey = true;
            init();
            main.bEnterPicFormKey  =false;
        }
        else
            tidResult.bFormKey = false;
    }

    Component.onDestruction:
    {
        scanManager.setScanTimeout(true);
        main.bEnterPicFormKey  =false;
    }

}
