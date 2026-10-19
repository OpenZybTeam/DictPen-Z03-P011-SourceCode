import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import "../Global"
import "./Oxford"
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

        Text{
            id:title
            visible: root.isTitleViseble
            color: "#FF12CFA7"
            font.pixelSize: 36
            text: qsTr("牛津词典")
        }
        Item{
            visible: root.isTitleViseble
            height: 10
            width: parent.width
        }

        OxfordWordList{
            id:wordList
            width:explainContent.width
            onCurrentIndex_Changed: {
//                console.log(JSON.stringify(wordData));
                QueryWordManager.playStop();
                posList.setData(wordData["subentry_gs"]);
                briefControl.setTopData(wordData["top"]);
                updateMoreBtn(wordData["subentry_gs"],wordData["top"]);
            }
        }

        Item {
            visible: wordList.visible
            width: explainContent.width
            height: 16
        }

        OxfordPosList{
            id:posList
            width:explainContent.width
            onCurrentIndex_Changed: {
//                root.updateExamples(index);
                QueryWordManager.playStop();
                briefControl.setExplainData(subentryData);
            }
        }

        Item {
            visible: posList.visible
            width: explainContent.width
            height: 1
        }

        OxfordBrefControl{
            id:briefControl
            width:explainContent.width
            isExplainShow: true

//            onShowMore: {
//                ScanViewLogic.gotoOxfordMorePage(controlData,wordList.curIndex,posList.curIndex);
//            }
        }

        Item {
            visible: wordBtn.visible
            width: explainContent.width
            height: 10
        }

        Image {
            id: wordBtn
            source: "qrc:/images/oxford_more.png"

            MouseArea{
                height: parent.height + 10
                width: parent.width + 10
                anchors.centerIn: parent
                onClicked: {
                    pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_MORE_CLICK);
                    ScanViewLogic.gotoOxfordMorePage(controlData,wordList.curIndex,posList.curIndex);
                }
            }
        }
    }


    Component.onCompleted: {
        wordList.setData(controlData);
    }

    function updateMoreBtn(subentry_gs,top){
        wordBtn.visible = true;
        if(subentry_gs.length === 1){
            var subentryObj = subentry_gs[0];
            var isHaveMore = false;
            if(subentryObj["idm_gs"] !== undefined){
                isHaveMore = true;
            }
            else if(subentryObj["pv_gs"] !== undefined){
                isHaveMore = true;
            }
            else if(subentryObj["dr_gs"] !== undefined){
                isHaveMore = true;
            }

            if(top["wordfamily"] !== undefined){
                isHaveMore = true;
            }

            if(subentryObj["sn_gs"] !== undefined){
                var sngsArray = subentryObj["sn_gs"];
                if(sngsArray.length === 1){
                    var sngObj = sngsArray[0];
                    if(sngObj["explain"] !== undefined){
                        var explainArray = sngObj["explain"];
                        if(explainArray.length === 1){
                            var explainObj = explainArray[0];
                            if(explainObj["examples"] !== undefined){
                                var exampleArray = explainObj["examples"];
                                if(exampleArray.length === 1){
                                    if(!isHaveMore){
                                        wordBtn.visible = false;
                                    }
                                }
                            }
                            else{
                                if(!isHaveMore){
                                    wordBtn.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
