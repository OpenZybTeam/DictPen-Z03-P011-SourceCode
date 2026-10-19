import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../ZybControls/"
import "../../Funcs/UILogics.js" as UILogic
import "../../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../../Style"
import com.zyb.PingDefine 1.0

Rectangle {
    id:root
    anchors.fill: parent
    color: Style.mainbgColor
    z:2
    property var controlData: new Object
    property var curTopData: new Object
    property var curExpainData: new Object
    property int curWordIndex: 0
    property int curPosIndex: 0
    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    Flickable{
        id:flickable
        anchors.fill: parent
        contentHeight: column.height + 50
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true

        Column{
            id:column
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 27
            spacing: 0

            Item{
                id: header
                width:column.width
                height: 56
                ZybBackButton{
                    id:backButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    onBackClicked: {
                        root.destroy();
                    }
                }

                Text{
                    id:wordText
                    anchors.left: backButton.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 72
                    font.family: Style.engFontFamily
                    font.pixelSize: 28
                    color: "#FFFFFF"
                }
            }

            Item {
                width: column.width
                height: 16
            }

            OxfordWordList{
                id:wordList
                width:column.width
                onCurrentIndex_Changed: {
                    posList.setData(wordData["subentry_gs"]);
                    curTopData = wordData["top"];
                    updateWordFmButton(curTopData);
                    briefControl.setTopData(wordData["top"]);
                }
            }

            Item {
                visible: wordList.visible
                width: column.width
                height: 16
            }

            OxfordPosList{
                id:posList
                width:column.width
                onCurrentIndex_Changed: {
                    briefControl.setExplainData(subentryData);
                    curExpainData = subentryData;
                    updateButtons(subentryData);
                }
            }

            Item {
                visible: posList.visible
                width:column.width
                height: 1
            }

            OxfordBrefControl{
                id: briefControl
                width:column.width
            }

            Item{
                width:column.width
                height: 20
            }

            Row{
                id:buttonRow
                width: parent.width
                spacing: 10

                OxfordDetaileButton{
                    id:explainBtn
                    text: qsTr("释义")
                    onClicked: {
                        pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_EXPLAIN_CLICK);
                        explainPage = explainPageComponent.createObject(root,{controlData:curExpainData});
                    }
                }

                OxfordDetaileButton{
                    id:idmDerBtn
                    text: qsTr("派生词")
                    onClicked: {
                        pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_IDMDER_CLICK);
                        var idmData = curExpainData["dr_gs"];
                        idmDerPage = idmDerPageComponent.createObject(root,{controlData:idmData});
                    }
                }

                OxfordDetaileButton{
                    id:idiomBtn
                    text: qsTr("习语")
                    onClicked: {
                        pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_IDM_CLICK);
                        var idmData = curExpainData["idm_gs"];
                        idmPage = idmPageComponent.createObject(root,{controlData:idmData});
                    }
                }

                OxfordDetaileButton{
                    id:verbPhraseBtn
                    text: qsTr("动词短语")
                    onClicked: {
                        pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_VPHRASE_CLICK);
                        var pvData = curExpainData["pv_gs"];
                        pvPage = pvPageComponent.createObject(root,{controlData:pvData});
                    }
                }

                OxfordDetaileButton{
                    id:wordFmBtn
                    text: qsTr("词族")
                    onClicked: {
                        pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_WORDFAMILY_CLICK);
                        var wordFmData = curTopData["wordfamily"];
                        wordFamilyPage = wordFamilyPageComponent.createObject(root,{controlData:wordFmData});
                    }
                }
            }
        }
    }


    property var explainPage: null
    Component{
        id:explainPageComponent
        OxfordExplainPage{
        }
    }

    property var idmPage: null
    Component{
        id:idmPageComponent
        OxfordIdmPage{
        }
    }

    property var pvPage: null
    Component{
        id:pvPageComponent
        OxfordVerbPhrasePage{
        }
    }

    property var idmDerPage: null
    Component{
        id:idmDerPageComponent
        OxfordIdmDerPage{
        }
    }

    property var wordFamilyPage: null
    Component{
        id:wordFamilyPageComponent
        OxfordWordFamilyPage{
        }
    }

    Connections {
        target: scanManager;

        onSig_scanDown:{
            root.destroy();
        }
    }

    Component.onCompleted: {
        wordList.setData(controlData);
        wordText.text = controlData["word"];
        wordList.setCurrentIndex(curWordIndex);
        posList.setCurrentIndex(curPosIndex);
    }

    Component.onDestruction: {
        QueryWordManager.playStop();
        if(explainPage !== null){
            explainPage.destroy();
        }

        if(idmPage !== null){
            idmPage.destroy();
        }

        if(pvPage !== null){
            pvPage.destroy();
        }

        if(idmDerPage !== null){
            idmDerPage.destroy();
        }

        if(wordFamilyPage !== null){
            wordFamilyPage.destroy();
        }
    }

    function updateButtons(explainData){
        if(explainData["sn_gs"] !== undefined){
            explainBtn.visible = true;
        }
        else{
            explainBtn.visible = false;
        }

        if(explainData["idm_gs"] !== undefined){
            var idm_gs = explainData["idm_gs"];
            var idmArray = new Array;
            for(var i = 0;i < idm_gs.length;i++){
                var idmObj = idm_gs[i];
                if(idmObj["type"] === "idm_g"){
                    idmArray.push(idmObj);
                }
            }

            if(idmArray.length >= 1){
                idiomBtn.visible = true;
            }
            else{
                idiomBtn.visible = false;
            }


        }
        else{
            idiomBtn.visible = false;
        }

        if(explainData["dr_gs"] !== undefined){
            idmDerBtn.visible = true;
        }
        else{
            idmDerBtn.visible = false;
        }

        if(explainData["pv_gs"] !== undefined){
            verbPhraseBtn.visible = true;
        }
        else{
            verbPhraseBtn.visible = false;
        }
    }

    function updateWordFmButton(topData){
        if(topData["wordfamily"] !== undefined){
            wordFmBtn.visible = true;
        }
        else{
            wordFmBtn.visible = false;
        }
    }


}
