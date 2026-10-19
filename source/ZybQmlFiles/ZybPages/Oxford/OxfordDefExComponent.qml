import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"
import com.zyb.PingDefine 1.0
import "../../Funcs/UILogics.js" as UILogic

Item {
    id:root
    height: enText.height + (chText.visible ? chText.height : 0) + 20
    property var controlData: null

    Item {
        id: headItem
        height: 23
        width: 23
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.left: parent.left

        Rectangle{
            width: 10
            height: 10
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#FFFFFFFF"
        }
    }

    Text {
        id: enText
        anchors.top: parent.top
        anchors.left: headItem.right
        anchors.leftMargin: 29
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        font.family: Style.engFontFamily
        font.pixelSize: 28
        Component.onCompleted: {
            if(contentWidth < parent.width - 150){
                width = contentWidth;
            }
            else{
                width = parent.width - 150;
            }
        }
    }

    Text {
        id: chText
        width: parent.width - 100
        anchors.left: enText.left
        anchors.top: enText.bottom
        anchors.topMargin: 10
        wrapMode: Text.WordWrap
        font.family: Style.chFontFamily
        font.pixelSize: 28
        color: "#818181"
        text: qsTr("text")
    }

    Image {
        id: soundPlay
        property var audioName: ""
        anchors.left: enText.right
        anchors.leftMargin: 16
        anchors.top: enText.top
        visible: false
        source: "qrc:/images/soundplay1_1.png"

        MouseArea{
            height: parent.height + 20
            width: parent.width + 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                if(soundPlayConnect.enabled === false){
                    QueryWordManager.playStop();
                    soundPlayConnect.enabled = true;
                    if(QueryWordManager.playUrl(soundPlay.audioName) === 0){
                        var valueObj = new Object;
                        valueObj["dictType"] = "oxford"
                        pingManager.addPingData(PingDefine.PING_EVENT_DICT_EXAMPLE_SPEECH,valueObj);
//                        timer.triggerCount = 0;
//                        timer.running = true;
                    }
                    else{
                        soundPlayConnect.enabled = false;
                        UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                    }
                }
                else{
                    soundPlayConnect.enabled = false;
                    timer.running = false;
                    soundPlay.source = "qrc:/images/soundplay1_1.png"
                    QueryWordManager.playStop();
                }
            }
        }
    }

    Connections{
        id:soundPlayConnect
        enabled:false
        target:QueryWordManager
        onAudioStart:{
            timer.triggerCount = 0;
            timer.running = true;
        }
        onAudioStop:{
            enabled = false;
            timer.running = false;
            soundPlay.source = "qrc:/images/soundplay1_1.png"
        }
    }

    Timer{
        id:timer
        interval: 400
        running: false
        triggeredOnStart: true
        repeat: true
        property var triggerCount: 0
        onTriggered: {
            triggerCount = triggerCount + 1;
            if(triggerCount%3 === 0){
                soundPlay.source = "qrc:/images/soundplay1_2.png"
            }
            else if(triggerCount%3 === 1){
                soundPlay.source = "qrc:/images/soundplay1_3.png"
            }
            else if(triggerCount%3 === 2){
                soundPlay.source = "qrc:/images/soundplay1_1.png"
            }

        }
    }



    Component.onCompleted: {
        var strHead = "<html>
                <head>
                    <style>
                        @font-face {
                            font-family: 'myfont1';
                            src: url('/usr/share/fonts/ttf/SourceHanSansSC-Bold.OTF'),
                            format('opentype');
                        }
                        @font-face {
                            font-family: 'myfont2';
                            src: url('/usr/share/fonts/ttf/SourceHanSansSC-Normal.OTF'),
                            format('opentype');
                        }
                    </style>
                </head>
                <body>"
        var strTaile = "</body>
                </html>"

        var strNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#818181'>";
        var strLast = "</span>";
        var strBoldFront = "<span style= 'font-family:myfont1;font-weight:700;color:#FFFFFFFF'>";
        var strBoldLast = "</span>";
        var strColorFront = "<span style= 'font-family:myfont1;font-weight:700;color:#12CFA7'>";
        var strColorLast = "</span>";
        var strText = "";
        var cfText = "";

        if(controlData["cf"] !== undefined){
            cfText = strColorFront + controlData["cf"] + strColorLast;
        }
        strText += cfText + " ";
        var strlabel = "";
        if(controlData["label"] !== undefined){
            strlabel = strNormalFront + "(<i>" + controlData["label"] + "</i>) " + strLast;
            strText += strlabel + " ";
        }
        var strEnText = "";
        if(controlData["content"] !== undefined){
            var contentObj = controlData["content"];

            if(contentObj["sent"] !== undefined){
                var sentObj = contentObj["sent"];

                var enArray = sentObj["en"];
                for(var i = 0;i < enArray.length;i++){
                    var enItem = enArray[i];
                    var strFront;
                    if(enItem["printType"] === "normal"){
                        strFront = strNormalFront;
                    }
                    else{
                        strFront = strBoldFront;
                    }
                    strEnText += strFront + enItem["data"] + strLast;
                }
                strText += strEnText;
                if(sentObj["ch"] !== undefined){
                    chText.visible = true;
                    chText.text = sentObj["ch"];
                }
                else{
                    chText.visible = false;
                }

                strText = strHead + strText + strTaile;
                enText.text = strText;
                if(contentObj["audio"] !== undefined){
                    soundPlay.visible = true;
                    var audioObj = contentObj["audio"];
                    soundPlay.audioName = audioObj["name"];
                }
            }

        }

    }

}
