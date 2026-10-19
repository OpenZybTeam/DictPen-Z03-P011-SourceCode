import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"
import "../../ZybControls"

Rectangle{
    id:root
    anchors.fill: parent
    color: Style.mainbgColor
    z:2
    property var controlData: new Object
    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    Image{
        id : topbtn
        source: "qrc:/images/top66x56.png"
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        z:1
        MouseArea{
            anchors.fill: parent
            onClicked: {
                flickable.contentY = 0;
            }
        }
    }

    Flickable{
        id:flickable
        anchors.fill: parent
        contentHeight: column.height + 50
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true
        property var contentCoordY: 0 //记录滚动条位置
        property var preContentY: 0 //判断滑动方向

        Timer{
            id:flicktimer
            interval: 1500;
            repeat: false;
            running: false
            onTriggered: {
                topbtn.visible = false;
            }
        }

        onFlickStarted:
        {
            if(contentY > Style.gHeight && preContentY >contentY){
                topbtn.visible = true;
                flicktimer.stop();
            }
        }

        onMovementEnded: {
            preContentY = contentY;
            flicktimer.restart();
        }

        Column{
            id:column
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20

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
                    text: qsTr("动词短语")
                }
            }

        }
    }

    Component{
        id:explainComponent
        OxfordVerbPhraseComponent{}
    }

    Component{
        id:splitComponent
        Item{
        }
    }

    property var explainCells: new Array
    Component.onCompleted: {
        var pvgs = controlData;
        var pvgItem = pvgs[0];
        var idmNum = 1;
//        console.log(JSON.stringify(pvgItem));
        var pvpgs = pvgItem["pvp_gs"];
        explainCells.push(splitComponent.createObject(column,{width:column.width,height:19}));
        for(var k = 0;k < pvpgs.length;k++){
            var pvpgItem = pvpgs[k];
            for(var i = 0;i < pvpgItem.length;i++){
                var pvpgChildItem = pvpgItem[i];
                explainCells.push(explainComponent.createObject(column,{width:column.width,controlData:pvpgChildItem,idmNum:idmNum}));
                explainCells.push(splitComponent.createObject(column,{width:column.width,height:1}));
                idmNum = idmNum + 1;
            }
        }

    }

    Component.onDestruction: {
        QueryWordManager.playStop();
        var cellCount = explainCells.length;
        for(var i = 0;i < cellCount;i++){
            explainCells.pop().destroy();
        }
    }

    Connections {
        target: scanManager;

        onSig_scanDown:{
            root.destroy();
        }
    }
}
