import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import "../Global"
import "./ZybDict"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Column{
    id:column
    property var controlData: null
    property var dictCells: new Array;
    property var word: ""
    property var queryRes: new Object
    signal showTi(var word,var phrase,var strToken,var source)

    Component{
        id:spliteComponent
        PageSpliter{
            width: column.width
        }
    }

    Component{
        id:splite2Component
        Item{
            width: column.width
        }
    }

    Component{
        id:transComponent
        TransControl{
            Component.onCompleted: {
                setDataText(column.queryRes["trans"],column.queryRes["word"])
            }
        }
    }

    Component{
        id:soundComponent2
        Item {
            height: 56
            width: column.width
            ZybSoundPlayButton{
                id:orgSound
                text: qsTr("发音")
                onClicked: {
                    var valueObj = new Object;
                    valueObj["wordType"] = "en"
                    pingManager.addPingData(PingDefine.PING_EVENT_DICT_SRC_SPEECH,valueObj);
                    QueryWordManager.play(column.word,2,4);
                }
            }

            function play(){
                orgSound.play();
            }
        }
    }

    Component{
        id:enchComponent
        EnChDictControl{
            width: column.width
        }
    }

    Component{
        id:oxfordComponent
        OxfordDictControl{
            width: column.width
        }
    }

    Component{
        id:zybdictComponent
        ZybEnchDictControl{
            width: column.width
            onShowTi: {
            }
        }
    }

    Component{
        id:soundComponent
        EnPhoneticComponent{
        }
    }

    Timer{
        id:autospeakTimer
        interval: GlobalProperty.autoSpeekDelay
        repeat: false;
        running: false
        triggeredOnStart: false
        onTriggered:{
            if(!root.visible)
                return;
            if(devStateMonitor.getDevState() === DevStatus.DevState_OffScreen){
                return;
            }
            if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
                soundPlayCell.play();
            }
        }
    }

    property var soundPlayCell: null
    function setData(data){
        var cellCount = dictCells.length;
        soundPlayCell = null;
        for(var i = 0;i < cellCount;i++){
            dictCells.pop().destroy();
        }
        queryRes = data;
        column.word = data["word"];
        if(data["result"] === undefined){
            soundPlayCell = soundComponent2.createObject(column);
            dictCells.push(soundPlayCell);
            dictCells.push(spliteComponent.createObject(column));
            autospeakTimer.restart();
        }

//        if(data["trans"] !== undefined){
//            dictCells.push(transComponent.createObject(column,{width:column.width}));
//            dictCells.push(spliteComponent.createObject(column));
//        }

        if(devManager.getSelEnCurDict() === 0){
            if(data["result"] !== undefined){
                var briefRes = data["result"];
                dictCells.push(enchComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:data["result"],wordText:data["word"]}));
                if(briefRes["isdeformation"] === true){
                    soundPlayCell = soundComponent2.createObject(column);
                    dictCells.push(soundPlayCell);
                    autospeakTimer.restart();
                }
                else{
                    if(briefRes["phonetic"] !== undefined){
                        dictCells.push(soundComponent.createObject(column,{width:column.width,controlData:data["result"],wordText:data["word"]}));
                    }
                }
                if(data["zybResult"] !== undefined || data["oxfordResult"] !== undefined)
                    dictCells.push(spliteComponent.createObject(column));
            }

            if(data["zybResult"] !== undefined){
                var titleVisible = false;
                if(data["result"] !== undefined){
                    titleVisible = true;
                }
                else{
                    titleVisible = false;
                }
                dictCells.push(zybdictComponent.createObject(column,{width:column.width,isTitleViseble:titleVisible,controlData:data["zybResult"]}));
//                if(data["result"] === undefined){
//                    soundPlayCell = soundComponent2.createObject(column);
//                    dictCells.push(soundPlayCell);
//                    autospeakTimer.restart();
//                }
                if(data["oxfordResult"] !== undefined)
                    dictCells.push(spliteComponent.createObject(column));
            }

            if(data["oxfordResult"] !== undefined){
                if(data["result"] !== undefined || data["zybResult"] !== undefined){
                    titleVisible = true;
                }
                else{
                    titleVisible = false;
                }
                dictCells.push(oxfordComponent.createObject(column,{width:column.width,isTitleViseble:titleVisible,controlData:data["oxfordResult"]}));
//                if(data["result"] === undefined && data["zybResult"] === undefined){
//                    soundPlayCell = soundComponent2.createObject(column);
//                    dictCells.push(soundPlayCell);
//                    autospeakTimer.restart();
//                }
            }
        }
        else if(devManager.getSelEnCurDict() === 1){
            if(data["oxfordResult"] !== undefined){
                dictCells.push(oxfordComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:data["oxfordResult"]}));
                if(data["result"] !== undefined){
                    briefRes = data["result"];
                    if(briefRes["isdeformation"] === true){
                        dictCells.push(splite2Component.createObject(column,{height:18}));
                        soundPlayCell = soundComponent2.createObject(column);
                        dictCells.push(soundPlayCell);
                        autospeakTimer.restart();
                    }
                    else{
                        if(briefRes["phonetic"] !== undefined){
                            dictCells.push(splite2Component.createObject(column,{height:18}));
                            dictCells.push(soundComponent.createObject(column,{width:column.width,controlData:data["result"],wordText:data["word"]}));
                        }
                    }
                }
                if(data["zybResult"] !== undefined || data["result"] !== undefined)
                    dictCells.push(spliteComponent.createObject(column));
            }

            if(data["zybResult"] !== undefined){
                if(data["oxfordResult"] !== undefined){
                    titleVisible = true;
                }
                else{
                    titleVisible = false;
                }
                dictCells.push(zybdictComponent.createObject(column,{width:column.width,isTitleViseble:titleVisible,controlData:data["zybResult"]}));
                if(data["oxfordResult"] === undefined){
                    if(data["result"] !== undefined){
                        briefRes = data["result"];
                        if(briefRes["isdeformation"] === true){
                            dictCells.push(splite2Component.createObject(column,{height:18}));
                            soundPlayCell = soundComponent2.createObject(column);
                            dictCells.push(soundPlayCell);
                            autospeakTimer.restart();
                        }
                        else{
                            if(briefRes["phonetic"] !== undefined){
                                dictCells.push(splite2Component.createObject(column,{height:18}));
                                dictCells.push(soundComponent.createObject(column,{width:column.width,controlData:data["result"],wordText:data["word"]}));
                            }
                        }
                    }
                }
                if(data["result"] !== undefined)
                    dictCells.push(spliteComponent.createObject(column));
            }

            if(data["result"] !== undefined){
                if(data["oxfordResult"] !== undefined || data["zybResult"] !== undefined){
                    titleVisible = true;
                }
                else{
                    titleVisible = false;
                }
                briefRes = data["result"];
                dictCells.push(enchComponent.createObject(column,{width:column.width,isTitleViseble:titleVisible,controlData:data["result"],wordText:data["word"]}));

                if(data["oxfordResult"] === undefined && data["zybResult"] === undefined){
                    if(briefRes["isdeformation"] === true){
                        soundPlayCell = soundComponent2.createObject(column);
                        dictCells.push(soundPlayCell);
                        autospeakTimer.restart();
                    }
                    else{
                        if(briefRes["phonetic"] !== undefined){
                            dictCells.push(soundComponent.createObject(column,{width:column.width,controlData:data["result"],wordText:data["word"]}));
                        }
                    }
                }
            }


        }
        else if(devManager.getSelEnCurDict() === 2){
            if(data["zybResult"] !== undefined){
                dictCells.push(zybdictComponent.createObject(column,{width:column.width,isTitleViseble:false,controlData:data["zybResult"]}));
                if(data["result"] !== undefined){
                    briefRes = data["result"];
                    if(briefRes["isdeformation"] === true){
                        dictCells.push(splite2Component.createObject(column,{height:18}));
                        soundPlayCell = soundComponent2.createObject(column);
                        dictCells.push(soundPlayCell);
                        autospeakTimer.restart();
                    }
                    else{
                        if(briefRes["phonetic"] !== undefined){
                            dictCells.push(splite2Component.createObject(column,{height:18}));
                            dictCells.push(soundComponent.createObject(column,{width:column.width,controlData:data["result"],wordText:data["word"]}));
                        }
                    }
                }
                if(data["result"] !== undefined || data["oxfordResult"] !== undefined)
                    dictCells.push(spliteComponent.createObject(column));
            }

            if(data["result"] !== undefined){
                if(data["zybResult"] !== undefined){
                    titleVisible = true;
                }
                else{
                    titleVisible = false;
                }
                briefRes = data["result"];
                dictCells.push(enchComponent.createObject(column,{width:column.width,isTitleViseble:titleVisible,controlData:data["result"],wordText:data["word"]}));

                if(data["zybResult"] === undefined){
                    if(briefRes["isdeformation"] === true){
                        soundPlayCell = soundComponent2.createObject(column);
                        dictCells.push(soundPlayCell);
                        autospeakTimer.restart();
                    }
                    else{
                        if(briefRes["phonetic"] !== undefined){
                            dictCells.push(soundComponent.createObject(column,{width:column.width,controlData:data["result"],wordText:data["word"]}));
                        }
                    }
                }
                if(data["oxfordResult"] !== undefined)
                    dictCells.push(spliteComponent.createObject(column));
            }

            if(data["oxfordResult"] !== undefined){
                if(data["zybResult"] !== undefined || data["result"] !== undefined){
                    titleVisible = true;
                }
                else{
                    titleVisible = false;
                }
                dictCells.push(oxfordComponent.createObject(column,{width:column.width,isTitleViseble:titleVisible,controlData:data["oxfordResult"]}));
//                if(data["result"] === undefined && data["zybResult"] === undefined){
//                    soundPlayCell = soundComponent2.createObject(column);
//                    dictCells.push(soundPlayCell);
//                    autospeakTimer.restart();
//                }
            }
        }
        visible = true;
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
