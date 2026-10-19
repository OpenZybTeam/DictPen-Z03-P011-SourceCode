import QtQuick 2.0
import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtWebView 1.1
import QtWebChannel 1.0
import QtWebEngine 1.4
import "../../ZybControls"
import "../../ZybSet"
import "../../ZybCamera"
import DataManager.PageModeDefine 1.0
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0
import RemoteDataManager.PermissionDefine 1.0
import "../../Funcs/UILogics.js" as UILogic
import "../../Global"
import "../../Style"

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
    signal backClicked
    signal moreClicked
    signal webLoadFinshed
    signal zybhtmlNotLoaded
    signal printBtnClicked

    RotationImage
    {
        id:apiResBusyIndicator
        source: "qrc:/images/setLoading46x44.png"
        anchors.centerIn: parent
        visible: false
        z:100
        running: visible

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
        signal showSetMode(bool bshow);
        signal updateLatex(string id ,string message);
        signal updateOneContent(string id ,string message);
        signal updateControlTip(string message);
        signal initNormalMode();
        signal webLoadFinshed();
        signal hideContent();
        signal showContent();
        signal showAnswerBtn();
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

        function playVideo(url)
        {
            conditionForPlayVideo = 0;
            console.log("playClicked",url);
            curl = url;
            videoplayer.visible = true;
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
            videoplayer.tid = tid;
            videoplayer.type = "detail";
            //playVideo(url);
            playVideoNew(url,videoId)
        }


        function playClickedPoint(url)
        {
            if(dataManager.getLive() === false)
            {
                main.showTip(qsTr("网络已断开"));
                return;
            }
            res = {};
            var tid =api.getTid(curResultIndex);
            var videoId = api.getVideoId(curResultIndex);
            videoplayer.tid = tid;
            videoplayer.type = "point";
            //playVideo(url);
            playVideoNew(url,videoId)
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
//            root.visible = false;
            root.destroy()
        }


        function someMethod(message) {
            someSignal(message);
            return "foobar";
        }

        function topNaviClicked(message)
        {
            console.log("top navi clicked",message);
            res = {};
            res["item"] = message;
            var tid =api.getTid(curResultIndex);
            res["tid"] = tid;
            pingManager.addPingData(PingDefine.PING_EVENT_TID_NAVI_TOP,res);
        }

        function jslog(msg)
        {
            console.log(msg)
        }

        property bool busy: false
        property bool bStored: false
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
        videoplayer.visible = false;
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
            if(root.visible){
                if(sta === false)
                {
                    if(videoplayer.visible == true)
                    {
                        videoplayer.stop();
                        netDig.open();
                    }
                }
            }
        }
    }

    VideoItem
    {
        id:videoplayer
        z:10
        anchors.fill: parent
        visible: false

        onBackToParent:
        {
            console.log("Video back");
            videoplayer.stop();
            videoplayer.visible = false
        }

        onFreePlayEnd:
        {
            if(devManager.getVipStatus() === 1) //会员正常
            {
                if(devManager.isLogin() === false)
                {
                    stopPlay();
                    console.info("playClicked isLogin = false");
                    loginDig.content = qsTr("登录帐号后可以观看视频")
                    conditionForPlayVideo = 1;
                    loginDig.open();
                }
            }
            else
            {
                stopPlay();
                loginDig.content = qsTr("会员状态已过期，请先续费后观看")
                loginDig.rightTxt = qsTr("知道了")
                conditionForPlayVideo = 2;
                loginDig.open();
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

        var tisource = qsTr("来源：") + QueryWordManager.getCurZybDictTiSource();
        console.log("tisource",tisource);
        myObject.initNormalMode();
        myObject.updateLatex("tigan",api.getTiGan(curResultIndex));
        console.log("tigan",api.getTiGan(curResultIndex));
        myObject.updateLatex("tisource",tisource);
        myObject.updateLatex("think",api.getThink(curResultIndex));
        console.log("think",api.getThink(curResultIndex));
        myObject.updateLatex("contentAnswer",api.getAnswer(curResultIndex,false));
        console.log("contentAnswer",api.getAnswer(curResultIndex));
        myObject.updateOneContent("contentVideo",api.getVideo(curResultIndex));
        myObject.updateLatex("contentPoint",api.getPoint(curResultIndex));
        console.log("contentPoint",api.getPoint(curResultIndex));
        myObject.updateLatex("contentOthers",api.getOthers(curResultIndex));
        console.log("ChildrenMode",api.isChildrenMode());

        myObject.webLoadFinshed();
        latexTimer.restart();
        myObject.showAnswerBtn();
        //console.log("webLoadFinshed",scanMode,uuid);
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

            //console.log("webLoadFinshed",devStateMonitor.getDevState(),scanMode,uuid,ocrManager.getSearchImageUuid());
            myObject.showContent();
            webLoadFinshed();

            webView.visible = true;
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
        url:"qrc:/zybdict.html"
        webChannel: WebChannel {
            id: webChannel
            registeredObjects: [myObject]
        }

        onLoadingChanged: {
            console.log("onLoadingChanged =",loadRequest.status);
            if (loadRequest.status === WebEngineView.LoadSucceededStatus
                    || loadRequest.status === WebEngineView.LoadFailedStatus
                    || loadRequest.status === WebEngineView.LoadStoppedStatus ) {

                zybhtmlLoaded = true;
                console.log("webview cache path:",webView.profile.cachePath)
            }

        }
    }



    Connections
    {
        target: dataManager
        onGetU3m8:
        {
            //console.log("onGetU3m8 :",m3u8)
            //player.vol = devManager.getSoundVal();
            if(root.visible){
                videoplayer.source = "file:///"+ m3u8;
                videoplayer.videoPlayClicked = true;
                videoplayer.start();
            }
        }
    }

    Connections
    {
        target: apiNetWork

        onSig_postAddStoredButExisted:
        {
            main.showTip(qsTr("该题已收藏"));
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
        dataManager.clearM3u8();
    }
}



