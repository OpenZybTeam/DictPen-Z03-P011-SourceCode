import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "./ZybQmlFiles/ZybVoiceTrans"
import "./ZybQmlFiles/Style"
import "./ZybQmlFiles/ZybControls"
import com.zyb.PingDefine 1.0

Item {
    id: navi
    property int itemHeight: 25
    property string sceneSource: ""
    property var listData: ""
    property alias listView: naListView

    property string tidTitle: qsTr("答疑")
    anchors.fill: parent

    function updateTidTitle()
    {
        tidMode.setProperty(0,"name",qsTr("扫描")+devManager.getNetMainTitle());
        tidMode.setProperty(1,"name",qsTr("识题")+devManager.getNetMainTitle());
    }

    function updateSetIcon()
    {
        console.log("updateSetIcon")
        if(dataManager.getLive())
        {
            var haveRed = false;
            if(devManager.getFlow4GAlertMsg().length > 0)
            {
                if(devManager.get4GRedEntered() === false)
                {
                    haveRed= true;
                    if(devManager.getVipStatus() === -1)
                    {
                        haveRed = false;
                    }
                }
            }

            if(devManager.getVipRemainDays() <= 10 && devManager.getVipRemainDays() > 1)
            {
                if(devManager.getVipRed10Entered() === false)
                    haveRed= true;
            }
            else if(devManager.getVipRemainDays() <= 1)
            {
                if(devManager.getVipRed1Entered() === false)
                    haveRed= true;
            }

            if(devManager.getSvipRemainDays() <= 10 && devManager.getSvipRemainDays() > 1)
            {
                if(devManager.getSvipRed10Entered() === false)
                    haveRed= true;
            }
            else if(devManager.getSvipRemainDays() <= 1)
            {
                if(devManager.getSvipRed1Entered() === false)
                    haveRed= true;
            }

            if(devManager.getLatested() === false && devManager.getUpdateRedEntered() === false){
                haveRed= true;
            }

            if(haveRed)
            {
                if(Style.highVersion){
                    tidMode.setProperty(6,"icon_high","qrc:/images/main_set_red_high.png");
                    dictMode.setProperty(5,"icon_high","qrc:/images/main_set_red_high.png");
                }
                else{
                    tidMode.setProperty(6,"icon","qrc:/images/main_set_red.png");
                    dictMode.setProperty(5,"icon","qrc:/images/main_set_red.png");
                }

            }
            else
            {
                if(Style.highVersion){
                    tidMode.setProperty(6,"icon_high","qrc:/images/main_set_high.png");
                    dictMode.setProperty(5,"icon_high","qrc:/images/main_set_high.png");
                }
                else{
                    tidMode.setProperty(6,"icon","qrc:/images/main_set.png");
                    dictMode.setProperty(5,"icon","qrc:/images/main_set.png");
                }
            }
        }
    }

    function resetModel()
    {
        if(devManager.getScanForWhat()===0)
        {
            listData = dictMode;
        }
        else
        {
            naListView.leftMargin =  25
            naListView.rightMargin = 25
            listData = tidMode;
        }
    }

    ListModel {
        id: tidMode
        ListElement { name: qsTr("扫题答疑"); type:1; icon:"qrc:/images/main_scan_tid.png";icon_high:"qrc:/images/main_scan_tid_high.png"; source: "qrc:/ZybQmlFiles/ZybScanForTid/ScanTipPage.qml" }
        ListElement { name: qsTr("识题答疑"); type:2; icon:"qrc:/images/main_camera_tid.png";icon_high:"qrc:/images/main_camera_tid_high.png"; source: "qrc:/ZybQmlFiles/ZybCamera/CameraPage.qml" }
        ListElement { name: qsTr("语音翻译"); type:4; icon:"qrc:/images/main_voice.png";icon_high:"qrc:/images/main_voice_high.png"; source: "qrc:/ZybQmlFiles/ZybVoiceTrans/VoiceTrans.qml" }
        ListElement { name: qsTr("语音通话"); type:4; icon:"qrc:/images/main_phone.png";icon_high:"qrc:/images/main_phone_high.png"; source: "qrc:/ZybQmlFiles/ZybPhone/Phone.qml" }
        ListElement { name: qsTr("生疏归纳"); type:5; icon:"qrc:/images/main_store.png";icon_high:"qrc:/images/main_store_high.png"; source: "qrc:/ZybQmlFiles/ZybStore/StoreView.qml" }
        ListElement { name: qsTr("历史记录"); type:6; icon:"qrc:/images/main_history.png";icon_high:"qrc:/images/main_history_high.png"; source: "qrc:/ZybQmlFiles/ZybStore/HistoryView.qml" }
        ListElement { name: qsTr("设置"); type:7;icon:"qrc:/images/main_set.png";icon_high:"qrc:/images/main_set_high.png"; source: "qrc:/ZybQmlFiles/ZybSet/SetMainPage.qml" }
    }

    ListModel {
        id: dictMode
        ListElement { name: qsTr("扫描查词"); type:3; icon:"qrc:/images/main_scan_trans.png";icon_high:"qrc:/images/main_scan_trans_high.png"; source: "qrc:/ZybQmlFiles/ZybLayoutViews/ZybScanWordView2.qml" }
        ListElement { name: qsTr("语音翻译"); type:4; icon:"qrc:/images/main_voice.png";icon_high:"qrc:/images/main_voice_high.png"; source: "qrc:/ZybQmlFiles/ZybVoiceTrans/VoiceTrans.qml" }
        ListElement { name: qsTr("语音通话"); type:4; icon:"qrc:/images/main_phone.png";icon_high:"qrc:/images/main_phone_high.png"; source: "qrc:/ZybQmlFiles/ZybPhone/Phone.qml" }
        ListElement { name: qsTr("生疏归纳"); type:5; icon:"qrc:/images/main_store.png";icon_high:"qrc:/images/main_store_high.png"; source: "qrc:/ZybQmlFiles/ZybStore/StoreView.qml" }
        ListElement { name: qsTr("历史记录"); type:6; icon:"qrc:/images/main_history.png";icon_high:"qrc:/images/main_history_high.png"; source: "qrc:/ZybQmlFiles/ZybStore/HistoryView.qml" }
        ListElement { name: qsTr("设置"); type:7;icon:"qrc:/images/main_set.png";icon_high:"qrc:/images/main_set_high.png"; source: "qrc:/ZybQmlFiles/ZybSet/SetMainPage.qml" }
    }


    Component {
        id: mdelegate

        MToolButton {
            id:btn

            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 25
            txt: name
            pix: Style.highVersion ? icon_high : icon
            width: 96
            height: Style.highVersion? 134:138
            //radius: 0
            //color: "transparent"
            onMyclicked:{
                navi.sceneSource = source

                //console.warn(name);
                if(name === qsTr("扫题答疑"))
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_NAVI_SCAN_TID_BUTTON);
                }
                else if(name === qsTr("识题答疑"))
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_NAVI_CAMERA_BUTTON);
                }
                else if(name === qsTr("扫描查词"))
                {
                    pingManager.addPingData(PingDefine.PING_EVNET_NAVI_DICT_BUTTON);
                }
                else if(name === qsTr("语音翻译"))
                {
                    pingManager.addPingData(PingDefine.PING_EVENT_NAVI_VOICE_TRANS);
                }
                else if(name === qsTr("生疏归纳"))
                {
//                    pingManager.addPingData(PingDefine.PING_EVENT_ENTER_STORE_PAGE);
                }
            }
        }
    }

    ListView {
        id: naListView
        spacing: 80
        anchors.fill: parent
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        orientation: ListView.Horizontal
        model:listData
        delegate: mdelegate
    }

    Component.onCompleted:
    {
        updateTidTitle();
        console.log("navi panel complete updataSetIcon");
        updateSetIcon();
    }

}
