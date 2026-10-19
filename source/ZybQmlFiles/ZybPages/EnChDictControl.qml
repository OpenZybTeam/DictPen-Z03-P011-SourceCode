import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../Global"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: explainContent.height
    property var controlData: new Object;
    property bool isTitleViseble: false
    property var exampleCells: new Array
    property var wordText: ""
    property var transText: ""
    property bool isAutoPlay: false

    Column{
        id:explainContent
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        width: parent.width
        Text{
            id:title
            visible: root.isTitleViseble
            color: "#FF12CFA7"
            font.pixelSize: 36
            text: qsTr("简明词典")
        }
        Item{
            visible: root.isTitleViseble
            height: 10
            width: parent.width
        }

        Text {
            id: briefExplain
            width: root.width
            wrapMode: Text.WordWrap
            font.pixelSize: 28
            textFormat: Text.RichText
            text: ""
        }

        Item {
            id: transItem
            visible: false
            height: 56
            width: explainContent.width
            ZybSoundPlayButton{
                id:orgPlay
                anchors.top: parent.top
                anchors.left: parent.left
                text: qsTr("原文")
                onClicked: {
                    if(!isAutoPlay){
                        var valueObj = new Object;
                        valueObj["wordType"] = "en"
                        pingManager.addPingData(PingDefine.PING_EVENT_DICT_SRC_SPEECH,valueObj);
                    }
                    isAutoPlay = false;
                    QueryWordManager.play(root.wordText,2,4);
                }
            }
            ZybSoundPlayButton{
                id:transPlay
                anchors.left: orgPlay.right
                anchors.leftMargin: 22
                anchors.top: parent.top
                text: qsTr("译文")
                onClicked: {
                    if(!isAutoPlay){
                        var valueObj = new Object;
                        valueObj["wordType"] = "ch"
                        pingManager.addPingData(PingDefine.PING_EVENT_DICT_TRANS_SPEECH,valueObj);
                    }
                    isAutoPlay = false;
                    QueryWordManager.play(root.transText,1);
                }
            }
        }

        Item{
            height: 10
            visible: exampleTitle.visible
            width: root.width
        }

        Text{
            id:exampleTitle
            color: "#FF12CFA7"
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            font.pixelSize: Style.scanresult_explain_fontSize
            text: qsTr("双语例句")
        }

        Item{
            height: 10
            visible: exampleTitle.visible
            width: root.width
        }
        Column{
            id:exampleContent
            width: explainContent.width
        }

    }

    Component{
        id:exampleComponent
        EnchExampleComponent {
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
                if(devStateMonitor.getDevState() === DevStatus.DevState_OffScreen){
                    return;
                }
                if(!root.visible)
                    return;
                isAutoPlay = true;
                orgPlay.play();
            }
        }

    Component.onCompleted: {
        isAutoPlay = false;
        var data = controlData;
        var cell;
        var cellCount = exampleCells.length;
        for(var i = 0;i < cellCount;i++){
            cell = exampleCells.pop();
            cell.destroy();
        }

        if(data["explains"] !== undefined){
            var explains = data["explains"];
            var briefExplText = "";
            root.transText = "";

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

            var strSpace = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            var strNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#FFCECECE'>";
            var strNprmalLast = "</span>";
            var strBoldFront = "<span style= 'font-family:myfont1;font-weight:550;color:#FFFFFFFF'>";
            var strBoldLast = "</span>";

            for(i = 0;i < explains.length;i++){
                var partSpeech,explain;
                var explainItem = explains[i];
                if(i === (explains.length - 1)){
                    if(explainItem["partspeech"] !== undefined ){
                        root.transText = root.transText + explainItem["partspeech"];
                        briefExplText = briefExplText + strNormalFront + explainItem["partspeech"] + "&nbsp;" + strNprmalLast;
                    }
                    if(explainItem["explain"] !== undefined){
                        root.transText = root.transText + explainItem["explain"];
                        briefExplText = briefExplText + strBoldFront + explainItem["explain"] + " " + strBoldLast ;
                    }
                }
                else{
                    if(explainItem["partspeech"] !== undefined ){
                        root.transText = root.transText + explainItem["partspeech"];
                        briefExplText = briefExplText + strNormalFront + explainItem["partspeech"] + "&nbsp;" + strNprmalLast;
                    }
                    if(explainItem["explain"] !== undefined){
                        root.transText = root.transText + explainItem["explain"];
                        briefExplText = briefExplText + strBoldFront + explainItem["explain"]  + " "+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + strBoldLast ;
                    }
                }

            }

            if(data["isdeformation"] === true){
                briefExplText = briefExplText + strNormalFront + "&nbsp;&nbsp;&nbsp;&nbsp;" + qsTr("原形(") + data["originword"] + qsTr(")") + strNprmalLast;
//                briefExplText = briefExplText + strBoldFront + "&nbsp;&nbsp;&nbsp;&nbsp" + qsTr("原形(") + data["originword"] + qsTr(")") + strBoldLast;
            }
            briefExplain.text = strHead + briefExplText + strTaile;
        }

        if(controlData["phonetic"] !== undefined){
            transItem.visible = false;
        }
        else{
            transItem.visible = true;
            if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
                autospeakTimer.running = true;
            }
        }


        if(data["examples"] !== undefined){
            var examplsArray = data["examples"];
            if(examplsArray.length < 1){
                exampleTitle.visible = false;
            }
            else{
                for(i = 0;i < 1/*examplsArray.length*/;i++){
                    var exampleItem = examplsArray[i];

                    var enContent = exampleItem["eng"];
                    var chContent = exampleItem["ch"];
                    cell = exampleComponent.createObject(exampleContent,{enText:enContent,chText:chContent})
                    exampleCells.push(cell);
                }
                exampleTitle.visible = true;
            }

        }
        else{
            exampleTitle.visible = false;
        }
    }
}
