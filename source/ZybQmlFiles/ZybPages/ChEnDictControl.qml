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
    height: contentCol.height//explainContent.height + title.height + (chPhonetic.visible ? chPhonetic.height : 0) +32
    property var controlData: new Object;
    property bool isTitleViseble: true
    property var explainCells: new Array
    signal showDetailed(var data)

    Column{
        id:contentCol
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        width: parent.width
        Text{
            id:title
            visible: root.isTitleViseble
            color: "#FF12CFA7"
            font.pixelSize: 36
            font.family: Style.chFontFamily
            text: qsTr("汉英词典")
//            text: qsTr("“那”（nà）的口语音。参看“那”（nà）。")
        }
        Item{
            visible: root.isTitleViseble
            height: 10
            width: parent.width
        }
        Column{
            id:explainContent
            width: parent.width
            spacing: 15
        }

        Item{
            visible: trans.visible
            height: 15
            width: parent.width

        }

        Text {
            id: trans
            width: parent.width
            wrapMode: Text.WordWrap
            visible: false
            color: "#00B9F5"
            font.pixelSize: 28
            font.bold:true
            text: qsTr("text")
        }

        Item{
            visible: chPhonetic.visible
            height: 18
            width: parent.width

        }
        ZybSoundPlayButton{
            id:chPhonetic
            visible: false
            property var chWord: ""
            onClicked: {
                QueryWordManager.play(chWord,1);
            }
        }
    }

    Component{
        id:explainComponent
        Item{
            id:componentItem
            width: root.width
            height: wordContent.height + briefExplain.height
            property var itemData: new Object
            property alias wordText: word.text
            property alias briefExplainText: briefExplain.text
            Item {
                id: wordContent
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width
                height: word.height
                Text{
                    id:word
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#00B9F5"
                    font.pixelSize: 28
                    font.bold:true
                    wrapMode: Text.WordWrap
                    font.family: Style.engFontFamily
//                    font.styleName: "Medium"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
//                            console.log("enchControl clicked");
                            ScanViewLogic.setIsGotoEnchPage(true);
                            QueryWordManager.queryEnglish(componentItem.itemData["word"]);
                        }
                    }
                    Component.onCompleted: {
//                        console.log("parent.width:",parent.width,contentWidth);
                        if(contentWidth < parent.width - 150){
                            width = contentWidth;
                        }
                        else{
                            width = parent.width - 150;
                        }
                    }
                }

                Image {
                    id: contentImage
                    anchors.left: word.right
                    anchors.leftMargin: 16
                    anchors.top: wordContent.top
//                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/soundplay1_1.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(soundPlayConnect.enabled === false){
                                QueryWordManager.playStop();
                                soundPlayConnect.enabled = true;
                                QueryWordManager.play(word.text,2);
                                timer.triggerCount = 0;
                                timer.running = true;
                            }
                            else{
                                soundPlayConnect.enabled = false;
                                timer.running = false;
                                contentImage.source = "qrc:/images/soundplay1_1.png"
                                QueryWordManager.playStop();
                            }
                        }
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
                            contentImage.source = "qrc:/images/soundplay1_2.png"
                        }
                        else if(triggerCount%3 === 1){
                            contentImage.source = "qrc:/images/soundplay1_3.png"
                        }
                        else if(triggerCount%3 === 2){
                            contentImage.source = "qrc:/images/soundplay1_1.png"
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
                        contentImage.source = "qrc:/images/soundplay1_1.png"
                    }
                }

            }

            Text{
                id:briefExplain
                width: parent.width
                anchors.top: wordContent.bottom
//                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 0
                elide: Text.ElideRight
                color: "#FFCECECE"
                font.pixelSize: 28
                font.family: Style.chFontFamily
                font.styleName: "Normal"
            }



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
            if(root.visible)
                chPhonetic.play();
        }
    }

    property bool isTransRes: false
    Component.onCompleted: {
        var data = controlData;
        if(isTransRes){
            explainContent.visible = false
            trans.visible = true;

            if(data["trans"] !== undefined){
                trans.text = data["trans"];
            }
        }
        else{
            if(data["explains"] !== undefined){
                trans.visible = false;
                explainContent.visible = true;
                var explains = data["explains"];
    //            console.log("Chen setData+++====3:",explains.length)
                for(var i = 0;i < explains.length;i++){
                    var strWord,strExplain;
                    var explainItem = explains[i];
                    if(explainItem["word"] !== undefined && explainItem["explain"] !== undefined){
    //                    console.log("word:",explainItem["word"])
    //                    console.log("explain:",explainItem["explain"])
                        strWord = explainItem["word"];
                        strExplain = explainItem["explain"];
                        var cell = explainComponent.createObject(explainContent,{wordText: strWord,briefExplainText:strExplain,itemData:explainItem})
                        explainCells.push(cell);
                    }
                }
            }
        }


        if(data["chword"] !== undefined){
            var item = data["chword"];
            chPhonetic.chWord = item["word"];
            chPhonetic.text = item["phonetic"];
            chPhonetic.visible = true;
            console.log("setData :",devManager.getAutoSpeak())
            if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak())
            {
                autospeakTimer.running = true;
            }

        }
        else{
            chPhonetic.visible = false;
        }
    }

    Component.onDestruction: {
        var cell;
        var cellCount = explainCells.length;
        for(var i = 0;i < cellCount;i++){
            cell = explainCells.pop();
            cell.destroy();
        }
    }
}
