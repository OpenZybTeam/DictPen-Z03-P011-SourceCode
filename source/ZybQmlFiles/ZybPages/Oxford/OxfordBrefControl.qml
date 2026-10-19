import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"
import "../../ZybControls"

Item {
    id:root
    height: top.height
    property var topData: null
    property var explainData: null
    property bool isExplainShow: false

    signal showMore();
    Column{
        id:top
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top
        Row{
            id:topRow
            spacing: 10
            Text {
                id: wordItem
                text: qsTr("wea.ther")
                color: "#FFFFFFFF"
                font.bold: true
                font.pixelSize: 28
                font.family: Style.engFontFamily
                font.styleName: "Medium"
            }

            Item{
                id: ox3000Item
                width: ox3000Image.width
                height: wordItem.height
                Image {
                    id: ox3000Image
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/oxford_key.png"
                }
            }


            Item{
                id: awItem
                width: awImage.width
                height: wordItem.height
                Image {
                    id: awImage
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/oxford_AW.png"
                }
            }

            Text{
                id:posItem
                text: qsTr("")
                color: "#FFFFFFFF"
                font.pixelSize: 28
                font.family: Style.engFontFamily
            }

            Text{
                id:phonItem
                width: top.width - (wordItem.visible ? wordItem.width : 0) - (posItem.visible ? (posItem.width + 10) : 0) - (awItem.visible ? (awItem.width + 10) : 0) - (ox3000Item.visible ? (ox3000Item.width + 10) : 0)
                text: qsTr("phone")
                color: "#FFFFFFFF"
                font.pixelSize: 28
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
            }
        }


        Item{
            width: parent.width
            height: 1
            visible: irregularItem.visible
        }

        Text {
            id: irregularItem
            width: parent.width
            font.pixelSize: 24
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            text: qsTr("text")
        }

        Item{
            visible: irregularItem.visible && explain.visible
            width: parent.width
            height: 10
        }


        Item {
            id: explain
            width: parent.width
            height: explainCol.height
            visible: isExplainShow
            Column{
                id:explainCol
                width:parent.width
            }


        }
    }

    Component{
        id:shcutComponent
        OxfordShortCutItem{
        }
    }

    Component{
        id:splitComponent
        Item{
        }
    }

    Component{
        id:defComponent

        Item{
            id:defItem
            height: defComItem.height + 10
            property var numText: 0
            property var defData: null
            property bool moreBtnVisible: true

            OxfordDefComponent{
                id:defComItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 20;
                anchors.top: parent.top
                controlData: defItem.defData
                headerText: defItem.numText
            }

//            Image {
//                id: wordBtn
//                anchors.left: parent.left
//                anchors.leftMargin: 50
//                anchors.top: defComItem.bottom
//                anchors.topMargin: 10
//                visible: moreBtnVisible
//                source: "qrc:/images/oxford_more.png"

//                MouseArea{
//                    height: parent.height + 10
//                    width: parent.width + 10
//                    anchors.centerIn: parent
//                    onClicked: {
//                        showMore();
//                    }
//                }
//            }
        }

    }

    Component{
        id:exampleComponent
        OxfordDefExComponent{
        }
    }

    Component{
        id:noteComponent
        OxfordNoteComponent{
        }
    }

    function setTopData(data){

        topData = data;
        wordItem.text = topData["word"]

        var top = topData["top"];
        if(topData["pos"] !== undefined){
            var posList = topData["pos"];
            if(posList.length > 1){
                posItem.visible = false;
            }
            else{
                var posObj = posList[0];
                posItem.visible = true;
                posItem.text = posObj["convert"];
            }
        }
        else{
            posItem.visible = false;
        }

        if(topData["ox3000"] !== undefined){
            var ox3000 = topData["ox3000"];
            if(ox3000 === true){
                ox3000Item.visible = true;
            }
            else{
                ox3000Item.visible = false;
            }
        }

        if(topData["academic"] !== undefined){
            var academic = topData["academic"];
            if(academic === true){
                awItem.visible = true;
            }
            else{
                awItem.visible = false;
            }
        }

        if(topData["phons"] !== undefined){
            updatePhones(topData["phons"]);
        }

    }

    property var explainCells: new Array
    function setExplainData(data){
//        console.log(JSON.stringify(data));
        irregularItem.visible = false;
        explainData =data;

        if(explainData["top"] !== undefined){
            var top = explainData["top"];
            if(top["irregular"] !== undefined){
                updateIrregular(top["irregular"]);
            }
            if(top["phons"] !== undefined){
                updatePhones(top["phons"]);
            }
        }

        if(!isExplainShow){
            return;
        }

        var cellCount = explainCells.length;
        for(var i = 0;i < cellCount;i++){
            explainCells.pop().destroy();
        }
        var defNum = 0;
        var sngCount = 0;
        if(explainData["sn_gs"] !== undefined){
            var sngs = explainData["sn_gs"];
            sngCount = sngs.length;
            var sng = sngs[0];
            if(sng["shcut"] !== undefined){
                var shcut = sng["shcut"];
                var strShcut = shcut["en"] + " " + shcut["ch"];
                explainCells.push(shcutComponent.createObject(explainCol,{width:explainCol.width - 82,controlData:strShcut}));
            }
            var exampleCount = 0;
            var explaiCount = 0;
            if(sng["explain"] !== undefined){
                var explains = sng["explain"];
                explaiCount = explains.length;
                var explainItem = explains[0];
                if(explainItem["examples"] !== undefined){
                    var examples = explainItem["examples"];
                    exampleCount = examples.length;
                }
                var hasDef = false;
                var defData = new Object;
                if(explainItem["def"] !== undefined){
                    defData["def"] = explainItem["def"]
                    hasDef = true;
                }

                if(explainItem["gram"] !== undefined){
                    defData["gram"] = explainItem["gram"];
                    hasDef = true;
                }

                if(explainItem["label"] !== undefined){
                    defData["label"] = explainItem["label"];
                    hasDef = true;
                }
                if(explainItem["cf"] !== undefined){
                    defData["cf"] = explainItem["cf"];
                    hasDef = true;
                }
                if(explainItem["use"] !== undefined){
                    defData["use"] = explainItem["use"];
                    hasDef = true;
                }
                if(explainItem["vgs"] !== undefined){
                    defData["vgs"] = explainItem["vgs"];
                    hasDef = true;
                }
                if(explainItem["disg"] !== undefined){
                    defData["disg"] = explainItem["disg"];
                    hasDef = true;
                }
                if(explainItem["pos"] !== undefined){
                    defData["pos"] = explainItem["pos"];
                    hasDef = true;
                }

                if(hasDef){
                    defNum = defNum + 1;
                    explainCells.push(splitComponent.createObject(explainCol,{width:explainCol.width,height:5}));
                    if(sngCount <= 1 && explaiCount <= 1 && exampleCount <=1){
                        explainCells.push(defComponent.createObject(explainCol,{width:explainCol.width,defData:defData,numText:defNum.toString(),moreBtnVisible:false}));
                    }
                    else{
                        explainCells.push(defComponent.createObject(explainCol,{width:explainCol.width,defData:defData,numText:defNum.toString(),moreBtnVisible:true}));
                    }
                }
                if(explainItem["examples"] !== undefined){
                    examples = explainItem["examples"];
                    var exampleObj = examples[0];
                    if(exampleObj["content"] !== undefined){
                        var contentObj = exampleObj["content"]
                        if(contentObj["sent"]){
                            var sentObj = contentObj["sent"];
                            if(sentObj["en"] !== undefined && sentObj["ch"] !== undefined){
                                explainCells.push(splitComponent.createObject(explainCol,{width:explainCol.width,height:5}));
                                explainCells.push(exampleComponent.createObject(explainCol,{width:explainCol.width - 82,controlData:examples[0]}));
                            }
                        }
                    }

                }

                if(explainItem["xrgs"] !== undefined){
                    var def = explainItem["def"];
                    var defXrgs = explainItem["xrgs"];
//                    console.log(JSON.stringify(defXrgs))
                    for(var q = 0;q < defXrgs.length;q++){
                        var xrgObj = defXrgs[q];
                        if(xrgObj["text"] !== ""){
                            explainCells.push(noteComponent.createObject(explainCol,{width:explainCol.width,controlData:defXrgs[q]}));
                        }
                    }
                }

            }
        }
    }

    function updatePhones(data){
        var phonList = data;
        var phoneText;
        var strHead = "<html>
                <head>
                    <style>
                        @font-face {
                            font-family: 'myfont1';
                            src: url('/usr/share/fonts/ttf/Inter-Medium.otf'),
                            format('opentype');
                        }
                        @font-face {
                            font-family: 'myfont2';
                            src: url('/usr/share/fonts/ttf/Inter-Normal.otf'),
                            format('opentype');
                        }
                    </style>
                </head>
                <body>"
        var strTaile = "</body>
                </html>"

        var strNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#FFCECECE'>";
        var strNprmalLast = "</span>";
        var strBoldFront = "<span style= 'font-family:myfont1;font-weight:700;color:#FFFFFFFF'>";
        var strBoldLast = "</span>";
        var strText = "";
//        var brPhoneList = new Array;
//        for(var k = 0;k <phonList.length;k++){
//            var phoneObj = phonList[k];
//            if(phoneObj["country_type"] === "br"){
//                brPhoneList.push(phoneObj)
//            }
//        }
        var noRepeatPhonList = new Array;
        for(var k = 0;k < phonList.length;k++){
            var isExist = false;
            var phoneObj = phonList[k];
            for(var nrPhonIndex = 0;nrPhonIndex < noRepeatPhonList.length;nrPhonIndex++){
                var nrPhonObj = noRepeatPhonList[nrPhonIndex];
                if(nrPhonObj["text"] === phoneObj["text"]){
                    isExist = true;
                }
            }
            if(!isExist){
                noRepeatPhonList.push(phoneObj);
            }
        }
        for(var j = 0;j < noRepeatPhonList.length;j++){
            var brPhoneObj = noRepeatPhonList[j];

            if(brPhoneObj["mark"] !== undefined){
                strText += strBoldFront + brPhoneObj["mark"] + " " + strBoldLast;
            }

            if(j === (noRepeatPhonList.length - 1)){
                strText += strNormalFront + brPhoneObj["text"] + strNprmalLast;
            }
            else{
                strText += strNormalFront + brPhoneObj["text"] + "; " + strNprmalLast;
            }
        }

        strText = strHead + "/" + strText + "/" + strTaile;
        phonItem.text = strText
    }

    function updateIrregular(data){
        irregularItem.visible = true;
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
        var strIrregularNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#FFCECECE'>";
        var strIrregularNprmalLast = "</span>";
        var strIrregularBoldFront = "<span style= 'font-family:myfont1;font-weight:700;color:#FFFFFFFF'>";
        var strIrregularBoldLast = "</span>";
        var strText = "";
        for(var i = 0;i < data.length;i++){
            var irregularObj = data[i];
            if(irregularObj["type"] === "word"){
                if(irregularObj["mark"] !== "null"){
                    strText += strIrregularNormalFront + "<i>" +irregularObj["mark"] + "</i> " + strIrregularNprmalLast;
                }
                strText += strIrregularBoldFront + irregularObj["word"] + strIrregularBoldLast;
                var strPhone = "";
                if(irregularObj["phons"] !== undefined){
                    var phoneList = irregularObj["phons"];
                    var brPhoneList = new Array;
                    for(var j = 0;j < phoneList.length;j++){
                        var phoneObj = phoneList[j];
                        if(phoneObj["country_type"] === "br"){
                            brPhoneList.push(phoneObj)
                        }
                    }
                    for(j = 0;j < brPhoneList.length;j++){
                        var brPhoneObj = brPhoneList[j];
                        if(brPhoneObj["mark"] !== undefined){
                            strPhone += strIrregularBoldFront + brPhoneObj["mark"] + " " + strIrregularBoldLast;
                        }

                        if(j === (brPhoneList.length - 1)){
                            strPhone += strIrregularNormalFront + brPhoneObj["text"] + strIrregularNprmalLast;
                        }
                        else{
                            strPhone += strIrregularNormalFront + brPhoneObj["text"] + "; " + strIrregularNprmalLast;
                        }
                    }
                    strPhone = strIrregularNormalFront + "/" + strPhone + "/" + strIrregularNprmalLast;
                    strText += strPhone;

                }
                if(i !== (data.length - 1)){
                    strText += strIrregularBoldFront + ", " + strIrregularBoldLast;
                }
            }
            else if(irregularObj["type"] === "link"){
                strText += strIrregularNormalFront + " " + irregularObj["text"]+ " " + strIrregularNormalFront;
            }

        }
        strText = strHead + strIrregularNormalFront +"( " + strIrregularNprmalLast + strText + strIrregularNormalFront + " )" + strIrregularNprmalLast + strTaile;

        irregularItem.text = strText;
    }
}
