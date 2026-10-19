import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"

Item {
    id:root
    height: contentText.height + column.height
    property var controlData: null
    property string headerText: ""

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
            color: "#FFFFFFFF"
            text: headerText
        }
    }

    Text {
        id: contentText
        anchors.top: parent.top
        anchors.left: headItem.right
        anchors.leftMargin: 29
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        font.family: Style.chFontFamily
        lineHeight: 0.7
        lineHeightMode: Text.ProportionalHeight
        //lineHeightMode: Text.FixedHeight
        font.pixelSize: 28
    }

    Column{
        id:column
        width: parent.width
        anchors.left: parent.left
        anchors.top: contentText.bottom
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

        var strNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#CBCBCB'>";
        var strNormalFront2 = "<span style= 'font-family:myfont2;font-weight:200;color:#CBCBCB'>";
        var strLast = "</span>";
        var strBoldFront = "<span style= 'font-family:myfont1;font-weight:200;color:#FFFFFFFF'>";
        var strBoldLast = "</span>";
        var strColorFront = "<span style= 'font-family:myfont1;font-weight:700;color:#12CFA7'>";
        var strColorLast = "</span>";
        var strText = "";
        if(controlData["def"] !== undefined)
        {
            var def = controlData["def"];
            if(def["en"] !== undefined){
                var enArray = def["en"];
                for(var i = 0;i < enArray.length;i++){
                    var enItem = enArray[i];
                    var strFront;
                    if(enItem["printType"] === "normal"){
                        strFront = strNormalFront;
                    }
                    else{
                        strFront = strNormalFront;
                    }
                    strText += strFront + enItem["text"] + strLast;
                }
                strText += strNormalFront2 + "  " + def["ch"] + strLast;
            }



            if(def["xrgs"] !== undefined){
                var defXrgs = def["xrgs"];
//                console.log(JSON.stringify(defXrgs))
                for(var q = 0;q < defXrgs.length;q++){
                    var xrgObj = defXrgs[q];
                    if(xrgObj["text"] !== "" && xrgObj["mark"] !== "null"){
                        explainCells.push(noteComponent.createObject(column,{width:column.width,controlData:defXrgs[q]}));
                    }
                }
            }
        }

        var strGram = "";
        if(controlData["gram"] !== undefined){
            var gram = controlData["gram"];
            for(var k = 0;k < gram.length;k++){
                if(k === gram.length - 1){
                    strGram += gram[k];
                }
                else{
                    strGram += gram[k] + ",";
                }
            }
            strGram = "[" + strGram + "] ";
            strGram = strBoldFront + strGram + strLast;

        }
        var strlabel = "";
        if(controlData["label"] !== undefined){
            strlabel = strNormalFront2 + "(<i>" + controlData["label"] + "</i>) " + strLast;
        }

        var strCf = ""
        if(controlData["cf"] !== undefined){
            strCf = strColorFront + controlData["cf"] + " " + strColorLast;
        }

        var strUse = ""
//        console.log(JSON.stringify(controlData));
        if(controlData["use"] !== undefined){
            var useObj = controlData["use"];
            if(useObj["en"] !== undefined ){
                strUse = strUse + useObj["en"];
            }
            if(useObj["ch"] !== undefined ){
                strUse = strUse + " " + useObj["ch"];
            }
            strUse = strNormalFront + "(" + strUse + ") " + strLast;
//                    console.log(strUse)
        }

        var strVgs = ""
        if(controlData["vgs"] !== undefined){
            var vgsObj = controlData["vgs"];
            var strVgsMark = "null"
            if(vgsObj["mark"] !== undefined ){
                strVgsMark = vgsObj["mark"];
            }
            if(vgsObj["data"] !== undefined ){
                if(strVgsMark === "null"){
                    strVgs = strColorFront + vgsObj["data"] + " " + strColorLast;
                }
                else{
                    if(strVgsMark === "also"){
                        strVgs = strNormalFront + "(" + vgsObj["data"] + ") " + strLast;
                    }
                    else{
                        strVgs = strNormalFront + "(" + strVgsMark + " " + vgsObj["data"] + ") " + strLast;
                    }
                }

            }
        }

        var strDisg = "";
        if(controlData["disg"] !== undefined){
            var disgObj = controlData["disg"];
            if(disgObj["en"] !== undefined ){
                strDisg = strDisg + disgObj["en"];
            }
            if(disgObj["ch"] !== undefined ){
                strDisg = strDisg + " " + disgObj["ch"];
            }
            strDisg = strNormalFront + "(" + strDisg + ") " + strLast;
        }

        var strPos = "";
        if(controlData["pos"] !== undefined){
            var posArray = controlData["pos"];
            for(var posIndex = 0;posIndex < posArray.length;posIndex++){
                var posObj = posArray[posIndex];
                if(posIndex === posArray.length - 1){
                    strPos += posObj["convert"];
                }
                else{
                    strPos += posObj["convert"] + ",";
                }
            }
            strPos = strNormalFront + strPos + " " + strLast;
        }

        strText = strHead+ strVgs + strGram + strPos + strCf + strUse + strlabel + strDisg + strText + strTaile;
        contentText.text = strText;

    }

    Component.onDestruction: {
        var cellCount = explainCells.length;
        for(var i = 0;i < cellCount;i++){
            explainCells.pop().destroy();
        }
    }

}
