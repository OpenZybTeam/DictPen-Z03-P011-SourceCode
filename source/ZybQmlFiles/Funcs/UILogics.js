
function isValid(obj) {
    var valid = (obj !== undefined) && (obj !== null);
    return valid;
}

function sleep(time) {
    var startTime = new Date().getTime() + parseInt(time, 10);
    while(new Date().getTime() < startTime) {}
};

function goToMainWindow() {
    main.close();
}

function backToHome() {
    main.close();
}

function backToSetPage() {
    main.backToSetPage();
}

function showTip(str,showTime) {
    if(!showTime || !isValid(showTime)){
        showTime = 2000;
    }
    main.showTip(str,showTime)
}

function closeTip(){
    main.closeTip();
}

function openWebSocket(type)
{
    var url = "ws://ws-api.turingapi.com/api/v2";
    websocket.openWebSocket(url,type)
}

function openOwnrTranseVoice()
{
    var url = "wss://speech.zuoyebang.com/asr/cn/hardware/v2/ws/speech";
    ownrtansvoice.openWebSocket(url)
}

function showWordResView(strInput){
    main.showWordResView(strInput);
}

function closeWordResView(){
    main.closeWordResView();
}

function setWordResViewPos(pos){
    main.wordResViewToPos(pos);
}

function getWordResViewPos(){
    return main.getwordResViewPos();
}

function confirmOperator(message, leftText,rightText,acceptedCall, rejectedCall,isCloseVisible,cancelVisibel) {
    dlgUtils.close();
    return dlgUtils.openMsgDlg(message, leftText,rightText,acceptedCall, rejectedCall,isCloseVisible,cancelVisibel);
    //    openMsgDlg( message, leftText,rightText,acceptedCall, rejectedCall)
}

function openWifiPage(connectCall,backCall){
    return wifiUtils.openWifiPage(connectCall,backCall);
}

function openTipPage(state){
    console.log("openTipPage")
    return dlgUtils.openTipPage(state);
}


function getCurImageName()
{
    var filepath = devManager.getTmpQuesHisDir()+ devManager.genUuid();//+ ".jpg";
    return filepath;
}

function startOta(){
    if(dataManager.getLive() === false){
        showTip(qsTr("网络未连接，请连接网络后重试"));
        return;
    }

    console.log("onClicked 2");
    if((devManager.getNewVersionSize() + (1024*1024*1024 + 100*1024*1024))  >= devManager.getFreeDisk("/mnt/data") ){
        devManager.rmLogFiles();
        if((devManager.getNewVersionSize() + (1024*1024*1024 + 100*1024*1024))  >= devManager.getFreeDisk("/mnt/data") ){
            main.showTip(qsTr("磁盘空间不足请删除收藏夹和历史记录内容"));
            return;
        }
    }
    if(dataManager.getCheckIntLiveMode() === 1){
        confirmOperator(qsTr("正在使用流量,是否连接WiFi下载"),qsTr("继续下载"),qsTr("连接WiFi"),
                                function() {
                                    GlobalProperty.isOtaDownloadAbord = true;
                                    if(!GlobalProperty.isWifiPageVisible){
                                        openWifiPage(function(){
                                            OtaManager.downLoad(devManager.getNewUrl());
                                            devManager.setIsDownloading(true);
                                        },
                                        function(){
                                        })
                                    }

                                },
                                function() {
                                    OtaManager.downLoad(devManager.getNewUrl());
                                    devManager.setIsDownloading(true);

                                },
                                false,true);
    }
    else{
        OtaManager.downLoad(devManager.getNewUrl());
        devManager.setIsDownloading(true);
    }
}

function getQuesResult(rect,pareWid,pareHight)
{
    dataManager.clipImage(rect,pareWid,pareHight);
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

function currentTimeMMSS(time)
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

    if(hh !== "00")
    {
        return hh + ":" + mm+":"+ss;
    }
    else
    {
        return mm+":"+ss;
    }

}

function curentTime(){
    var now = new Date();
    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    var day = now.getDate();            //日
    var hh = now.getHours(); //时
    var mm = now.getMinutes();  //分
    var ss = now.getSeconds();

    var clock = year + "-";
    if(month < 10)
        clock += "0";
    clock += month + "-";
    if(day < 10)
        clock += "0";
    clock += day + " ";
    if(hh < 10)
        clock += "0";
    clock += hh + "-";
    if (mm < 10) clock += '0';
    clock += mm+"-";

    if (ss < 10) clock += '0';
    clock += ss;

    return(clock);

}


function curentMsTime(){
    //var t = new Date();
    return(new Date / 1);
}

function connectSignalOnce(signalObject, callback) {
    function internal() {
        signalObject.disconnect(internal);
        // console.debug("emit signal and trigged internal funciton and callback");
        callback();
    }
    signalObject.connect(internal);
    return internal;
}

//fun1 backclicked
//fun2 进入打印预览界面
//fun3 预览界面渲染完成
function async_createPrintPage(parent,fun1,fun2,fun3,ismuti)
{
    var finishCreation = function()
    {
        if (component.status === Component.Ready)
        {
            var incubator = component.incubateObject(parent, {muti:ismuti}, Qt.Asynchronous);
            if (incubator.status !== Component.Ready)
            {
                incubator.onStatusChanged = function(status)
                {
                    if (status === Component.Ready)
                    {
                        print("Async Create Object Success")
                        var backFunction = function()
                        {
                            incubator.object.destroy(100)
                            fun1();
                        }

                        incubator.object.backClicked.connect(backFunction);
                        incubator.object.h5LoadFinished.connect(fun3);
                        console.log(' printh5 Loaded')
                        fun2();
                    }
                }
            }
        }
    }
    var component = Qt.createComponent("qrc:/ZybQmlFiles/ZybCamera/ResultPrintPage.qml", Component.Asynchronous, parent);
    if (component.status === Component.Ready)
    {
        finishCreation();
    }
    else
    {
        component.statusChanged.connect(finishCreation);
    }

}
