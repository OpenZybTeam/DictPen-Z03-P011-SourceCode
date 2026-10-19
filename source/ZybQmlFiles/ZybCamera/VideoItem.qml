import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtMultimedia 5.0
import "../Style"
import "../ZybControls"
import DevStateMonitor.DevStateDefine 1.0
import com.zyb.PingDefine 1.0

Rectangle {
    id:control

    anchors.fill: parent
    color: Style.mainbgColor

    property bool isSvip : false
    property alias source: player.source
    property alias vol : player.volume
    property string tid: ""
    property string type: ""
    property bool lightChanged :false
    property bool volumeChanged : false
    property bool videoPlayClicked : false
    property bool needVip : false
    property int  freePlayTime:60000
    property bool freePlayWarnSended:false
    property int course : -1
    property string videoId: ""

    //rotation:  devManager.isLeftHand?180:0
    signal backToParent()
    signal playover()
    signal freePlayEnd()
    signal endStart();

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    onSourceChanged:
    {
        freePlayTime = 60000
    }

    function playerIsPlaying()
    {
        return (player.playbackState ==  MediaPlayer.PlayingState);
    }

    function setStopOnly()
    {
        console.log(player.playbackState,player.status)
        player.stop();
    }

    function stop()
    {
        console.log(player.playbackState,player.status)
        //player.source = "";
        player.stop();
    }

    function pause()
    {
        if(player.playbackState ==  MediaPlayer.PlayingState)
        {
            console.log("player pause pause")
            player.pause();
        }
        else
        {
            console.log("player pause stop")
            player.stop();
        }
        hideControls(1)
        hideStatusSlider(1);
    }

    function start()
    {
        console.log("start vip=", devManager.getVipStatus()," svip=",devManager.getSvipStatus());
        if(needVip)
        {      
            if(isSvip)
            {
                if(devManager.getSvipStatus() !== 1) //非会员正常
                {
                    if(freePlayWarnSended )
                    {
                        freePlayEnd();
                        return;
                    }
                }
            }
            else
            {
                if(devManager.getSvipStatus() !== 1)
                {
                    if(devManager.getVipStatus() !== 1) //非会员正常
                    {
                        if(freePlayWarnSended )
                        {
                            freePlayEnd();
                            return;
                        }
                    }
                }
            }
        }

        player.play();
    }

    //时间格式化
    function currentTime(time)
    {
        var sec= Math.floor(time/1000);
        var hours=Math.floor(sec/3600);
        var minutes=Math.floor((sec-hours*3600)/60);
        var seconds=sec-hours*3600-minutes*60;
        var hh,mm,ss;
        if(hours.toString().length<2)
            hh="0"+hours.toString();
        else
            hh=hours.toString();
        if(minutes.toString().length<2)
            mm="0"+minutes.toString();
        else
            mm=minutes.toString();
        if(seconds.toString().length<2)
            ss="0"+seconds.toString();
        else
            ss=seconds.toString();
        return hh+":"+mm+":"+ss
    }

    Timer
    {
        id:backTimer
        repeat: false
        running: false;
        interval: 200;
        onTriggered:
        {
            addVideoPingData();
            backToParent();
        }
    }

    ZybBackButton
    {
        id:back
        z:100
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        onBackClicked: {
            addVideoPingData();
            console.log("onBackClicked",player.playbackState,player.status);
            if(player.playbackState !==  MediaPlayer.StoppedState)
            {
                //player.pause();
                console.log("player stop back")
                player.stop();
            }
            backToParent();
        }
    }

    property var curSpeed: "1X"
    property color itemBgColor: Qt.rgba(60/255, 61/255, 66/255, 0.6)
    function setPlayerSpeed(speed)
    {
        var num = parseFloat(speed.slice(0,speed.length-1))
        console.log(num);
        player.playbackRate = num
        if(player.playbackState ===  MediaPlayer.PlayingState)
            player.seek(player.position - 1000);
    }

    function initSpeedBtn()
    {
        btnPlaySpeed.text = "1X";
        var vspeed = btnPlaySpeed.text;
        for(var i=0;i<playSpeedGroup.buttons.length;i++)
        {
            if( playSpeedGroup.buttons[i].text === vspeed)
            {
                playSpeedGroup.buttons[i].checked = true;
            }
        }

    }

    function hideSpeedBtns()
    {
        speedRow.visible = false;
    }

    BasicButton{
        id:btnPlaySpeed
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 20
        fontsize:28
        implicitWidth: 98
        implicitHeight: 56
        backgroundTheme: itemBgColor
        text: curSpeed
        checkable: false
        z:100
        onClicked:
        {
            speedRow.visible = !speedRow.visible
        }
    }

    ButtonGroup{
        id:playSpeedGroup
        exclusive:true
    }

    Row {
        id:speedRow
        spacing: 10
        anchors.right: btnPlaySpeed.left
        anchors.rightMargin: 10
        anchors.verticalCenter: btnPlaySpeed.verticalCenter
        z:200
        visible: false
        Repeater {
            model: ["0.75X","1X","1.25X","1.5X","2X"]
            BasicButton{
                fontsize:28
                implicitWidth: 98;
                implicitHeight: 56;
                backgroundTheme: "#53555C"
                text: modelData
                autoExclusive: true
                checkable: true;
                ButtonGroup.group: playSpeedGroup
                z:100
                onClicked:
                {
                    console.log("speed btn clicked =", modelData)
                    if(dataManager.getLive() === false)
                    {
                        hideSpeedBtns();
                        hideControls(0)
                        hideStatusSlider(0);
                        main.showTip(qsTr("网络未连接，请连接网络后重试"));
                        return;
                    }
                    btnPlaySpeed.text = modelData;
                    setPlayerSpeed(modelData);
                    timer.restart();
                }
            }
        }
    }


    function addVideoPingData()
    {
        res = {};
        if(player.position > 100)
        {
            res["course"] = course;
            res["total"] = player.duration;
            res["palyed"] = player.position;
            res["tid"] = tid;
            res["type"] = type;
            res["vip"] = devManager.getVipStatus();
            res["video_Id"] = videoId;
            apiNetWork.sendApiOnlinePingData(res);
            pingManager.addPingData(PingDefine.PING_EVENT_TID_VIDEO_DETAIL,res);
        }
    }

    RotationImage
    {
        id:videoBusyImg
        source: "qrc:/images/setLoading46x44.png"
        anchors.centerIn: parent
        visible: false
        z:100
    }

    ZybText
    {
        id:cacheText
        text: qsTr("视频缓冲中...")
        color: "#999999"
        font.pixelSize: Style.tipFontPixel
        anchors.top: videoBusyImg.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        visible: videoBusyImg.visible
    }

    Image {
        id:pausebtn
        source: player.playbackState ===  MediaPlayer.PlayingState ? "qrc:/images/pause88.png" :"qrc:/images/play88.png"
        width:88
        height: 88
        anchors.centerIn: parent
        enabled: opacity===1
        z:10

        Behavior on opacity { PropertyAnimation{ duration: 500 } }

        MouseArea
        {
            id:mouse
            anchors.fill: parent
            anchors.margins: -16

            onClicked:
            {
                hideSpeedBtns();
                timer.restart();
                if(dataManager.getLive() === false)
                {
                    main.showTip(qsTr("网络未连接，请连接网络后重试"));
                    return;
                }
                //console.log("pause btn clicked",output.contentRect);
                console.log(player.status , player.playbackState)
                if(player.status == MediaPlayer.Loaded)
                {
                    if(player.playbackState ==  MediaPlayer.PlayingState)
                    {
                        player.pause();
                    }
                    else if(player.playbackState ==  MediaPlayer.StoppedState)
                    {
                        start();
                    }
                    else if(player.playbackState ==  MediaPlayer.PausedState)
                    {
                        start();
                    }

                }
                else  if(player.status == MediaPlayer.EndOfMedia)
                {
                    start();
                    //endStart(videoId);
                }
                else  if(player.status == MediaPlayer.Buffered)
                {

                    if(player.playbackState ==  MediaPlayer.PlayingState)
                    {
                        player.pause();
                    }
                    else if(player.playbackState ==  MediaPlayer.StoppedState)
                    {
                        start();
                    }
                    else if(player.playbackState ==  MediaPlayer.PausedState)
                    {
                        start();
                    }
                }
            }
        }
    }

    RowLayout
    {
        id:timeStatus
        z:10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom


        Behavior on opacity { PropertyAnimation{ duration: 500 } }

        Text {
            id: curTime
            text: currentTime(player.position)
            color: "#ffffff"
            font.pixelSize: 20
        }

        Slider
        {
            id:timeSpan
            orientation: Qt.Horizontal
            from: 0
            value: player.position
            to:player.duration
            stepSize: 1
            Layout.fillWidth: true
            implicitWidth: 540
            z:10

            background: Rectangle {
                x: timeSpan.leftPadding
                y: timeSpan.topPadding + timeSpan.availableHeight / 2 - height / 2
                implicitWidth: 540
                implicitHeight: 9
                width: timeSpan.availableWidth
                height: implicitHeight
                radius: implicitHeight/2
                color: "#33F2F3FA"

                Rectangle {
                    width: timeSpan.visualPosition * parent.width
                    height: parent.height
                    color: Style.mainColor
                    radius: 2
                }
            }

            Timer
            {
                id:sliderTimer
                repeat: false
                interval: 120
                onTriggered:
                {
                    console.log("slider timer onTriggered ")
                    player.seek(timeSpan.value-100)
                    timer.restart();
                }
            }

            onMoved: {
                sliderTimer.restart();
                hideControls(1);
            }


            handle: Rectangle {
                x: timeSpan.leftPadding + timeSpan.visualPosition * (timeSpan.availableWidth - width)
                y: timeSpan.topPadding + timeSpan.availableHeight / 2 - height / 2
                implicitWidth: 24
                implicitHeight: 24
                radius: 12
                //color:  Style.mainColor
                color: timeSpan.pressed
                       ?Qt.darker("#FFFFFF")
                       :"#FFFFFF"
                border.width: 8
                border.color: Style.mainColor
            }
        }

        Text {
            id: totalTime
            text: currentTime(player.duration)
            color: "#ffffff"
            font.pixelSize: 20
        }

    }



    VideoSlider
    {
        id:statusSlider
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 206
        height: 28
        z:9

        slider.value :0.3
        Behavior on opacity { PropertyAnimation{ duration: 500 } }
    }

    function hideVideoBusyImage()
    {
        videoBusyImg.visible = false;
    }

    function showVideoBusyImage()
    {
        videoBusyImg.visible = true;
    }

    function hideControls(b)
    {
        timeStatus.opacity = b
        pausebtn.opacity=b
    }

    function hideStatusSlider(b)
    {
        statusSlider.opacity = b;
    }


    property  var res : new Object;

    MediaPlayer {
        id: player;
        source: control.source
        onPositionChanged:
        {
            //console.log("onPositionChanged",position);
            if(position > 50)
            {
                hideVideoBusyImage();
            }
            if(position >= freePlayTime && freePlayWarnSended==false)
            {
                freePlayWarnSended=true;
                freePlayEnd();
            }

        }

        onError: {
            console.error("MediaPlayer error:",errorString);
            main.showTip(qsTr("播放出错，请稍后重试"));
            hideVideoBusyImage();
        }


        onPlaying:
        {
            console.log("***************on playing ***************")
            //dataManager.setVideoTinyMix();
        }

        onStatusChanged:
        {
            console.warn("onStatusChanged",status);
            switch(status)
            {
            case 3:
                freePlayTime = player.duration*0.2
                timeSpan.stepSize = Math.floor(player.duration/100)
                console.log("loaded freePlayTime",freePlayTime,player.duration)
                console.log("timeSpan.stepSize",timeSpan.stepSize)
                break
            case 6:

                if(freePlayTime === 60000)
                {
                    freePlayTime = player.duration*0.2
                    timeSpan.stepSize = Math.floor(player.duration/100)
                    console.log("loaded freePlayTime",freePlayTime,player.duration)
                }
                console.log("timeSpan.stepSize",timeSpan.stepSize)
                break

            }
        }

        onPlaybackStateChanged:
        {
            console.warn("PlayingState=",MediaPlayer.PlayingState,"StoppedState=",MediaPlayer.StoppedState,"PausedState=",MediaPlayer.PausedState
                         ,"onPlaybackStateChanged",player.playbackState); //1 0
            if(player.playbackState ===  MediaPlayer.PlayingState) // 1
            {
                engineSocket.sendEnableSysAutoOffScreen(false);
                devStateMonitor.setDevState(DevStatus.DevState_MediaPlaying);
            }
            else
            {
                engineSocket.sendEnableSysAutoOffScreen(true);
                devStateMonitor.setDevState(DevStatus.DevState_Normal);

                if(player.playbackState ===  0)
                {
                    console.warn("paly over")
                    freePlayWarnSended=false;
                    timer.stop();
                    hideControls(1);
                }
            }
        }


    }

    Connections {
        target: player
        onMediaObjectChanged: {
            console.log("enter player.mediaObject");
            if (player.mediaObject)
            {
                console.log("player.mediaObject.notifyInterval = 50");
                player.mediaObject.notifyInterval = 50;
            }
        }

    }

    function initAudio()
    {
        statusSlider.slider.value = devManager.getSoundVal();
        player.volume = devManager.getSoundVal();
        //console.warn("player volumn",devManager.getSoundVal());
        if(devManager.getSoundVal() <= 0.01)
        {
            statusSlider.imgSource = "qrc:/images/vedio_icon_volume_quiet.png"
        }
        else if(devManager.getSoundVal() >= 0.6)
        {
            statusSlider.imgSource = "qrc:/images/vedio_icon_volume_high.png"
        }
        else
        {
            statusSlider.imgSource = "qrc:/images/vedio_icon_volume_low.png"
        }

    }

    function initLight()
    {
        var value = devManager.getLightVal();
        statusSlider.slider.value = value;
        if(value > 0.65)
        {
            statusSlider.imgSource = "qrc:/images/control_icon_bright_high.png"
        }
        else if(value < 0.25)
        {
            statusSlider.imgSource = "qrc:/images/control_icon_bright_low.png";
        }
        else
        {
            statusSlider.imgSource = "qrc:/images/control_icon_bright_medium.png"
        }
    }

    SwipeArea
    {
        id:audioArea
        anchors.left: parent.left
        anchors.top:  parent.top //back.bottom
        anchors.topMargin: 0//15
        anchors.bottom: parent.bottom
        anchors.right: output.left
        z:0

        onMousePresed:
        {
            hideSpeedBtns();
            hideControls(1);
            initAudio();
            hideStatusSlider(1);
        }

        onReleased:
        {
            //console.log("onReleaseed");
            timer.restart();
            pingManager.addPingData(PingDefine.PING_EVENT_TID_MEDIA_VOLUME);
        }


        onUpmove:{
            engineSocket.sendVolumnBig()
            initAudio();
            volumeChanged = true
        }

        onDownmove:{
            engineSocket.sendVolumnSmall()
            initAudio();
            volumeChanged = true
        }

    }

    SwipeArea
    {
        id:lightArea
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: output.right
        z:0

        onMousePresed:
        {
            hideSpeedBtns();
            hideControls(1);
            initLight();
            hideStatusSlider(1);
        }

        onReleased:
        {
            //console.log("onReleaseed");
            timer.restart();
            pingManager.addPingData(PingDefine.PING_EVENT_TID_MEDIA_LIGTH);
        }

        onUpmove:{
            engineSocket.sendLightBright()
            initLight();
            lightChanged = true
        }

        onDownmove:{
            engineSocket.sendLightDark()
            initLight();
            lightChanged = true
        }
    }


    VideoOutput {
        id:output
        //anchors.fill: parent;
        width: height*16/9
        height: Style.gHeight
        x : (Style.gWidth - Style.gHeight*16/9)/2
        y : 0
        //        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        //        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        source: player;
        //fillMode: VideoOutput.Stretch

        PinchArea{
            id:pinchArea
            anchors.fill: output
            pinch.target: output
            pinch.maximumScale: 3
            pinch.minimumScale: 0.6
            pinch.dragAxis:Pinch.XAndYAxis

            MouseArea {
                id:videoMouseArea
                anchors.fill: parent;
                drag.target: output
                //                x:output.contentRect.x
                //                y:output.contentRect.y
                //                width: output.contentRect.width
                //                height: output.contentRect.height

                onClicked: {
                    console.log("rect=:",output.contentRect)
                    console.log("audioArea",audioArea.width,audioArea.height,audioArea.x,audioArea.y)
                    hideControls(1);
                    timer.restart();
                    hideSpeedBtns();
                    //console.log(player.status +" --- " + player.playbackState +"||"+ MediaPlayer.NoMedia+"||"+ MediaPlayer.PlayingState);

                }
            }

            onPinchFinished: {
                if(output.y > output.height || output.y < -output.height)
                {
                    output.y = 0
                }

                if(output.x > Style.gWidth || output.x < -Style.gWidth)
                {
                    output.x = (Style.gWidth - Style.gHeight*16/9)/2
                }
            }
        }

//        onYChanged:
//        {
//            console.log("x=",output.x,",y=",output.y, pinchArea.height,output.width,output.height)
//            console.log("scale=",pinchArea.scale, output.width*pinchArea.scale,output.height*pinchArea.scale)
//        }

    }



    Timer {
        id:timer
        interval: 4000; running: false; repeat: false
        onTriggered:
        {
            hideControls(0)
            hideStatusSlider(0);
            hideSpeedBtns();
        }
    }


    function stopPlay()
    {
        if(player.playbackState ==  MediaPlayer.PlayingState)
        {
            player.pause();
        }

    }

    function startPlay()
    {
        if(player.playbackState ==  MediaPlayer.PausedState)
        {
            start();
        }
    }

    Connections {
        target: engineSocket;
        onSig_offScreenKey:{
            stopPlay();
        }

        onSig_btPlayStatusChanged:
        {
            if(player.playbackState ==  MediaPlayer.PausedState)
            {
                start();
                hideControls(0);
                timer.restart();
                return;
            }


            if(player.playbackState ==  MediaPlayer.PlayingState)
            {
                player.pause();
                hideControls(1);
                timer.restart();
                return;
            }
        }

        onSig_btDisconnect:
        {
            if(player.playbackState ==  MediaPlayer.PlayingState)
            {
                player.pause();
                hideControls(1);
                timer.restart();
            }
        }
        onSig_btStatusChanged:
        {
            if(sta == 1 )
            {
                player.pause();
                hideControls(1);
                timer.restart();
            }
        }
    }

    onVisibleChanged:
    {
        hideControls(0);
        hideStatusSlider(0);

        if(visible === false)
        {
            console.log( "videoItem visible = false")
            hideSpeedBtns();
            videoPlayClicked = false
            if(player.playbackState !==  MediaPlayer.StoppedState)
            {
                console.log("player stop visible = false")
                player.stop();
                console.log("player stop visible = false2")
            }
            console.log("dataManager.abortM3u8()");
            dataManager.abortM3u8();
            engineSocket.sendEnableSysAutoOffScreen(true);
        }
        else
        {
            showVideoBusyImage();
            console.log("video Component. onVisibleChanged true ***********************")
            output.height = Style.gHeight;
            output.width =  Style.gHeight*16/9
            output.x = (Style.gWidth - Style.gHeight*16/9)/2
            output.y = 0;
            output.scale = 1;
            //timer.restart();
            player.playbackRate = 1.0
            initSpeedBtn();
            freePlayWarnSended=false;
        }
    }


    Component.onCompleted:
    {
        console.log("video Component.onCompleted")
        player.volume = devManager.getSoundVal();
        hideControls(0);
        hideStatusSlider(0);
    }

    Component.onDestruction:
    {
        console.log("videoItem onDestruction",player.duration,player.position);
        if(videoPlayClicked)
            addVideoPingData();
        if(player.playbackState !==  MediaPlayer.StoppedState)
        {
            console.log("player onDestruction stop")
            player.stop();
        }
        devManager.saveConfigFile();
    }

}



