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
    height: excol.height
    property var controlData: new Array;
    property bool isTitleViseble: false
    property var exampleCells: new Array
    property var sortData: new Array
    property var wordResViewPosion: 0
    signal more(var data)

    Column{
        id:excol
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        width: parent.width

        Text{
            id:exampleTitle
            color: "#FF12CFA7"
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            font.pixelSize: Style.scanresult_explain_fontSize
            text: qsTr("真题例句/典型例句")
        }

        Item{
            height: 10
            visible: exampleTitle.visible
            width: root.width
        }
        Column{
            id:exampleContent
            width: explainContent.width
            spacing: 10
        }

        Item{
            height: 16
            width: root.width
            visible: moreBtn.visible || packupBtn.visible
        }

        Rectangle{
            id: moreBtn
            width: 176
            height: 56
            radius: 28
            color: "#663C3D42"
            visible: false
            Row{
                height: moreText.height
                spacing: 0
                anchors.centerIn: parent
                Text {
                    id:moreText
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 28
                    color: "#FFFFFF"
                    text: qsTr("查看更多")
                }

                Image {
                    source: "qrc:/images/zybdict_more.png"
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_EXMORE_CLICK);
                    root.wordResViewPosion = UILogic.getWordResViewPos();
                    moreEx();
                }
            }
        }

        Rectangle{
            id: packupBtn
            width: 120
            height: 56
            radius: 28
            color: "#663C3D42"
            visible: false
            Row{
                height: packupText.height
                spacing: 0
                anchors.centerIn: parent
                Text {
                    id:packupText
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 28
                    color: "#FFFFFF"
                    text: qsTr("收起")
                }

                Image {
                    source: "qrc:/images/pack_up.png"
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    packUp();
                    UILogic.setWordResViewPos(root.wordResViewPosion);
                }
            }
        }

    }

    Component{
        id:exampleComponent
        Item{
            id:exampleItem
            width: excol.width
            height: sourceVisible ? (excontent.height + 0 + sourceText.height) : excontent.height
            property string enStr: ""
            property string chStr: ""
            property string sourceStr: ""
            property bool sourceVisible: false
            EnchExampleComponent {
                id:excontent
                width: excol.width
                enText: exampleItem.enStr
                chText: exampleItem.chStr
            }

            Text {
                id: sourceText
                wrapMode: Text.WrapAnywhere
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: 24
                color: "#999999"
                anchors.top: excontent.bottom
                anchors.topMargin: 0
                text: exampleItem.sourceStr
            }
        }
    }

    Component.onCompleted: {
        var data = controlData;
        var tiArray = new Array;
        var normalArrar = new Array;
        for(var i = 0;i < data.length;i++){
            var exItem = data[i];
            if(exItem["type"] !== undefined){
                if(exItem["type"] === "3" || exItem["type"] === "2"){
                    tiArray.push(exItem);
                }
                else{
                    normalArrar.push(exItem);
                }
            }
            else{
                normalArrar.push(exItem);
            }
        }

        if(tiArray.length > 0){
            sortData = QueryWordManager.sortZybdictExamples(tiArray)
            for(i = 0;i < normalArrar.length;i++){
                sortData.push(normalArrar[i]);
            }
        }
        else{
            sortData = normalArrar;
        }

        for(i = 0; i < sortData.length && i < 2;i++){
            var exampleItem = sortData[i];
            var cell;
            if(exampleItem["type"] !== undefined){
                if(exampleItem["type"] === "3" || exampleItem["type"] === "2"){
                    var sourceStr = qsTr("来源：") + exampleItem["source"] + "  " + exampleItem["comment"]
                    cell = exampleComponent.createObject(exampleContent,{enStr:exampleItem["english"],chStr:exampleItem["chinese"],sourceStr:sourceStr,sourceVisible:true});
                }
                else{
                    cell = exampleComponent.createObject(exampleContent,{enStr:exampleItem["english"],chStr:exampleItem["chinese"],sourceVisible:false});
                }
            }
            else{
                cell = exampleComponent.createObject(exampleContent,{enStr:exampleItem["english"],chStr:exampleItem["chinese"],sourceVisible:false});
            }
            exampleCells.push(cell)
        }

        if(sortData.length > 2){
            moreBtn.visible = true;
            packupBtn.visible = false;
        }
        else{
            moreBtn.visible = false;
            packupBtn.visible = false;
        }

    }

    function moreEx(){
        for(var i = 2;i < 10 && i < sortData.length;i++){
            var exampleItem = sortData[i];
            var cell;
            if(exampleItem["type"] !== undefined){
                if(exampleItem["type"] === "3" || exampleItem["type"] === "2"){
                    var sourceStr = qsTr("来源：") + exampleItem["source"] + "  " + exampleItem["comment"]
                    cell = exampleComponent.createObject(exampleContent,{enStr:exampleItem["english"],chStr:exampleItem["chinese"],sourceStr:sourceStr,sourceVisible:true});
                }
                else{
                    cell = exampleComponent.createObject(exampleContent,{enStr:exampleItem["english"],chStr:exampleItem["chinese"],sourceVisible:false});
                }
            }
            else{
                cell = exampleComponent.createObject(exampleContent,{enStr:exampleItem["english"],chStr:exampleItem["chinese"],sourceVisible:false});
            }
            exampleCells.push(cell)
        }
        moreBtn.visible = false;
        packupBtn.visible = true;
    }

    function packUp(){
        for(var i = exampleCells.length-1;i >= 2;i--){
            exampleCells.pop().destroy();
        }
        moreBtn.visible = true;
        packupBtn.visible = false;
    }
}
