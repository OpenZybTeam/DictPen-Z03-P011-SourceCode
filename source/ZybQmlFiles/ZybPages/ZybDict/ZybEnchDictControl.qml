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
    height: explainContent.height
    property var controlData: new Object;
    property bool isTitleViseble: true
    property var itemCells: new Array
    property var wordText: ""
    property var transText: ""
    property bool isAutoPlay: false
    signal showTi(var word,var phrase,var strToken,var source)

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
            text: qsTr("作业帮学生必备词典")
        }
        Item{
            visible: root.isTitleViseble
            height: 10
            width: parent.width
        }

        Item{
            height: briefExplain.height
            width: root.width
            Text {
                id: briefExplain
                anchors.top: parent.top
                anchors.left: parent.left
                width: root.width
                wrapMode: Text.WordWrap
                font.pixelSize: 28
                textFormat: Text.RichText
                text: ""
            }

            Image {
                id: highfre
                anchors.top: briefExplain.top
                anchors.left: briefExplain.left
                visible: true
                source: "qrc:/images/highfre.png"
            }
        }


    }

    Component{
        id:splitComponent
        Item{
            height: 15
            width: root.width
        }
    }

    Component{
        id:exampleComponent
        ZybEnchDictExControl {
            width: root.width
            onMore: {
            }
        }
    }

    Component{
        id:transformComponent
        ZybEnchDictTransformCOntrol{
            width: root.width
        }
    }

    Component{
        id:phraseComponent
        ZybEnchDictPhraseControl{
            width: root.width
            onShowTi: {
                root.showTi(strToken,strTid);
            }
        }
    }

    Component{
        id:relationComponent
        ZybEnchDictRelationControl{
            width: root.width
        }
    }

    Component.onCompleted: {
        var data = controlData;
        var cellCount = itemCells.length
        for(var i = 0;i < cellCount;i++){
            itemCells.pop().destroy();
        }

        var explains = data["paraphrase"];
        var briefExplText = "";

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
            var explainItem = explains[i];
            if(i === (explains.length - 1)){
                if(explainItem["type"] !== undefined ){
                    root.transText = root.transText + explainItem["type"];
                    briefExplText = briefExplText + strNormalFront + explainItem["type"] + "&nbsp;" + strNprmalLast;
                }
                if(explainItem["meaning"] !== undefined){
                    root.transText = root.transText + explainItem["meaning"];
                    briefExplText = briefExplText + strBoldFront + explainItem["meaning"] + " " + strBoldLast ;
                }
            }
            else{
                if(explainItem["type"] !== undefined ){
                    root.transText = root.transText + explainItem["type"];
                    briefExplText = briefExplText + strNormalFront + explainItem["type"] + "&nbsp;" + strNprmalLast;
                }
                if(explainItem["meaning"] !== undefined){
                    root.transText = root.transText + explainItem["meaning"];
                    briefExplText = briefExplText + strBoldFront + explainItem["meaning"]  + " "+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + strBoldLast ;
                }
            }

        }


        if(data["highfreq"] !== undefined){
            if(data["highfreq"] === 1){
                highfre.visible = true;
                briefExplText = strBoldFront + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + strBoldLast + briefExplText;
            }
            else{
                highfre.visible = false;
            }
        }
        else{
            highfre.visible = false;
        }

        briefExplain.text = strHead + briefExplText + strTaile;

        var sentArray = data["sentence"];
        if(sentArray.length > 0){
            itemCells.push(splitComponent.createObject(explainContent));
            itemCells.push(exampleComponent.createObject(explainContent,{controlData:sentArray}))
        }

        var transArray = data["transform"];
        if(transArray.length > 0){
            itemCells.push(splitComponent.createObject(explainContent));
            itemCells.push(transformComponent.createObject(explainContent,{controlData:transArray}))
        }

        var gradeNum = devManager.getSelDictGrade();
        var phraseArray = data["phrase"];
        if(phraseArray.length > 0){
            var gradePhraseArray = new Array;
            for(i = 0;i < phraseArray.length;i++){
                var phraseItem = phraseArray[i];
                if(phraseItem["grade"] === (gradeNum + 1)){
                    gradePhraseArray.push(phraseItem);
                }
            }
            if(gradePhraseArray.length > 0){
                itemCells.push(splitComponent.createObject(explainContent));
                itemCells.push(phraseComponent.createObject(explainContent,{controlData:gradePhraseArray,word:root.controlData["word"]}))
            }
        }

        var relationArray = data["relatedWords"];
        if(relationArray.length > 0){

            var gradeRelationArray = new Array;
            for(i = 0;i < relationArray.length;i++){
                var relationItem = relationArray[i];
                if(relationItem["grade"] === (gradeNum + 1)){
                    gradeRelationArray.push(relationItem);
                }
            }

            //        var array1 = new Array; //派生词
                    var array2 = new Array; //近义词
                    var array3 = new Array; //反义词
            //        var array4 = new Array; //同形异义词
            //        var array5 = new Array; //衍生词
            //        var array6 = new Array; //易混词
                    var array7 = new Array; //同根词
            //        var array8 = new Array; //同义词辨析
            //        var array9 = new Array; //短语辨析
                    for(i = 0;i < relationArray.length;i++){
                        var relItem = relationArray[i];
            //            if(relItem["type"] === "1"){
            //                array1.push(relItem);
            //            }
                        if(relItem["type"] === "2"){
                            array2.push(relItem);
                        }
                        else if(relItem["type"] === "3"){
                            array3.push(relItem);
                        }
            //            else if(relItem["type"] === "4"){
            //                array4.push(relItem);
            //            }
            //            else if(relItem["type"] === "5"){
            //                array5.push(relItem);
            //            }
            //            else if(relItem["type"] === "6"){
            //                array6.push(relItem);
            //            }
                        else if(relItem["type"] === "7"){
                            array7.push(relItem);
                        }
            //            else if(relItem["type"] === "8"){
            //                array8.push(relItem);
            //            }
            //            else if(relItem["type"] === "9"){
            //                array9.push(relItem);
            //            }
                    }

                    var listData = new Array;
            //            if(array1.length > 0){
            //                var listItem = {"type":qsTr("派生词")}
            //                listItem["words"] = array1
            //                listData.push(listItem);
            //            }
                    if(array2.length > 0){
                        var listItem = {"type":qsTr("近义词")}
                        listItem["words"] = array2
                        listData.push(listItem);
                    }
                    if(array3.length > 0){
                        listItem = {"type":qsTr("反义词")}
                        listItem["words"] = array3
                        listData.push(listItem);
                    }
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
                    if(array7.length > 0){
                        listItem = {"type":qsTr("同根词")}
                        listItem["words"] = array7
                        listData.push(listItem);
                    }
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

            if(listData.length > 0){
//                console.log(JSON.stringify(gradeRelationArray))
                itemCells.push(splitComponent.createObject(explainContent));
                itemCells.push(relationComponent.createObject(explainContent,{controlData:listData}))
            }
        }

    }
}
