import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import "../Global"
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: explainContent.height
    property var controlData: new Object;
    property bool isTitleViseble: true
    property var exampleCells: new Array

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
            text: qsTr("汉语词典")
        }
        Item{
            visible: root.isTitleViseble
            height: 10
            width: parent.width
        }

        MultiPhoneticList{
            id:phoneticList
            width:explainContent.width
            onCurrentIndex_Changed: {
                root.updateExamples(index);
            }
        }

        Item {
            visible: wordStruct.visible
            width: explainContent.width
            height: 16
        }

        Item{
            id:wordStruct
            width: parent.width
            height: structText.height
            Text {
                id: structText
                font.family: Style.chFontFamily
                textFormat: Text.RichText
                font.pixelSize: 28
                color: "white"
            }
            Image {
                id: mh
                anchors.verticalCenter: structText.verticalCenter
                anchors.left: structText.right
                anchors.leftMargin: 24
                source: "qrc:/images/mhbtn.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        ScanViewLogic.goToMiaoHongPage();
                    }
                }
            }
        }


        Item {
            visible: exampleContent.visible
            width: explainContent.width
            height: 10
        }

        Item{
            id:exampleContent
            width: parent.width
            height: exampleList.height
            Column{
                id:exampleList
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left

            }
        }

        Item {
            visible: exampleContent.visible
            width: explainContent.width
            height: 10
        }

        Item{
            id:similarContent
            width: parent.width
            height: similarTitle.height + 10 + similarText.height
            Text {
                id: similarTitle
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width
                color: "#FF12CFA7"
                font.pixelSize: 28
                text: qsTr("近义词")
            }

            Text {
                id: similarText
                anchors.left: parent.left
                anchors.top: similarTitle.bottom
                anchors.topMargin: 15
                width: parent.width
                wrapMode: Text.WrapAnywhere
                lineHeight:1.5
                color: "#FFFFFFFF"
                font.pixelSize: 28
                font.family: Style.chFontFamily
            }
        }

        Item {
            visible: antonymContent.visible
            width: explainContent.width
            height: 10
        }

        Item{
            id:antonymContent
            width: parent.width
            height: antonymTitle.height + 10 + antonymText.height
            Text {
                id: antonymTitle
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width
                color: "#FF12CFA7"
                font.pixelSize: 28
                text: qsTr("反义词")
            }

            Text {
                id: antonymText
                anchors.left: parent.left
                anchors.top: antonymTitle.bottom
                anchors.topMargin: 15
                width: parent.width
                wrapMode: Text.WrapAnywhere
                lineHeight:1.5
                color: "#FFFFFFFF"
                font.pixelSize: 28
                font.family: Style.chFontFamily
            }
        }

        Item {
            visible: singlePhonetic.visible
            width: explainContent.width
            height: 23
        }

        ZybSoundPlayButton{
            id:singlePhonetic
            visible: false
            onClicked: {
//                QueryWordManager.play(controlData["word"],1);
                QueryWordManager.playPolyphonicCharacter(controlData["word"],text)
            }
        }

    }

    Component{
        id:examplComponent
        Text {
            width: root.width
            font.pixelSize: 28
            font.family: Style.chFontFamily
            color: "white"
            wrapMode: Text.WrapAnywhere
            textFormat: Text.RichText
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
            singlePhonetic.play();
        }
    }

    property bool phoneticVisible: true
    Component.onCompleted: {
        var data = controlData;
        //        briefExplText = briefExplText + "<font color=\"#FF999999\">" + explainItem["partspeech"] + "&nbsp;</font>";
                if(data["miaohong_result"] !== undefined){
                    wordStruct.visible = true;
                    var strEx;
                    var mhObj = data["miaohong_result"];

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
                    var strNormalFront = "<span style= 'font-family:myfont2;color:#FFCECECE'>";
                    var strNprmalLast = "</span>";
                    var strBoldFront = "<span style= 'font-family:myfont1;font-weight:550;color:#FFFFFFFF'>";
                    var strBoldLast = "</span>";

                    if(mhObj["radical"] !== undefined ){
                        strEx = strNormalFront + qsTr("部首：") + strNprmalLast + strBoldFront + mhObj["radical"] + strBoldLast + strSpace;
        //                strEx = "<span style=\"font-family: Source Han Sans SC;font-style:Normal;color:#FFCECECE\">" + qsTr("部首：") + "</span>" + "<span style=\"font-family: Source Han Sans SC;font-style:Bold;color:#FFCECECE\">" + mhObj["radical"] + "</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                    }

                    if(mhObj["strokenum"] !== undefined ){
                        strEx = strEx + strNormalFront + qsTr("笔画：") + strNprmalLast + strBoldFront + mhObj["strokenum"] + strBoldLast + strSpace;
                    }

                    if(mhObj["structure"] !== undefined ){
                        strEx = strEx + strNormalFront + qsTr("结构：") + strNprmalLast + strBoldFront + mhObj["structure"] + strBoldLast;
                    }

                    structText.text = strHead + strEx + strTaile;
                }
                else{
                    wordStruct.visible = false;
                }
                var cell;
                var cellCount = exampleCells.length;
                for(var i = 0;i < cellCount;i++){
                    cell = exampleCells.pop();
                    cell.destroy();
                }

                if(data["explains"] !== undefined){
                    var explains = data["explains"];
                    if(explains.length > 1){
                        phoneticList.visible = true;
                        singlePhonetic.visible = false;
                        phoneticList.setData(explains,data["word"])
                    }
                    else{
                        phoneticList.visible = false;
                        singlePhonetic.visible = phoneticVisible;
                        var explainItem = explains[0];
                        if(phoneticVisible){
                            if(explainItem["phonetic"] !== undefined){
                                singlePhonetic.text = explainItem["phonetic"];
                            }
                        }

                        if(explainItem["explains"] !== undefined){
                            exampleContent.visible = true;
                            var examples = explainItem["explains"];
                            if(examples.length === 1){
                                var example = examples[0];
                                cell = examplComponent.createObject(exampleList,{text: example})
                                exampleCells.push(cell);
                            }
                            else{
                                for(var j = 0;j < examples.length;j++){
                                    example = examples[j];
                                    cell = examplComponent.createObject(exampleList,{text: (j+1).toString() + "." + example})
                                    exampleCells.push(cell);
                                }
                            }
        //                    for(j = 0;j < examples.length;j++){
        //                        example = examples[j];
        //                        cell = examplComponent.createObject(exampleList,{text: (j+1).toString() + "." + example})
        //                        exampleCells.push(cell);
        //                    }
                        }
                        else{
                            exampleContent.visible = false;
                        }
                        if(phoneticVisible){
                            if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
        //                        singlePhonetic.play();
                                autospeakTimer.running = true;
                            }
                        }
                    }

        //            console.log("data:",JSON.stringify(data))
                    if(data["similar"] !== undefined){
                        similarText.text = data["similar"];
                        similarContent.visible = true;
                    }
                    else{
                        similarContent.visible = false;
                    }

                    if(data["antony"] !== undefined){
                        antonymText.text = data["antony"];
                        antonymContent.visible = true;
                    }
                    else{
                        antonymContent.visible = false;
                    }

                }

    }


    function updateExamples(index){
        var explains = controlData["explains"];
        var explainItem = explains[index];
        if(explainItem["explains"] !== undefined){
            exampleContent.visible = true;
            var cellCount = exampleCells.length;
            for(var i = 0;i < cellCount;i++){
                var cell = exampleCells.pop();
                cell.destroy();
            }
            var examples = explainItem["explains"];

            for(var j = 0;j < examples.length;j++){
                var example = examples[j];
                cell = examplComponent.createObject(exampleList,{text: (j+1).toString() + "." + example})
                exampleCells.push(cell);
            }
        }
        else{
            exampleContent.visible = false;
        }
    }
}
