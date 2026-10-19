import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtWebView 1.1
import QtWebChannel 1.0
import QtWebEngine 1.4
import "../ZybControls"
import "../ZybSet"
import DataManager.PageModeDefine 1.0
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0
import RemoteDataManager.PermissionDefine 1.0
import "../Funcs/UILogics.js" as UILogic
import "../Global"
import "../Style"

Item {
    id: root
    anchors.fill: parent

    property  bool bFormKey : false
    property alias mywebview : webView
    property string imgPath:""
    property string storedPath:""   //收藏后的图片路径
    property int course : 1
    property int curResultIndex : 0     //搜题结果的1 2 3 4 5
    property string curl: ""            //视频播放
    property string tid : ""
    property string uuid: ""
    property int conditionForPlayVideo : 0
    property bool zybhtmlLoaded : false
    property bool scanMode : true
    property bool isHistory: false
    property bool needDisplayQr : false
    signal backClicked
    signal moreClicked
    signal webLoadFinshed
    signal zybhtmlNotLoaded
    signal printBtnClicked


    Loading
    {
        id:apiResBusyIndicator
        anchors.centerIn: parent
        visible: false
        z:100
    }


    PopupDialog
    {
        id:loginDig
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("登录帐号后可以观看视频")
        rightTxt:qsTr("去登录")
        onLeftClicked:
        {
            loginDig.close();
            console.info("logindig close onLeftClicked");
            pingManager.addPingData(PingDefine.PING_EVENT_TID_VIDEO_LOGIN_CANCEL);
        }

        onRightClicked:
        {
            if(conditionForPlayVideo === 1)
            {
                if(devManager.existsQrPng())
                {
                    qr.setModeForBind();
                    qr.visible = true;
                }
                else
                {
                    apiNetWork.sendApiLogin();
                    needDisplayQr = true;
                }

            }

            loginDig.close();
            console.info("logindig close onRightClicked");
            pingManager.addPingData(PingDefine.PING_EVENT_TID_VIDEO_LOGIN);
        }
    }

    Timer {
        id: delaytimer
        interval: 1000;
        running: false;
        repeat: false

        onTriggered:
        {
            apiResBusyIndicator.visible = false
            qr.visible = false
        }
    }


    SetQrPage
    {
        id:qr
        anchors.fill: parent
        visible: false
        z:20
        source: "file:///"+"/home/userdata/qr.png"
        onBackToParent:
        {
            visible = false
        }

        onQrSuccess:
        {
            if(qr.visible === true)
            {
                apiResBusyIndicator.visible = true
                console.log("On qrSuccess");
                delaytimer.start();
            }
        }
    }

    function initWebView()
    {
        webView.visible = ture;
        webView2.visible = false;
    }

    QtObject {
        id: myObject

        // 注册方法 1
        // 使用注册方法 2 时不需要此行代码
        WebChannel.id: "foo" //这个 id 可以在 html 中使用

        // 以下为 JavaScript 代码可以访问的信号、方法和属性
        signal someSignal(string message);
        signal unStoreState();
        signal storeState();
        signal showSetMode(bool bshow);
        signal showBikao(bool bshow);
        signal updateLatex(string id ,string message);
        signal updateOneContent(string id ,string message);
        signal updateControlTip(string message);
        signal updateVideoNavi(string message);
        signal updateSvipVideoNavi(bool bhave);
        signal initStoreMode();
        signal initNormalMode();
        signal webLoadFinshed();
        signal hideContent();
        signal showContent();
        signal showHelp(bool bshow);

        property  var res : new Object;

        function store()
        {
            storeClicked();
            if(scanMode === true)
            {
                dataManager.addOneQuestionStored(curResultIndex,imgPath)
                res = {};
                var tid =api.getTid(curResultIndex);
                res["tid"] = tid;
                pingManager.addPingData(PingDefine.PING_EVENT_TID_STORE,res);
            }

        }

        function unStore()
        {
            storeClicked();
            if(scanMode === true)
            {
                dataManager.delOneQuestionStored(curResultIndex,storedPath);
            }

        }

        function qmlfeedback(b)
        {
            if(b === true)
            {
                main.showTip(qsTr("已反馈"));
                return;
            }

            var tid =api.getTid(curResultIndex);
            if(tid !== "")
            {
                apiNetWork.sendApiQuesFeedback(tid);
                res = {};
                if(dataManager.getUIMode() === PageStatus.UI_Camera)
                {
                    res["mode"] = "camera";
                }
                else
                {
                    res["mode"] = "scan";
                }

                res["tid"] = tid;
                pingManager.addPingData(PingDefine.PING_EVENT_TID_ERROR,res);
            }
            main.showTip(qsTr("感谢反馈，我们会努力改进的！"));
        }

        function onpenHelp(){
            if(GlobalProperty.isCameraQuestion === true){
                UILogic.openTipPage("cameraquestion");
            }
            else{
                UILogic.openTipPage("scanquestion");
            }
        }

        function playVideo(url)
        {
            conditionForPlayVideo = 0;
            console.log("playClicked",url);
            curl = url;
            player.visible = true;
            timer.start();
        }

        function playVideoNew(url,videoId)
        {
            conditionForPlayVideo = 0;
            console.log("playClicked",url);
            curl = url;
            player.visible = true;
            dataManager.startM3u8(curl,videoId);
        }


        function playClicked(url)
        {
            if(dataManager.getLive() === false)
            {
                main.showTip(qsTr("网络已断开"));
                return;
            }
            res = {};
            var tid =api.getTid(curResultIndex);
            var videoId = api.getVideoId(curResultIndex);
            player.tid = tid;
            player.isSvip = false;
            player.type = "detail";
            player.videoId = videoId;
            //playVideo(url);
            playVideoNew(url,videoId)
        }

        function playClickedSvip(url)
        {
            if(dataManager.getLive() === false)
            {
                main.showTip(qsTr("网络已断开"));
                return;
            }
            res = {};
            var tid =api.getTid(curResultIndex);
            var videoId = api.getSvipVideoId(curResultIndex);
            player.tid = tid;
            player.isSvip = true;
            player.type = "svip";
            player.videoId = videoId;
            playVideoNew(url,videoId);
        }


        function playClickedPoint(url)
        {
            if(dataManager.getLive() === false)
            {
                main.showTip(qsTr("网络已断开"));
                return;
            }
            res = {};
            console.log("playClickedPoint",curResultIndex,url);
            var tid =api.getTid(curResultIndex);
            var videoId = api.getKeyPointId(curResultIndex,url);
            player.tid = tid;
            player.isSvip = false;
            player.type = "point";
            player.videoId = videoId;
            playVideoNew(url,videoId);
        }

        function otherClicked(id)
        {
            res = {};
            var tid =api.getTidOther(curResultIndex,id);
            res["tid"] = tid;
            pingManager.addPingData(PingDefine.PING_EVENT_TID_OTHER,res);

            switchWebLoading.visible = true
            console.log("otherClicked",id);
            startUpdateOtherHtml(id);
        }

        function back()
        {
            backClicked();
        }

        function more()
        {
            moreClicked();
            res = {};
            var tid =api.getTid(0);
            res["tid"] = tid;
            pingManager.addPingData(PingDefine.PING_EVENT_TID_MORE,res);
        }

        function someMethod(message) {
            someSignal(message);
            return "foobar";
        }

        function setUnStoreState()
        {
            unStoreState();
        }

        function onSetCilcked()
        {
            qr.setModeForParentMode();
            qr.visible = true;
        }

        function topNaviClicked(message)
        {
            console.log("top navi clicked",message,curResultIndex);
            res = {};
            res["item"] = message;
            var tid =api.getTid(curResultIndex);
            res["tid"] = tid;
            pingManager.addPingData(PingDefine.PING_EVENT_TID_NAVI_TOP,res);
        }

        function printClicked()
        {
            printBtnClicked();
        }

        function jslog(msg)
        {
            console.log(msg)
        }

        function loadOver()
        {
            zybhtmlLoaded = true;
        }

        property bool busy: false
        property bool bStored: false
    }


    QtObject {
        id: myObject2

        // 注册方法 1
        // 使用注册方法 2 时不需要此行代码
        WebChannel.id: "foo2" //这个 id 可以在 html 中使用

        // 以下为 JavaScript 代码可以访问的信号、方法和属性
        signal updateLatex(string id ,string message);
        signal updateOneContent(string id ,string message);
        signal initNormalMode();
        signal webLoadFinshed();
        property  var res : new Object;

        function back()
        {
            webView.visible = true
            webView2.visible = false
        }

        function topNaviClicked(message)
        {
            console.log("top navi clicked",message,curResultIndex);
            res = {};
            res["item"] = message;
            var tid =api.getTid(curResultIndex);
            res["tid"] = tid;
            pingManager.addPingData(PingDefine.PING_EVENT_TID_NAVI_TOP,res);
        }
    }


    Timer {
        id:timer
        interval: 1; running: false; repeat: false
        onTriggered:
        {
            dataManager.startM3u8(curl);
        }
    }

    Timer
    {
        id:storeTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered:
        {
            apiResBusyIndicator.visible = false;
            myObject.busy = false
        }
    }

    function hideVideoItem()
    {
        player.visible = false;
    }

    function hideQrSet()
    {
        qr.visible = false
    }

    PopupDialog
    {
        id:netDig
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        closeBtnVisible:false
        leftTxtVisble:false
        content:qsTr("网络未连接，请先连接网络")
        rightTxt:qsTr("去设置")

        onRightClicked:
        {
            if(wordView.visible){
                wordView.visible = false;
            }
            netDig.close();
            naviPanel.sceneSource = "qrc:/ZybQmlFiles/ZybSet/SetMainPage.qml";
        }
    }

    Connections {
        target: dataManager;
        onSig_netLive:
        {
            if(sta === false)
            {
                if(player.visible == true)
                {
                    player.setStopOnly();
                    netDig.open();
                }
            }
        }
    }

    VideoItem
    {
        id:player
        z:10
        anchors.fill: parent
        visible: false
        needVip: true

        onBackToParent:
        {
            //player.stop();
            player.visible = false
        }

//        onEndStart: {
//            dataManager.startM3u8(curl);
//        }

        onFreePlayEnd:
        {
            console.log("onFreePlayEnd islogin=",devManager.isLogin()," vip=",devManager.getVipStatus()," svip=",devManager.getSvipStatus())

            if(devManager.isLogin() === false)
            {
                stopPlay();
                loginDig.content = qsTr("登录帐号后可以观看视频")
                conditionForPlayVideo = 1;
                loginDig.open();
            }
            else
            {
                if(player.isSvip)
                {
                    if(devManager.getSvipStatus() === -1) //svip 过期
                    {
                        stopPlay();
                        loginDig.content = qsTr("SVIP已过期，请到作业帮智能App续费后观看")
                        loginDig.rightTxt = qsTr("知道了")
                        conditionForPlayVideo = 2;
                        loginDig.open();
                    }
                    else if(devManager.getSvipStatus() === -2) //svip 未开通
                    {
                        stopPlay();
                        loginDig.content = qsTr("试看结束，请到作业帮智能App购买SVIP")
                        loginDig.rightTxt = qsTr("知道了")
                        conditionForPlayVideo = 2;
                        loginDig.open();
                    }
                }
                else
                {
                    if(devManager.getSvipStatus() === 1)
                    {

                    }
                    else
                    {
                        if(devManager.getVipStatus() === -1) //会员过期
                        {
                            stopPlay();
                            loginDig.content = qsTr("VIP已过期，请到作业帮智能App续费后观看")
                            loginDig.rightTxt = qsTr("知道了")
                            conditionForPlayVideo = 2;
                            loginDig.open();
                        }
                        else if(devManager.getVipStatus() === -2) //会员未开通
                        {
                            stopPlay();
                            loginDig.content = qsTr("试看结束，请到作业帮智能App购买VIP")
                            loginDig.rightTxt = qsTr("知道了")
                            conditionForPlayVideo = 2;
                            loginDig.open();
                        }
                    }


                }
            }
        }

    }

    function hideAllH5()
    {
        console.log("hideall content");
        myObject.hideContent();
    }

    function initStoreMode()
    {
        console.warn("initStoreMode");
        myObject.initStoreMode();
    }

    function initNormalMode()
    {
        myObject.initNormalMode();
    }

    function startUpdateHtml()
    {
        console.warn("startUpdateHtml");
        if(zybhtmlLoaded === false)
        {
            console.warn("retryTimer start");
            retryTimer.start();
            return;
        }

        if(devStateMonitor.getDevState() === DevStatus.DevState_Scaning
                || devStateMonitor.getDevState() === DevStatus.DevState_Cameraing )
        {
            console.warn("devStateMonitor.getDevState()",devStateMonitor.getDevState());
            webView.stop();
            return;
        }

        player.course = api.getCourse(curResultIndex);
        myObject.updateControlTip(api.getControlTip());
        if(scanMode === true)
        {
            var bstored = api.getStored(curResultIndex);
            if(bstored)
            {
                myObject.storeState();
            }
            else
            {
                myObject.unStoreState();
            }
            initNormalMode();
        }
        else
        {
            initStoreMode();
        }

        if(isHistory)
        {
            myObject.showHelp(false);
        }
        else
        {
            myObject.showHelp(true);
        }

        myObject.updateVideoNavi(api.getVideoCategory(curResultIndex));
        myObject.updateSvipVideoNavi(api.haveSvipVideo(curResultIndex));
        myObject.updateLatex("tigan",api.getTiGan(curResultIndex));
        myObject.updateLatex("think",api.getThink(curResultIndex));
        myObject.updateLatex("contentAnswer",api.getAnswer(curResultIndex));
        myObject.updateOneContent("contentVideo",api.getVideo(curResultIndex));
        myObject.updateOneContent("contentSvipVideo",api.getSvipVideo(curResultIndex));
        myObject.updateLatex("contentPoint",api.getPoint(curResultIndex));
        myObject.updateLatex("contentOthers",api.getOthers(curResultIndex));
        myObject.showBikao(api.getBiKao(curResultIndex));
        console.warn("show bikao",api.getBiKao(curResultIndex));
        myObject.webLoadFinshed();
        latexTimer.restart();
        //console.log("webLoadFinshed",scanMode,uuid);
    }

    function startUpdateOtherHtml(index)
    {
        console.warn("startUpdateOtherHtml");
        myObject2.updateLatex("tigan",api.getTiGanOther(curResultIndex,index));
        myObject2.updateLatex("contentAnswer",api.getAnswerOther(curResultIndex,index));
        myObject2.updateLatex("contentPoint",api.getPointOther(curResultIndex,index));
        latexTimer2.restart();
    }

    Timer
    {
        id: retryTimer
        repeat: false
        running: false
        interval: 1200
        onTriggered:
        {
            console.warn("retryTimer onTriggered");
            startUpdateHtml();
        }
    }

    function stopLatexTimer()
    {
        console.warn("stopLatexTimer");
        latexTimer.stop();
        latexTimer2.stop();
    }

    Timer
    {
        id: latexTimer
        repeat: false
        running: false
        interval: 1000
        onTriggered:
        {
            console.log("latex timer triggerd", devStateMonitor.getDevState())
            if(devStateMonitor.getDevState() === DevStatus.DevState_Scaning
                    || devStateMonitor.getDevState() === DevStatus.DevState_Cameraing)
            {
                return;
            }

            //console.log("webLoadFinshed",devStateMonitor.getDevState(),scanMode,uuid,ocrManager.getSearchImageUuid());
            if(scanMode === true)
            {
                if(uuid.length > 0)
                {
                    if(uuid === ocrManager.getSearchImageUuid())
                    {
                        myObject.showContent();
                        webLoadFinshed();
                    }
                }
                else
                {
                    myObject.showContent();
                    webLoadFinshed();
                }
            }
            else
            {
                myObject.showContent();
                webLoadFinshed();
            }

            webView.visible = true;
            webView2.visible = false;
        }
    }

    Timer
    {
        id: latexTimer2
        repeat: false
        running: false
        interval: 1000
        onTriggered:
        {
            console.log("latex timer triggerd", devStateMonitor.getDevState())
            if(devStateMonitor.getDevState() === DevStatus.DevState_Scaning
                    || devStateMonitor.getDevState() === DevStatus.DevState_Cameraing)
            {
                return;
            }

            myObject2.webLoadFinshed();
            webView.visible = false;
            webView2.visible = true;
            switchWebLoading.visible = false;
        }
    }

    Loading
    {
        id:switchWebLoading
        anchors.centerIn: parent
        visible: false
        z:900
    }

    WebEngineView {
        id: webView;
        anchors.fill : parent
        url:"qrc:/zyb.html" //isHistory ? "qrc:/zybnohelp.html" : "qrc:/zyb.html"
        webChannel: WebChannel {
            id: webChannel
            registeredObjects: [myObject]
        }

        onLoadingChanged: {
            console.log("onLoadingChanged =",loadRequest.status);
            if (loadRequest.status === WebEngineView.LoadSucceededStatus
                    || loadRequest.status === WebEngineView.LoadFailedStatus
                    || loadRequest.status === WebEngineView.LoadStoppedStatus ) {

                //zybhtmlLoaded = true;
                console.log("webview cache path:",webView.profile.cachePath)
            }

        }
    }

    WebEngineView {
        id: webView2;
        anchors.fill : parent;
        url:"qrc:/zyb2.html"
        visible: false
        webChannel: WebChannel {
            id: webChannel2
            registeredObjects: [myObject2]
        }

        onLoadingChanged: {
            console.log("onLoadingChanged2 =",loadRequest.status);
        }
    }

    function storeEnd()
    {
        apiResBusyIndicator.visible = false;
        myObject.busy = false;
        storeTimer.stop();
    }

    function storeClicked()
    {
        if(storeTimer.running === true)
        {
            return;
        }

        apiResBusyIndicator.visible = true;
        myObject.busy = true;
        storeTimer.start();
    }

    function storeSuccess(path)
    {
        console.log("storeSuccess");
        storeEnd();
        storedPath = path;
        main.showTip(qsTr("已收藏到生疏归纳"));
    }

    function storeFailed()
    {
        storeEnd();
        myObject.unStoreState();
        //main.showTip(qsTr("服务异常，请稍后重试"));
    }

    function unstoreSuccess()
    {
        storeEnd();
        storedPath = "";
        myObject.unStoreState();
        main.showTip(qsTr("已取消收藏"));
    }

    function unstoreFailed()
    {
        storeEnd();
        myObject.unStoreState();
        //myObject.storeState();
        main.showTip(qsTr("已取消收藏"));
    }

    Connections
    {
        target: dataManager
        onGetU3m8:
        {
            console.log("onGetU3m8 :",player.videoId,videoId)

            if(player.videoId === videoId)
            {
                player.source = "file:///"+ m3u8;

                player.videoPlayClicked = true;
                player.start();
            }


        }

        onSigM3u8Error:
        {
            if(player.visible)
            {
                main.showTip(qsTr("获取视频出错，请稍后重试"));
            }

            player.hideVideoBusyImage();

        }

        onSig_addQuesStoreSuccess:
        {
            storeSuccess(filePath);
        }

        onSig_addQuesStoreFailed:
        {
            //console.log("onSig_addQuesStoreFailed");
            //storeFailed();
        }

        onSig_delQuesStoreSuccess:
        {
            unstoreSuccess();
        }

        onSig_delQuesStoreFailed:
        {
            unstoreFailed();
        }

        onSig_storeNumLimit:
        {
            storeFailed();
            main.showTip(qsTr("收藏已达上限，请删除部分内容或绑定设备后可收藏更多内容"));
        }
    }

    Connections
    {
        target: apiNetWork

        onSig_postAddStoredButExisted:
        {
            main.showTip(qsTr("该题已收藏"));
        }

        onSig_postAddStoredFailed:
        {
            storeFailed();
        }

        onSig_postAddStoredTimeout:
        {
            storeEnd();
            myObject.unStoreState();
            main.showTip(qsTr("收藏超时"));
        }

        onSig_postDelOneQuesStoreFailed:
        {
            unstoreFailed();
        }

        onSig_loginSuccess:{
            if(needDisplayQr)
            {
                console.log("needDisplayQr",needDisplayQr)
                qr.setModeForBind();
                qr.visible = true;
            }
            needDisplayQr = false;
        }
    }

    Component.onCompleted:
    {
        zybhtmlLoaded = false;
    }

    Component.onDestruction:
    {
        //console.log("apiresult page destruction");
        apiResBusyIndicator.visible = false;
    }
}



