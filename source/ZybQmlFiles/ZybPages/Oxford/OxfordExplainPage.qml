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
                    text: qsTr("释义")
                }
            }

        }
    }

    Component{
        id:explainComponent
        OxfordExplianComponent{}
    }

    Component{
        id:splitComponent
        Item{
        }
    }

    property var explainCells: new Array
    Component.onCompleted: {
        if(controlData["sn_gs"] !== undefined){
            explainCells.push(splitComponent.createObject(column,{width:column.width,height:19}));
            var sngs = controlData["sn_gs"];
            var defNum = 0;
            for(var i = 0;i < sngs.length;i++){
                var sng = sngs[i];
                explainCells.push(explainComponent.createObject(column,{width:column.width,controlData:sng,startNum:defNum}));
                explainCells.push(splitComponent.createObject(column,{width:column.width,height:10}));
                if(sng["explain"] !== undefined){
                    var explains = sng["explain"];
                    defNum = explains.length + defNum;
                }
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
}
