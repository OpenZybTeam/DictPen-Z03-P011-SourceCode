import QtQuick 2.0
import QtMultimedia 5.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"
import "../Global"
import QtWebView 1.1
import QtWebChannel 1.0
import QtWebEngine 1.4
import DevStateMonitor.DevStateDefine 1.0
import DataManager.PageModeDefine 1.0
import RemoteDataManager.CourseDefine 1.0
import RemoteDataManager.PermissionDefine 1.0
import com.zyb.PingDefine 1.0

Rectangle {
    id : cameraUI
    property var pageType: "camerapage"
    property bool cameraIsOpen :false
    property bool pictakeing : false
    property bool initEnd : false
    property bool requested : false
    color: Style.mainbgColor
    property  var res : new Object;

    state: ""
    states: [
        State {
            name: "PhotoCapture"
            StateChangeScript {
                script: {
                    requested = false;
                    moreRes.visible = false
                    photoPreview.controlClose();
                    photoPreview.enableShotArea(true);
                    //tryStartCapture();
                    if(cameraIsOpen === false)
                    {
                        cameramanager.startCapture();
                        cameraIsOpen = true;
                        devStateMonitor.setDevState(DevStatus.DevState_Cameraing);
                    }
                }
            }
        },

        State {
            name: "PhotoPreview"
            StateChangeScript {
                script: {
                    console.log("PhotoPreview state")
                    requested = false;
                    if(cameraIsOpen === true)
                    {
                        cameramanager.stopCapture();
                        cameraIsOpen = false;
                    }
                    //tryStopCapture();
                    photoPreview.controlOpen();
                }
            }
        },

        State {
            name: "NoPermission"
            StateChangeScript {
                script: {
                    console.log("NoPermission state")
                    requested = false;
                    if(cameraIsOpen === true)
                    {
                        cameramanager.stopCapture();
                        cameraIsOpen = false;
                    }

                    photoPreview.controlClose();
                }
            }
        },

        State {
            name: "NoResultPreview"
            StateChangeScript {
                script: {
                    console.log("NoResultPreview state")
                    requested = false;
                    if(cameraIsOpen === true)
                    {
                        cameramanager.stopCapture();
                        cameraIsOpen = false;
                    }
                    //tryStopCapture();
                    photoPreview.controlClose();
                }
            }
        },

        State {
            name: "ResultPreview"
            StateChangeScript {
                script: {
                    console.log("ResultPreview state")
                    requested = false;
                    if(cameraIsOpen === true)
                    {
                        cameramanager.stopCapture();
                        cameraIsOpen = false;
                    }
                    //tryStopCapture();
                    photoPreview.controlClose();
                }
            }
        },

        State {
            name: "PrintPreview"
            StateChangeScript {
                script: {
                    console.log("PrintPreview state")

                }
            }
        }
    ]


    ZybText {
        id: tip
        text: "支持横竖屏拍摄，请将整道题框进屏幕内"
        font.pixelSize: 24
        font.styleName: "Bold"
        color:"#FFFFFF"
        anchors.centerIn: parent
        visible: false //cameraUI.state === "PhotoCapture"
        z:6
    }


    Loading
    {
        id:cameraPageBusyImg
        anchors.centerIn: parent
        visible: false
        z:900
    }

    ZybBackButton
    {
        id :back
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        visible: cameraUI.state === "PhotoCapture"
        z:3
        onBackClicked: {
            UILogic.backToHome()
        }
    }


    PopupDialog
    {
        id:noResTip
        width: parent.width
        height: parent.height
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("抱歉，没有找到这道题目哦～")
        bgColor: "transparent"

        visible: cameraUI.state === "NoResultPreview"

        onLeftClicked:
        {
            cameraUI.state = "PhotoCapture";
            noResTip.close();
        }

        onRightClicked:
        {
            cameraUI.state = "PhotoCapture"
            noResTip.close();
        }
    }

    VideoOutput {
        id: viewfinder
        visible: cameraUI.state === "PhotoCapture" || cameraUI.state === "VideoCapture" || cameraUI.state === "NoResultPreview"
        anchors.fill: parent
        source: frameProvider
        orientation: devManager.isLeftHand?180:360
        MouseArea
        {
            //anchors.fill: viewfinder.contentRect
            x:viewfinder.contentRect.x
            y:viewfinder.contentRect.y
            width: viewfinder.contentRect.width
            height: viewfinder.contentRect.height

            onClicked:
            {

                console.log(viewfinder.contentRect,viewfinder.sourceRect);
                if(initEnd === false)
                    return;
                console.log("video output clicked");
                //if(cameramanager.isStart() && pictakeing === false)
                if(cameraIsOpen===true && pictakeing === false)
                {
                    pictakeing = true;
                    var filepath = UILogic.getCurImageName()
                    frameProvider.setPath(filepath+".jpg");
                    devManager.mysyslog("CameraPage.qml: cameramanager.takeOnePic");
                    cameramanager.takeOnePic(filepath+".jpg");
                }
            }
        }
    }

    Connections
    {
        target: frameProvider;

        onSigCaptured:
        {
            photoPreview.imagePath = ""
            photoPreview.source = ""
            photoPreview.source = "image://CaptureImage"
            cameraUI.state = "PhotoPreview"
            pictakeing = false
            devStateMonitor.setDevState(DevStatus.DevState_Normal);
        }
    }

    ZybTextTipPage
    {
        id:noPermission
        anchors.fill: parent
        visible: cameraUI.state === "NoPermission"

        onBackToParent:
        {
            cameraUI.state = "PhotoCapture"
        }
    }

    PhotoPreview {
        id : photoPreview
        x:viewfinder.contentRect.x
        y:viewfinder.contentRect.y
        width: viewfinder.contentRect.width
        height: viewfinder.contentRect.height

        visible: cameraUI.state === "PhotoPreview" || cameraUI.state === "NoResultPreview"
        focus: visible

        onReturnToParent:
        {
            cameraPageBusyImg.visible = false
            cameraUI.state = "PhotoCapture"
            pingManager.addPingData(PingDefine.PING_EVENT_TID_CAMERA_RE);
        }

        onCommited:
        {
            cameraPageBusyImg.visible = true
            console.log("onCommited");
            requested = true;
            photoPreview.enableShotArea(false);
            pingManager.addPingData(PingDefine.PING_EVENT_TID_CAMERA_COMMIT);
        }
    }


    ApiResultPage {
        id : apiresultpage
        anchors.fill: parent
        isHistory: false
        visible: cameraUI.state === "ResultPreview"
        z:100

        onWebLoadFinshed:
        {
            cameraUI.state = "ResultPreview"
            cameraPageBusyImg.visible = false
        }

        onBackClicked:{
            cameraUI.state = "PhotoCapture"
            cameraPageBusyImg.visible = false
        }

        onMoreClicked:{
            moreRes.visible = true;
        }

        onPrintBtnClicked:
        {
            cameraPageBusyImg.visible = true
            startAsyncCreatePrintPage();
            res = {};
            pingManager.addPingData(PingDefine.PING_EVENT_PRINT_PREVIEW_SIGNAL);
        }
    }



    MoreResultPage
    {
        id:moreRes
        visible: false
        x:devManager.isLeftHand?(width):(parent.width - width)
        y:devManager.isLeftHand?(parent.height-60):60
        z:103

        onNumClicked:
        {
            moreRes.visible = false
            if(apiresultpage.curResultIndex === num)
                return;

            cameraPageBusyImg.visible = true
            apiresultpage.curResultIndex = num;
            loadtimer.start();
            res = {};
            res["index"] = num;
            var tid =api.getTid(num);
            res["tid"] = tid;
            pingManager.addPingData(PingDefine.PING_EVENT_TID_MORE_SELECT,res);
        }
    }


    Timer {
        id:loadtimer
        interval: 200; running: false; repeat: false
        onTriggered:
        {
            var storePath = api.getStorePath(apiresultpage.curResultIndex);
            GlobalProperty.isCameraQuestion = true;
            apiresultpage.storedPath = storePath;
            apiresultpage.startUpdateHtml();
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


    function backedFunc()
    {
        loader.source = "";
        cameraUI.state = "ResultPreview";
        cameraPageBusyImg.visible = false
    }

    function printLoadFinished()
    {
        cameraPageBusyImg.visible = false
    }

    function setPrintPreviewState()
    {
        cameraUI.state = "printPreview";
    }


    function startAsyncCreatePrintPage()
    {
        loader.source = "qrc:/ZybQmlFiles/ZybCamera/ResultPrintPage.qml";
//        var backedFunc = cameraUI.backedFunc;
//        var printPreviewFunc = cameraUI.setPrintPreviewState;
//        var fin = cameraUI.printLoadFinished;
//        UILogic.async_createPrintPage(cameraUI,backedFunc,printPreviewFunc,fin,false);
    }


    Connections {
        target: apiNetWork;
        onSig_updateQuesResult:
        {
            if(requested === false)
            {
                return;
            }

            moreRes.init(api.getListNum());
            var wid = moreRes.width;
            if(devManager.isLeftHand === false)
                moreRes.x = cameraUI.width - moreRes.width +15
            else
                moreRes.x = cameraUI.width +15

            apiresultpage.curResultIndex = 0;
            apiresultpage.imgPath = imgFullPath;
            loadtimer.start();
        }

        onSig_noQuesResultFind:
        {
            if(requested === false)
            {
                return;
            }

            if(code == 417)
            {
                noResTip.content = qsTr("老师累了，亲你也歇会儿！")
            }
            else
            {
                noResTip.content = qsTr("抱歉，没有找到这道题目哦～")
            }

            cameraPageBusyImg.visible = false
            cameraUI.state = "NoResultPreview"
        }

        onSig_noPermission:
        {
            if(requested === false)
            {
                return;
            }

            cameraPageBusyImg.visible = false
            cameraUI.state = "NoPermission"
        }

        onSig_noToken:
        {
            if(requested === false)
            {
                return;
            }

            cameraPageBusyImg.visible = false
            cameraUI.state = "PhotoCapture"
            main.showTip(qsTr("网络异常，请检查后重试"))
        }

        onSig_searchTimeout:
        {
            if(requested === false)
            {
                return;
            }

            noResTip.content = qsTr("网络超时，请稍后重试")
            cameraPageBusyImg.visible = false
            cameraUI.state = "NoResultPreview"
        }

        onSig_netManagerReseted:
        {
            if(requested === false)
            {
                return;
            }

            if(cameraPageBusyImg.visible === true)
            {
                apiNetWork.sendApiSearchQuesResults(dataManager.getLastBackCameraPath());
            }
        }
    }

    Connections {
        target: engineSocket;

        onSig_cameraKey:{
            apiresultpage.scanMode = true;
            cameraPageBusyImg.visible = false
            apiresultpage.hideVideoItem();
            apiresultpage.hideQrSet();
            if(loader.item)
            {
                loader.source = "";
                console.log("destroy print priview page")
            }

            if(cameraUI.state === "PhotoCapture")
            {
                var filepath = UILogic.getCurImageName()
                frameProvider.setPath(filepath+".jpg");
                cameramanager.takeOnePic(filepath+".jpg");
            }
            else
            {
                cameraUI.state = "PhotoCapture";
                pingManager.addPingData(PingDefine.PING_EVENT_TID_KEY_CAMERA_NUM);
            }

        }

        onSig_offScreenKey:{
            if(cameraIsOpen === true)
            {
                console.log("CameraPage.qml: onSig_offScreenKey when cameraIsopen")
                cameramanager.stopCapture();
                cameraIsOpen = false;
                devStateMonitor.setDevState(DevStatus.DevState_Normal);

                UILogic.backToHome();
            }
        }
    }

    Timer {
        id:timer
        interval: 160; running: false; repeat: false
        onTriggered:
        {
            initEnd = true;
        }
    }

    Component.onCompleted:
    {
        if(!devManager.getHaveShowCameraHelp() || devManager.getHaveShowCameraHelp()=== false){
            UILogic.openTipPage("cameraquestion");
            devManager.setHaveShowCameraHelp();
        }
        apiresultpage.scanMode = true;
        dataManager.setUIMode(PageStatus.UI_Camera);
        cameraUI.state = "PhotoCapture"
        timer.start();
        console.log("PingDefine.PING_EVENT_TID_CAMERA_NUM + 1");

    }

    Component.onDestruction:
    {
        console.log("camera Page Component.onDestruction" )
        main.bEnterCameraFormKey = false
        cameraPageBusyImg.visible = false

        if(cameraIsOpen === true)
        {
            console.log("CameraPage.qml: cameramanager.stopCapture from onDestruction")
            cameramanager.stopCapture();
            cameraIsOpen = false;
            devStateMonitor.setDevState(DevStatus.DevState_Normal);
        }
        //tryStopCapture();
    }
}
