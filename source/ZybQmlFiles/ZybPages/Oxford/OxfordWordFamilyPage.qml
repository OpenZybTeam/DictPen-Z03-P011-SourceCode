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

    Flickable{
        id:flickable
        anchors.fill: parent
        contentHeight: column.height + 50
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true

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
                    text: qsTr("词族")
                }
            }

        }
    }

    Component{
        id:explainComponent
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            font.pixelSize: 28
            font.family: Style.engFontFamily
        }
    }

    Component{
        id:splitComponent
        Item{
        }
    }

    property var explainCells: new Array
    Component.onCompleted: {
        var wordFamilys = controlData;
        explainCells.push(splitComponent.createObject(column,{width:column.width,height:19}));
        for(var k = 0;k < wordFamilys.length;k++){
            var wordItem = wordFamilys[k];
            var strText = "";
            if(wordItem["wfw"] !== undefined){
                strText += "<font color=\"#12CFA7\">" + wordItem["wfw"] + "      </font>";
            }
            if(wordItem["wfp"] !== undefined){
                strText += "<font color=\"#BFBFBF\">" + wordItem["wfp"] + ".      </font>";
            }
            if(wordItem["wfo"] !== undefined){
                strText += "<font color=\"#BFBFBF\">(≠" + wordItem["wfo"] + ")</font>";
            }
//            console.log(strText);
            explainCells.push(explainComponent.createObject(column,{width:column.width,text:strText}));
            explainCells.push(splitComponent.createObject(column,{width:column.width,height:10}));
        }
    }

    Component.onDestruction: {
        var cellCount = explainCells.length;
        for(var i = 0;i < cellCount;i++){
            explainCells.pop().destroy();
        }
    }
}
