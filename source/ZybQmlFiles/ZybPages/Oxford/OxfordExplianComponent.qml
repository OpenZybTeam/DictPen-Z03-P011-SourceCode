import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"
import "../../ZybControls"

Rectangle{
    id:root
    color: Style.mainbgColor
    height: column.height
    property var controlData: new Object
    property var startNum: 0

    Column {
        id:column
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top
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
        var sng = controlData;
        if(sng["shcut"] !== undefined){
            var shcut = sng["shcut"];
            var strShcut = shcut["en"] + " " + shcut["ch"];
            explainCells.push(shcutComponent.createObject(column,{width:column.width,controlData:strShcut}));
//            explainCells.push(splitComponent.createObject(column,{width:column.width,height:5}));
        }

        if(sng["explain"] !== undefined){
            var explains = sng["explain"];
            var defNum = startNum;
            for(var i = 0;i < explains.length;i++){
                var explainItem = explains[i];
                var hasDef = false;
                var defData = new Object;
                if(explainItem["def"] !== undefined){
                    defData["def"] = explainItem["def"];
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
                    explainCells.push(splitComponent.createObject(column,{width:column.width,height:10}));
                    explainCells.push(defComponent.createObject(column,{width:column.width,controlData:defData,headerText:defNum.toString()}));
                    explainCells.push(splitComponent.createObject(column,{width:column.width,height:5}));
                }

                if(explainItem["examples"] !== undefined){
                    var examples = explainItem["examples"];
                    for(var j = 0;j < examples.length;j++){
                        var exampleItem = examples[j];
                        var contentObj = exampleItem["content"];
                        if(contentObj["sent"] !== undefined){
                            var sentObj = contentObj["sent"];
//                            explainCells.push(exampleComponent.createObject(column,{width:column.width,controlData:examples[j]}));
//                            explainCells.push(splitComponent.createObject(column,{width:column.width,height:10}));
                            if(sentObj["en"] !== undefined && sentObj["ch"] !== undefined){
                                explainCells.push(exampleComponent.createObject(column,{width:column.width,controlData:examples[j]}));
                                explainCells.push(splitComponent.createObject(column,{width:column.width,height:10}));
                            }
                        }

                    }
                }

                if(explainItem["xrgs"] !== undefined ){
                    var sngXrgs = explainItem["xrgs"];
//                    console.log(JSON.stringify(sngXrgs))
                    for(var k = 0;k < sngXrgs.length;k++){
                        var xrgObj = sngXrgs[k];
                        if(xrgObj["text"] !== "" && xrgObj["mark"] !== "null"){
                            explainCells.push(noteComponent.createObject(column,{width:column.width,controlData:sngXrgs[k]}));
                        }
                    }
                }
            }
        }

        if(sng["xrgs"] !== undefined){
            var sngsXrgs = sng["xrgs"];
            console.log(JSON.stringify(sngsXrgs))
            for(k = 0;k < sngsXrgs.length;k++){
                xrgObj = sngsXrgs[k];
                if(xrgObj["text"] !== "" && xrgObj["mark"] !== "null"){
                    explainCells.push(noteComponent.createObject(column,{width:column.width,controlData:xrgObj}));
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


