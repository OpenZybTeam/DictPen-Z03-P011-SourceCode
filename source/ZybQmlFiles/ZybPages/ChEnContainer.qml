import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import com.zyb.PingDefine 1.0

Column{
    id:column
    property var controlData: null
    property var dictCells: new Array;

    Component{
        id:spliteComponent
        PageSpliter{
            width: column.width
        }
    }

    Component{
        id:chenComponent
        ChEnDictControl{
            width: column.width
        }
    }

    Component{
        id:xianDaiComponent
        XianDaiDictControl{
            width: column.width
        }
    }

    Component{
        id:xinhuaComponent
        XinHuaDictControl{
            width: column.width
        }
    }

    Component{
        id:idiomComponent
        IdiomControl{
            width: column.width
        }
    }

    Component{
        id:wywComponent
        WywControl{
            width: column.width
        }
    }

    function setData(data){
        var dictFirst = devManager.getSelCurDict();
        var cellCount = dictCells.length;
        for(var i = 0;i < cellCount;i++){
            dictCells.pop().destroy();
        }
        var isHaveChEnRes = false;
        var isHaveXinhuaXiandaiRes = false;
        var isHaveIdiomRes = false;
        var isHaveWywRes = false;
        var queryRes = data;
        var chenRes;
        if(queryRes["ch_en_result"] !== undefined){
            isHaveChEnRes = true;
            chenRes = queryRes["ch_en_result"];
            if(dictFirst === 0){
                var chWordObj = new Object;
                if(queryRes["xiandai_result"] !== undefined){
                    var xiandaiData = queryRes["xiandai_result"];
                    var xiandaiExplains = xiandaiData["explains"];
                    var xiadaiExplainItem = xiandaiExplains[0];
                    chWordObj["word"] = xiandaiData["word"];
                    chWordObj["phonetic"] = xiadaiExplainItem["phonetic"];
                    chenRes["chword"] = chWordObj;
                }

                if(queryRes["xinhua_result"] !== undefined){
                    var xinhuaData = queryRes["xinhua_result"];
                    var xinhuaExplains = xinhuaData["explains"];
                    if(xinhuaExplains.length === 1){
                        var xinhuaExpItem = xinhuaExplains[0];
                        chWordObj["word"] = xinhuaData["word"];
                        chWordObj["phonetic"] = xinhuaExpItem["phonetic"];
                        chenRes["chword"] = chWordObj;
                    }
                }
                if(queryRes["idiom_result"] !== undefined){
                    var idiomData = queryRes["idiom_result"];
                    chWordObj["word"] = idiomData["word"];
                    chWordObj["phonetic"] = idiomData["phonetic"];
                    chenRes["chword"] = chWordObj;
                }
            }

        }
        if(dictFirst === 0 && isHaveChEnRes){
            dictCells.push(chenComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:chenRes,isTransRes:false}));
            dictCells.push(spliteComponent.createObject(column));
        }

        if(queryRes["xiandai_result"] !== undefined){
            isHaveXinhuaXiandaiRes = true;
            if(dictFirst === 0){
                if(isHaveChEnRes === false){
                    dictCells.push(xianDaiComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:queryRes["xiandai_result"],phoneticVisible:true}));
                    dictCells.push(spliteComponent.createObject(column));
                    //                    xiandaiDict.setData(queryRes["xiandai_result"],true);
                }
                else{
                    dictCells.push(xianDaiComponent.createObject(column,{width:column.width,isTitleViseble:true,controlData:queryRes["xiandai_result"],phoneticVisible:false}));
                    dictCells.push(spliteComponent.createObject(column));
//                    xiandaiDict.setData(queryRes["xiandai_result"],false);
                }

            }
            else if(dictFirst === 1)
            {
                dictCells.push(xianDaiComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:queryRes["xiandai_result"],phoneticVisible:true}));
                dictCells.push(spliteComponent.createObject(column));
//                xiandaiDict.setData(queryRes["xiandai_result"],true);
            }
        }

        if(queryRes["xinhua_result"] !== undefined){
            isHaveXinhuaXiandaiRes = true;
            if(dictFirst === 0){
                if(isHaveChEnRes === false){
                    dictCells.push(xinhuaComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:queryRes["xinhua_result"],phoneticVisible:true}));
                    dictCells.push(spliteComponent.createObject(column));
//                    xinhuaDict.setData(queryRes["xinhua_result"],true);
                }
                else{
                    dictCells.push(xinhuaComponent.createObject(column,{width:column.width,isTitleViseble:true,controlData:queryRes["xinhua_result"],phoneticVisible:false}));
                    dictCells.push(spliteComponent.createObject(column));
//                    xinhuaDict.setData(queryRes["xinhua_result"],false);
                }
            }
            else if(dictFirst === 1)
            {
                dictCells.push(xinhuaComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:queryRes["xinhua_result"],phoneticVisible:true}));
                dictCells.push(spliteComponent.createObject(column));
//                xinhuaDict.setData(queryRes["xinhua_result"],true);
            }
        }


        if(queryRes["idiom_result"] !== undefined){
            isHaveIdiomRes = true;
            if(dictFirst === 0){
                if(isHaveChEnRes === false){
                    dictCells.push(idiomComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:queryRes["idiom_result"],phoneticVisible:true}));
                    dictCells.push(spliteComponent.createObject(column));
//                    idiomDict.setData(queryRes["idiom_result"],true);
                }
                else{
                    dictCells.push(idiomComponent.createObject(column,{width:column.width,isTitleViseble:true,controlData:queryRes["idiom_result"],phoneticVisible:false}));
                    dictCells.push(spliteComponent.createObject(column));
//                    idiomDict.setData(queryRes["idiom_result"],false);
                }
            }
            else if(dictFirst === 1)
            {
                dictCells.push(idiomComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:queryRes["idiom_result"],phoneticVisible:true}));
                dictCells.push(spliteComponent.createObject(column));
//                idiomDict.setData(queryRes["idiom_result"],true);
            }
        }
        if(dictFirst === 1 && isHaveChEnRes){
            dictCells.push(chenComponent.createObject(column,{width:column.width,isTitleViseble:true,controlData:chenRes,isTransRes:false}));
            dictCells.push(spliteComponent.createObject(column));
        }

        if(queryRes["wyw_result"] !== undefined){
            isHaveWywRes = true;
            dictCells.push(wywComponent.createObject(column,{isTitleViseble:false,controlData:queryRes["wyw_result"]}));
            dictCells.push(spliteComponent.createObject(column));
//            wywDict.setData(queryRes["wyw_result"]);
        }
        dictCells.pop().destroy();
    }


    onVisibleChanged: {
        if(!visible){
            var cellCount = dictCells.length;
            for(var i = 0;i < cellCount;i++){
                dictCells.pop().destroy();
            }
        }
    }

}
