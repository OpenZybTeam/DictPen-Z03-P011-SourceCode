import QtQuick 2.0
import com.zyb.PingDefine 1.0

Item {
    id: root
    property var rootData: new Object
    property var listCurrentIndex: 0
    property alias isAllSent: wordList.isAllSent
    signal signalSearch1(var cl)
    signal signalSearch(var strData,var isInit);
//    signal signalWywInit();
    property var isSingleWord: false


    Component{
        id:buttonItem
        ZybWordListElemeat{
            height: root.height
            parentView: wordList
            onItemClicked: {
                if(!root.isSingleWord){
                    var itemdata = modelData;
                    root.listCurrentIndex = wordList.currentIndex;
                    refreshModel(modelData,childIndex);
                }

//                emit: root.signalSearch1(false);
                //emit: signalSearch(modelData["data"]);
            }

            onItemSearch: {
//                console.log("root.isSingleWord:",root.isSingleWord,"strData:",strData)
                if(!root.isSingleWord){

                    emit:signalSearch(strData,false);
                    wordList.positionViewAtIndex(wordList.currentIndex,ListView.Center);
                }

            }


        }
    }

    ListView {
        id:wordList
        property var isAllSent: true
        property var isClickble: true
        clip: true
        orientation: ListView.Horizontal
        delegate: buttonItem
        model:ListModel{}
        anchors.fill: parent
    }


    function refreshModel(itemModelData,childNum){
        var valueObj = new Object;
        if(Segmentation.isEnglishStr(itemModelData["data"])){
            valueObj["wordType"] = "en";
        }
        else{
            valueObj["wordType"] = "ch";
        }
        pingManager.addPingData(PingDefine.PING_EVENT_DICT_PARTICIPLE,valueObj);
        if(itemModelData["isHaveChild"] !== undefined && itemModelData["isHaveChild"] === true){
            var childList = new Array;
            childList = itemModelData["childList"];
            var childData = new Object;
            for(var i = 0; i < childList.length;i++){
                var childObj = childList[i]
                var childIndex = childObj["index"];
                childData = rootData[childIndex]
                wordList.model.insert(i+wordList.currentIndex,{"itemText":childData["data"],"itemData":childData});

            }
            wordList.model.remove(wordList.currentIndex + childList.length,1);
        }


        var tempIndex = root.listCurrentIndex + childNum;
//        console.log("clicked current data:",JSON.stringify(curretnObj),QueryWordManager.isLabel(currentText),childNum)
        var isfindIndex = false;
        for(var j = tempIndex;j < wordList.count;j++){
            var tempText = wordList.model.get(j).itemText;
//            console.log(tempText);
            if(!QueryWordManager.isLabel(tempText)){
                wordList.currentIndex = j;
                isfindIndex = true;
                break;
            }
        }

        if(!isfindIndex){
            for(j = tempIndex - 1;j >= 0;j--){
                tempText = wordList.model.get(j).itemText;
    //            console.log(tempText);
                if(!QueryWordManager.isLabel(tempText)){
                    wordList.currentIndex = j;
                    break;
                }
            }
        }

        wordList.positionViewAtIndex(wordList.currentIndex,ListView.Center);
        var currentItem = wordList.currentItem;
        emit: signalSearch(currentItem.btnText,false);
    }

    function initWywModel(itemModelData){
        isAllSent = false;
        wordList.model.clear();
        if(rootData.length === 1){
            isSingleWord = true;
            wordList.isClickble = false;
        }
        else{
            isSingleWord = false;
            wordList.isClickble = true;
        }
        if(itemModelData["isHaveChild"] !== undefined && itemModelData["isHaveChild"] === true){
            var childList = new Array;
            childList = itemModelData["childList"];
            var childData = new Object;
            for(var i = 0; i < childList.length;i++){
                var childObj = childList[i]
                var childIndex = childObj["index"];
                childData = rootData[childIndex]
                wordList.model.append({"itemText":childData["data"],"itemData":childData});
            }

            wordList.currentIndex = 0;
            var currentItem = wordList.currentItem;
            wordList.positionViewAtBeginning();
            emit: signalSearch(currentItem.btnText,false);
        }
    }

    function initEnModel(itemModelData,threeChildArray){
        var maxIndex = 0;
        var maxStr = threeChildArray[0];
        var sortArray = new Array;
        if(threeChildArray.length === 2){
            if(threeChildArray[0]["data"].length >= threeChildArray[1]["data"].length){
                var tempObj = threeChildArray[0];
                threeChildArray[0] = threeChildArray[1];
                threeChildArray[1] = tempObj;
            }
        }
        else{
            for(var i = 0;i < threeChildArray.length -1;i++){
                var strTemp;
                for(var j = 0;j < threeChildArray.length - i -1;j++){
                    if(threeChildArray[j]["data"].length >= threeChildArray[j + 1]["data"].length){
                        tempObj = threeChildArray[j];
                        threeChildArray[j] = threeChildArray[j+1];
                        threeChildArray[j+1] = tempObj;
                    }
                }
            }
        }

        var hasWord = false;
        var wordObj = new Object;
        for(i = threeChildArray.length -1;i >=0;i--){
            var wordStr = threeChildArray[i]["data"];
            var isEnWord = QueryWordManager.isEnglishWord(wordStr);
            console.log("++++++++++++++++wordStr:",wordStr,",isEnWord:",isEnWord);
            if(isEnWord){
                hasWord = true;
                wordObj = threeChildArray[i];
                break;
            }
        }
        if(hasWord){
            isAllSent = false;
            wordList.model.clear();
            isSingleWord = false;
            wordList.isClickble = true;
            if(itemModelData["isHaveChild"] !== undefined && itemModelData["isHaveChild"] === true){
                var childList = new Array;
                childList = itemModelData["childList"];
                var childData = new Object;
                for(i = 0; i < childList.length;i++){
                    var childObj = childList[i]
                    var childIndex = childObj["index"];
                    childData = rootData[childIndex]
                    wordList.model.append({"itemText":childData["data"],"itemData":childData});
                }

                wordList.currentIndex = wordObj["index"];
                var currentItem = wordList.currentItem;
                wordList.positionViewAtBeginning();
                emit: signalSearch(wordObj["data"],false);
            }
        }
        else{
            initModel();
        }


    }

    function initModel(){
        wordList.model.clear();
        var rootItem = rootData[rootData.length -1];

        if(rootData.length === 1){
            isSingleWord = true;
            wordList.isClickble = false;
        }
        else{
            isSingleWord = false;
            wordList.isClickble = true;
        }
        wordList.model.append({"itemText":rootItem["data"],"itemData":rootItem })
        wordList.currentIndex = 0;
        var currentItem = wordList.currentItem;
        wordList.positionViewAtBeginning();
//        wordList.contentX = 0;
        emit: signalSearch(currentItem.btnText,true);
    }

    function setData(data){
        rootData = data;
        var rootItem = rootData[rootData.length -1];
        var rootText = rootItem["data"];

        var childList = new Array;
        if(rootItem["isHaveChild"] === true || rootItem["isHaveChild"]){

            childList = rootItem["childList"];

    //        console.log("+++++++++childStr:",childStr,",",Segmentation.isWyw(childStr));

            if(Segmentation.isEnglishStr(rootText)){
                if(QueryWordManager.isEnglishWord(rootText)){
                    initModel();
                }
                else{
                    if(childList.length <= 3 && childList.length > 1){
                        var threeChilds = new Array;
                        for(var i = 0;i < childList.length;i++){
                            var childData = new Object;
                            var childObj = childList[i];
                            var index = childObj["index"];
                            childData = rootData[index];
                            var childStr = childData["data"];
                            var tempObj = new Object;
                            tempObj["data"] = childStr;
                            tempObj["index"] = i;
                            threeChilds.push(tempObj);
                        }
                        initEnModel(rootItem,threeChilds)
                    }
                    else{
                        initModel();
                    }
                }

            }
            else{
                var firstChildData = new Object;
                var firstChildObj = childList[0]
                var firstChildIndex = firstChildObj["index"];
                firstChildData = rootData[firstChildIndex];
                var firstChildStr = firstChildData["data"];
                var isWyw = Segmentation.isWyw(firstChildStr);
                if(isWyw || isWyw === true){
                    initWywModel(rootItem);
                }
                else{
                    initModel();
                }
            }

        }
        else{
            initModel();
        }


    }

    function getCurrentText(){
        var currentItem = wordList.currentItem;
        return currentItem.btnText;
    }
}

