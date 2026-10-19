import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../ZybControls/"
import "../../Funcs/UILogics.js" as UILogic
import "../../Style"
import "../../Global"
import "../"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: column.height
    property var controlData: new Array
    property string word: ""
    property var wordResViewPosion: 0
    signal more(var data)
    signal showTi(var word,var phrase,var strToken,var source)

    Column{
        id:column
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        width: parent.width

        Item {
            width: parent.width
            height: exampleTitle.height
            Text{
                id:exampleTitle
                color: "#FF12CFA7"
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: Style.scanresult_explain_fontSize
                text: qsTr("短语搭配")
            }

            Text{
                anchors.verticalCenter: exampleTitle.verticalCenter
                anchors.left: exampleTitle.right
                anchors.leftMargin: 10
                color: "#999999"
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: 24
                text: getGrade()
            }
        }


        Item{
            height: 10
            visible: exampleTitle.visible
            width: root.width
        }
        Column{
            id:phraseCol
            width: explainContent.width
            spacing: 10
        }

        Item{
            height: 10
            width: root.width
            visible: moreBtn.visible || packupBtn.visible
        }

        Rectangle{
            id: moreBtn
            width: 176
            height: 56
            radius: 28
            color: "#663C3D42"
            visible: false
            Row{
                height: moreText.height
                spacing: 0
                anchors.centerIn: parent
                Text {
                    id:moreText
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 28
                    color: "#FFFFFF"
                    text: qsTr("查看更多")
                }

                Image {
                    source: "qrc:/images/zybdict_more.png"
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_PHRASEMORE_CLICK);
                    root.wordResViewPosion = UILogic.getWordResViewPos();
                    moreEx();
                }
            }
        }

        Rectangle{
            id: packupBtn
            width: 120
            height: 56
            radius: 28
            color: "#663C3D42"
            visible: false
            Row{
                height: packupText.height
                spacing: 0
                anchors.centerIn: parent
                Text {
                    id:packupText
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 28
                    color: "#FFFFFF"
                    text: qsTr("收起")
                }

                Image {
                    source: "qrc:/images/pack_up.png"
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    packUp();
                    UILogic.setWordResViewPos(root.wordResViewPosion);
                }
            }
        }
    }

    Component{
        id:phraseComponent
        Item{
            id:phraseItem
            width: phraseCol.width
            height: comCol.height
            property string enStr: ""
            property string chStr: ""
            property string phraseText: ""
            property string phrase: ""
            property bool exVisible: false
            property bool tiVisible: false
            property var exArray: new Array
            property var tiInfo: new Object

            Column{
                id:comCol
                width: parent.width
                spacing: 0
                Text {
                    id: briefExplain
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: 28
                    textFormat: Text.RichText
                    text: phraseText
                }

                Item {
                    width: parent.width
                    height: 0
                    visible: exVisible
                }

                EnchExampleComponent {
                    id:excontent
                    width: parent.width
                    enText: phraseItem.enStr
                    chText: phraseItem.chStr
                    visible: exVisible
                }
                Item {
                    width: parent.width
                    height: 10
                    visible: tiVisible
                }
                Rectangle{
                    id:tiButton
                    height: 56
                    width: 160
                    radius: 28
                    color: "#FF12CFA7"
                    visible: tiVisible
                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 28
                        color: "#FFFFFFFF"
                        text: qsTr("真题练习")
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var tiList = tiInfo["tidList"];
                            var tiItem = tiList[0];
                            var token = tiItem["tidToken"];
                            var tid = tiItem["tid"];
                            if(dataManager.getLive() === false){
                                UILogic.showTip(qsTr("网络未连接，请连接网络后重试"));
                            }
                            else{
                                if(tiItem["title"] !== undefined){
                                    QueryWordManager.setCurZybDictTiSource(tiItem["title"])
                                }
                                var res = new Object;
                                res["phrase"] = phrase;
                                pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_TI_CLICKE,res);
                                apiNetWork.sendApiGetZybDictTi(root.word,phrase,token)
                            }
                        }
                    }
                }
            }






        }
    }

    property var exampleCells: new Array
    Component.onCompleted: {
        var data = controlData;
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
        var strBoldFront = "<span style= 'font-family:myfont1;font-weight:700;color:#FFFFFFFF'>";
        var strBoldLast = "</span>";

        var gradeMode = devManager.getSelDictGrade();
        for(var i = 0;i < 2 && i < data.length;i++){
            var phraseItem = data[i];
            var cell;
            var phraseText = strHead + strBoldFront + Number(i+1) + "." + phraseItem["phrases"] + strBoldLast + strSpace + strNormalFront + phraseItem["meaning"] + strNprmalLast + strTaile;
            if(phraseItem["sentence"] !== ""){
                if(phraseItem["tidInfo"] !== undefined){
                    cell = phraseComponent.createObject(phraseCol,{enStr:phraseItem["sentence"],chStr:phraseItem["chinese"],phraseText:phraseText,exVisible:true,tiVisible:true,tiInfo:phraseItem["tidInfo"],phrase:phraseItem["phrases"]});
                }
                else{
                    cell = phraseComponent.createObject(phraseCol,{enStr:phraseItem["sentence"],chStr:phraseItem["chinese"],phraseText:phraseText,exVisible:true,tiVisible:false,phrase:phraseItem["phrases"]});
                }

            }
            else{
                if(phraseItem["tidInfo"] !== undefined){
                    cell = phraseComponent.createObject(phraseCol,{phraseText:phraseText,exVisible:false,tiVisible:true,tiInfo:phraseItem["tidInfo"],phrase:phraseItem["phrases"]});
                }
                else{
                    cell = phraseComponent.createObject(phraseCol,{phraseText:phraseText,exVisible:false,tiVisible:false,phrase:phraseItem["phrases"]});
                }

            }
            exampleCells.push(cell);
        }

        if(data.length > 2){
            moreBtn.visible = true;
            packupBtn.visible = false;
        }
        else{
            moreBtn.visible = false;
            packupBtn.visible = false;
        }

    }

    function moreEx(){
        var data = controlData;
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
        var strBoldFront = "<span style= 'font-family:myfont1;font-weight:700;color:#FFFFFFFF'>";
        var strBoldLast = "</span>";
        for(var i = 2;i < data.length;i++){
            var phraseItem = data[i];
            var cell;
            var phraseText = strHead + strBoldFront + Number(i+1) + "." + phraseItem["phrases"] + strBoldLast + strSpace + strNormalFront + phraseItem["meaning"] + strNprmalLast + strTaile;
            if(phraseItem["sentence"] !== ""){
                if(phraseItem["tidInfo"] !== undefined){
                    cell = phraseComponent.createObject(phraseCol,{enStr:phraseItem["sentence"],chStr:phraseItem["chinese"],phraseText:phraseText,exVisible:true,tiVisible:true,tiInfo:phraseItem["tidInfo"],phrase:phraseItem["phrases"]});
                }
                else{
                    cell = phraseComponent.createObject(phraseCol,{enStr:phraseItem["sentence"],chStr:phraseItem["chinese"],phraseText:phraseText,exVisible:true,tiVisible:false,phrase:phraseItem["phrases"]});
                }

            }
            else{
                if(phraseItem["tidInfo"] !== undefined){
                    cell = phraseComponent.createObject(phraseCol,{phraseText:phraseText,exVisible:false,tiVisible:true,tiInfo:phraseItem["tidInfo"],phrase:phraseItem["phrases"]});
                }
                else{
                    cell = phraseComponent.createObject(phraseCol,{phraseText:phraseText,exVisible:false,tiVisible:false,phrase:phraseItem["phrases"]});
                }

            }
            exampleCells.push(cell)
        }
        moreBtn.visible = false;
        packupBtn.visible = true;
    }

    function packUp(){
        for(var i = exampleCells.length-1;i >= 2;i--){
            exampleCells.pop().destroy();
        }
        moreBtn.visible = true;
        packupBtn.visible = false;
    }

    function getGrade(){
        var gradeNum = devManager.getSelDictGrade();
        if(gradeNum === 0){
            return qsTr("（小学）")
        }
        else if(gradeNum === 1){
            return qsTr("（初中）")
        }
        else if(gradeNum === 2){
            return qsTr("（高中）")
        }
    }

}
