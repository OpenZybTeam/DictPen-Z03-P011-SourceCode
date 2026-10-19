import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"
import "../../ZybControls"

Rectangle{
    id:root
    color: Style.mainbgColor
    height: column.height
    property var controlData: new Object
    property var idmNum: 0

    Column {
        id:column
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top
    }

    Component{
        id:topComponent
        Item {
            height: contentText.height
            property var controlData: null
            property var headerText: ""

            Item {
                id: headItem
                height: 23
                width: 23
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.left: parent.left
                Text {
                    id: headNum
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: Style.engFontFamily
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FFFFFFFF"
                    text: headerText
                }
            }

            Text {
                id: contentText
                anchors.top: parent.top
                anchors.left: headItem.right
                anchors.leftMargin: 29
                width: parent.width
                anchors.right: parent.right
                font.pixelSize: 28
                textFormat: Text.RichText
//                lineHeight: 2
//                lineHeightMode: Text.ProportionalHeight
                color: "#CECECE"
                text: qsTr("text")
            }

            Component.onCompleted: {
                contentText.text = controlData;
            }
        }
//        Item {
//            height: contentText.height
//            property var controlData: ""

//            Text {
//                id: contentText
//                anchors.top: parent.top
//                anchors.left: parent.left
//                width: parent.width
//                color: "#FFFFFFFF"
//                font.pixelSize: 28
//                textFormat: Text.RichText
//            }

//            Component.onCompleted: {
//                contentText.text = controlData;
//            }
//        }
    }

    Component{
        id:splitComponent
        Item{
        }
    }

    Component{
        id:defComponent
        OxfordDefComponent{
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

    property var explainCells: new Array

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

        var strNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#FFCECECE'>";
        var strNprmalLast = "</span>";
        var strBoldFront = "<span style= 'font-family:myfont1;font-weight:700;color:#FFFFFFFF'>";
        var strBoldLast = "</span>";
        var strColorFront = "<span style= 'font-family:myfont1;font-weight:200;color:#12CFA7'>";
        var strColorLast = "</span>";

        var idmItem = controlData;
        if(idmItem["top"] !== undefined){
            var idmtop = idmItem["top"];
            var idmWord = strColorFront + idmtop["word"] + strColorLast;
            var top_top = idmtop["top"]
            var strTop = "";
            var wordPos = ""
            if(top_top["pos"]){
                var idmPosArray = top_top["pos"];
                var posStr = "";

                for(var posIndex = 0;posIndex < idmPosArray.length;posIndex++){
                    var posObj = idmPosArray[posIndex];
                    if(posIndex === idmPosArray.length - 1){
                        posStr += posObj["convert"];
                    }
                    else{
                        posStr += posObj["convert"] + ",";
                    }
                }
                wordPos = strNormalFront + posStr + strNprmalLast;
            }
            var strPhone = "";
            if(top_top["phons"]){
                var idmPhonArray = top_top["phons"];
                var brPhoneList = new Array;
                for(var h = 0;h <idmPhonArray.length;h++){
                    var phoneObj = idmPhonArray[h];
                    if(phoneObj["country_type"] === "br"){
                        brPhoneList.push(phoneObj)
                    }
                }

                for(h = 0;h < brPhoneList.length;h++){
                    var brPhoneObj = brPhoneList[h];
                    if(brPhoneObj["mark"] !== undefined){
                        strPhone += strBoldFront + brPhoneObj["mark"] + " " + strBoldLast;
                    }

                    if(h === (brPhoneList.length - 1)){
                        strPhone += strNormalFront + brPhoneObj["text"] + strNprmalLast;
                    }
                    else{
                        strPhone += strNormalFront + brPhoneObj["text"] + "; " + strNprmalLast;
                    }
                }

                strPhone = "/" + strPhone + "/";

            }
            var topText = "";
            topText = strHead  + idmWord + "   " + wordPos + "   "  + strPhone + strTaile;
//            console.log(topText);
            explainCells.push(topComponent.createObject(column,{width:column.width,controlData:topText,headerText:idmNum.toString()}));
            explainCells.push(splitComponent.createObject(column,{width:column.width,height:5}));
        }



        if(idmItem["sn_gs"] !== undefined){
            var sngs = idmItem["sn_gs"];
            for(var k = 0;k < sngs.length;k++){
                var sng = sngs[k];
                if(sng["explain"] !== undefined){
                    var explains = sng["explain"];
                    for(var i = 0;i < explains.length;i++){
                        var explainItem = explains[i];
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
                            explainCells.push(splitComponent.createObject(column,{width:column.width,height:15}));
                            explainCells.push(defComponent.createObject(column,{width:column.width,controlData:defData}));
                            explainCells.push(splitComponent.createObject(column,{width:column.width,height:5}));
                        }

                        if(explainItem["examples"] !== undefined){
                            var examples = explainItem["examples"];
                            for(var j = 0;j < examples.length;j++){
                                var exampleItem = examples[j];
                                var contentObj = exampleItem["content"];
                                if(contentObj["sent"] !== undefined){
                                    var sentObj = contentObj["sent"];
                                    if(sentObj["en"] !== undefined && sentObj["ch"] !== undefined){
                                        explainCells.push(exampleComponent.createObject(column,{width:column.width,controlData:examples[j]}));
                                        explainCells.push(splitComponent.createObject(column,{width:column.width,height:10}));
                                    }
                                }

                            }
                        }
                        if(explainItem["xrgs"] !== undefined ){
                            var sngXrgs = explainItem["xrgs"];
//                            console.log(JSON.stringify(sngXrgs))
                            for(var q = 0;q < sngXrgs.length;q++){
                                var xrgObj = sngXrgs[q];
                                if(xrgObj["text"] !== "" && xrgObj["mark"] !== "null"){
                                    explainCells.push(noteComponent.createObject(column,{width:column.width,controlData:sngXrgs[q]}));
                                }
                            }
                        }
                    }

                }

                if(sng["xrgs"] !== undefined){
                    var sngsXrgs = sng["xrgs"];
                    for(q = 0;q < sngsXrgs.length;q++){
                        xrgObj = sngsXrgs[q];
                        if(xrgObj["text"] !== "" && xrgObj["mark"] !== "null"){
                            explainCells.push(noteComponent.createObject(column,{width:column.width,controlData:xrgObj}));
                        }
                    }
                }
            }
        }

    }

    Component.onDestruction: {
        var cellCount = explainCells.length;
        for(var i = 0;i < cellCount;i++){
            explainCells.pop().destroy();
        }
    }
}


