import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../ZybControls/"
import "../../Funcs/UILogics.js" as UILogic
import "../../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../../Style"
import "../../Global"
import "../Oxford"
import com.zyb.PingDefine 1.0
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

        Item {
            width: parent.width
            height: relationTitle.height
            Text{
                id:relationTitle
                color: "#FF12CFA7"
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: Style.scanresult_explain_fontSize
                text: qsTr("相关词汇")
            }

            Text{
                anchors.verticalCenter: relationTitle.verticalCenter
                anchors.left: relationTitle.right
                anchors.leftMargin: 10
                color: "#999999"
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: 24
                text: getGrade()
                visible: false
            }
        }

        Item{
            height: 24
            visible: relationTitle.visible
            width: root.width
        }

        ZybEnchDictRelWordList{
            id:relationsList
            width:explainContent.width
            onCurrentIndex_Changed: {
                updateDetail(subentryData);
            }
        }

        Item {
            visible: relationsList.visible
            width: explainContent.width
            height: 10
        }

        Column{
            id:detailCol
            width: explainContent.width
            spacing: 10
        }
    }

    Component{
        id:detailComponent
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: 28
            textFormat: Text.RichText
        }
    }


    property var detailCells: new Array
    Component.onCompleted: {
        var data = controlData;
//        var array1 = new Array; //派生词
//        var array2 = new Array; //近义词
//        var array3 = new Array; //反义词
//        var array4 = new Array; //同形异义词
//        var array5 = new Array; //衍生词
//        var array6 = new Array; //易混词
//        var array7 = new Array; //同根词
//        var array8 = new Array; //同义词辨析
//        var array9 = new Array; //短语辨析
//        for(var i = 0;i < data.length;i++){
//            var relItem = data[i];
//            if(relItem["type"] === "1"){
//                array1.push(relItem);
//            }
//            if(relItem["type"] === "2"){
//                array2.push(relItem);
//            }
//            else if(relItem["type"] === "3"){
//                array3.push(relItem);
//            }
////            else if(relItem["type"] === "4"){
//                array4.push(relItem);
//            }
//            else if(relItem["type"] === "5"){
//                array5.push(relItem);
//            }
//            else if(relItem["type"] === "6"){
//                array6.push(relItem);
//            }
//            else if(relItem["type"] === "7"){
//                array7.push(relItem);
//            }
//            else if(relItem["type"] === "8"){
//                array8.push(relItem);
//            }
//            else if(relItem["type"] === "9"){
//                array9.push(relItem);
//            }
//        }

//        var listData = new Array;
//            if(array1.length > 0){
//                var listItem = {"type":qsTr("派生词")}
//                listItem["words"] = array1
//                listData.push(listItem);
//            }
//        if(array2.length > 0){
//            var listItem = {"type":qsTr("近义词")}
//            listItem["words"] = array2
//            listData.push(listItem);
//        }
//        if(array3.length > 0){
//            listItem = {"type":qsTr("反义词")}
//            listItem["words"] = array3
//            listData.push(listItem);
//        }
//            if(array4.length > 0){
//                listItem = {"type":qsTr("同形异义词")}
//                listItem["words"] = array4
//                listData.push(listItem);
//            }
//            if(array5.length > 0){
//                listItem = {"type":qsTr("衍生词")}
//                listItem["words"] = array5
//                listData.push(listItem);
//            }
//            if(array6.length > 0){
//                listItem = {"type":qsTr("易混词")}
//                listItem["words"] = array6
//                listData.push(listItem);
//            }
//        if(array7.length > 0){
//            listItem = {"type":qsTr("同根词")}
//            listItem["words"] = array7
//            listData.push(listItem);
//        }
//            if(array8.length > 0){
//                listItem = {"type":qsTr("同义词辨析")}
//                listItem["words"] = array8
//                listData.push(listItem);
//            }
//            if(array9.length > 0){
//                listItem = {"type":qsTr("短语辨析")}
//                listItem["words"] = array9
//                listData.push(listItem);
//            }
//        console.log(JSON.stringify(data))
        relationsList.setData(data);
    }

    function updateDetail(data){
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

        var cellCount = detailCells.length;
        for(var i = 0;i < cellCount;i++){
            detailCells.pop().destroy();
        }
        var words = data["words"];
        for(i = 0;i < words.length;i++){
            var wordItem = words[i];
            var wordlist = wordItem["word"];
            var wordStr = ""
//            console.log("+++++++++++++++++++++",typeof wordlist,JSON.stringify(words))
            if(typeof wordlist === "string"){
                wordStr = wordlist;
            }
            else{
                for(var j = 0;j < wordlist.length;j++){
                    if(j === wordlist.length-1){
                        wordStr += wordlist[j];
                    }
                    else{
                        wordStr += wordlist[j] + "/";
                    }
                }
            }

            var briefStr = strHead + strBoldFront + wordStr + strBoldLast + "&nbsp;&nbsp;" + strNormalFront + wordItem["wordtype"] + "&nbsp;&nbsp;" + wordItem["meaning"] + strNprmalLast + strTaile;
            detailCells.push(detailComponent.createObject(detailCol,{text:briefStr}));
        }
    }

    function getGrade(){
        var gradeNum = devManager.getSelDictGrade();
        if(gradeNum === 0){
            return qsTr("（小学）");
        }
        else if(gradeNum === 1){
            return qsTr("（初中）");
        }
        else if(gradeNum === 2){
            return qsTr("（高中）");
        }
    }
}
