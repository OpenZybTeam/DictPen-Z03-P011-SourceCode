import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import "../Global"
import com.zyb.PingDefine 1.0

Rectangle{
    id:root
    anchors.fill: parent
    color: Style.mainbgColor
    z:2
    property var controlData: new Object
    property var currrentRes: new Object
    property var exampleCells: new Array
    property var wordText: ""
    property var transText: ""
    property bool isWordStored: false

    ZybStoreButton{
        id:storeButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 27
        z:1
        onClicked: {
            isStored = !isStored;
            if(!isStored){
                unStore();
                main.showTip(qsTr("已取消收藏"));
            }
            else{
                store()
                main.showTip(qsTr("已收藏到生疏归纳"));
            }
        }
    }


    ZybVolumeButton{
        id: volumeButton
        y: Style.scanresult_volume_y
        anchors.right: parent.right
        anchors.rightMargin: 27
        z:1
        onClicked: {
            ScanViewLogic.gotoWordQueryVolumnPage();
        }
    }

    ZybMicrophoneButton{
        id: microPhoneButton
        y: Style.scanresult_microphone_y
        anchors.right: parent.right
        anchors.rightMargin: 27
        z:1
        onClicked: {
            if(dataManager.getLive() === false){
                UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                return;
            }
            ScanViewLogic.gotoFollowView(wordText);
        }
    }

    Image{
        id : topbtn
        source: "qrc:/images/top66x56.png"
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        z:1
        MouseArea{
            anchors.fill: parent
            onClicked: {
                flickable.contentY = 0;
            }
        }
    }


    Flickable {
        id:flickable
        anchors.fill: parent
        contentHeight: colume.height + title.height + 100 + 80
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true
        property var contentCoordY: 0 //记录滚动条位置
        property var preContentY: 0 //判断滑动方向

        Timer{
            id:flicktimer
            interval: 1500;
            repeat: false;
            running: false
            onTriggered: {
                topbtn.visible = false;
            }
        }

        onFlickStarted:
        {
            if(contentY > Style.gHeight && preContentY >contentY){
                topbtn.visible = true;
                flicktimer.stop();
            }
        }

        onMovementEnded: {
            preContentY = contentY;
            flicktimer.restart();
        }

        ZybBackButton{
            id:backButton
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            onBackClicked: {
                QueryWordManager.playStop();
                root.destroy();
            }
        }

        Flickable{
            id:titleFlick
            anchors.left: backButton.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 27+72
            anchors.verticalCenter: backButton.verticalCenter
            height: backButton.height
            ScrollBar.horizontal: ScrollBar {visible: false } //创建一个滚动条
            contentWidth: title.width
            clip: true
            property var contentCoordX: 0 //记录滚动条位置
            Text {
                id: title
                text: qsTr("text")
                font.family: Style.fontFamily
                font.pixelSize: 36
                color: Style.fontColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Component.onCompleted: {
                contentCoordX = contentX;
            }

            onVisibleChanged: {
                if(visible){
                    contentX = contentCoordX;
                }
            }
        }

        Column{
            id:colume
            anchors.top: backButton.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.right: parent.right
            anchors.rightMargin: 27+72

            EnChContainer{
                id:enchDictContainer
                width: colume.width
            }

            Item{
                height: 18
                width: root.width
            }

        }

        Item{
            id:errorControl
            width: root.width
            height: 56
            anchors.left: parent.left
            anchors.top: colume.bottom
            anchors.topMargin: 18
            RowLayout{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                ZybErrorButton{
                    id: errorButton
                    implicitWidth: 180
                    implicitHeight: 56
                    onReport: {
                        var valueObj = new Object;
                        valueObj["word"] = root.wordText;
                        valueObj["wordType"] = "en";
                        pingManager.addPingData(PingDefine.PING_EVENT_DICT_ERROR,valueObj);
                        WordHistoryManager.addErrorItem(root.wordText);
                        if(dataManager.getLive()){
                            apiNetWork.sendApiWordPicFeedback();
                        }
                    }
                }

                HelpButton{
                    id: helpButton
                    visible: false
                    implicitWidth: 180
                    implicitHeight: 56
                    onClicked: {
                        UILogic.openTipPage("scanword")
                    }
                }
            }
//            ZybErrorButton{
//                id: errorButton
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                onReport: {
//                    var valueObj = new Object;
//                    valueObj["word"] = root.wordText;
//                    valueObj["wordType"] = "en";
//                    pingManager.addPingData(PingDefine.PING_EVENT_DICT_ERROR,valueObj);
//                    WordHistoryManager.addErrorItem(root.wordText);
//                }
//            }
        }

        Component{
            id:exampleComponent
            EnchExampleComponent{
                width: root.width
            }
        }

        Timer{
            id:autospeakTimer
            interval: GlobalProperty.autoSpeekDelay
            repeat: false;
            running: false
            triggeredOnStart: false
            onTriggered:{
                if(!root.visible)
                    return;
                if(soundItem.visible){
                    if(devManager.getSpeekMode() === 0 && americaPhonetic.isHaveSound){
                        americaPhonetic.play();
                    }
                    else if(devManager.getSpeekMode() === 1 && englishPhonetic.isHaveSound){
                        englishPhonetic.play();
                    }
                }
                else{
                    orgPlay.play();
                }
            }
        }

        Component.onCompleted: {
            contentCoordY = contentY;

        }

        onVisibleChanged: {
            if(visible){
                contentY = contentCoordY;
            }
        }
    }

    Connections {
        target: scanManager;

        onSig_scanDown:{
            root.destroy();
        }
    }

    Component.onCompleted:{
        errorButton.isReport = false;
        if(root.currrentRes["result"] === undefined){
            return;
        }
        wordText = root.currrentRes["word"];
        var queryRes = root.currrentRes["result"];
        controlData = queryRes;
        title.text = wordText;

        if(WordHistoryManager.isWordStore(root.currrentRes["word"])){
            storeButton.isStored = true;
        }
        else{
            storeButton.isStored = false;
        }
        enchDictContainer.setData(root.currrentRes)
    }

    function store(){
        var valueObj = new Object;
        valueObj["store"] = "true"
        valueObj["wordType"] = "en"
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_STORE,valueObj);
        WordHistoryManager.addStoreItem(root.currrentRes,1);
        storeButton.isStored = true;
    }

    function unStore(){
        var valueObj = new Object;
        valueObj["store"] = "false"
        valueObj["wordType"] = "en"
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_STORE,valueObj);
        WordHistoryManager.removeStoreItem(root.wordText,1);
        storeButton.isStored = false;
    }
}


