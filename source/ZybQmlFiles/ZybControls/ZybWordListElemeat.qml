import QtQuick 2.0
import QtQuick.Controls 2.3

import "../Style"

RoundButton {
    id: control
    hoverEnabled: true
    property var parentView: new Object
    property string btnText: itemText
    property int status: 0
    property var modelData: itemData
    property var isLabelItem: false
    width: contentText.width + 24
    radius: 6

    signal itemClicked(var data,var childIndex);
    signal itemSearch(var strData);

    background: Item{
        Rectangle{
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            color: (isLabelItem || parentView.isAllSent) ?  "transparent" : Style.word_btn_bk_color
            radius: control.radius
        }
    }


    //内容
    contentItem: Item {
        anchors.fill: control
        Text {
            id: contentText
            text: btnText
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            font.pixelSize: 36
            color: control.getTextColor()
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Component.onCompleted: {
        isLabelItem = QueryWordManager.isLabel(modelData["data"]);
    }

    onClicked: {
//        console.log("button clicked+++++++++++++++")
//        if(!isLabelItem){
//            if(parentView.currentIndex === index){
//                parentView.isAllSent = false;
//                if(modelData["isHaveChild"] !== undefined && modelData["isHaveChild"] === true){
//                    var childList = modelData["childList"];
//                    for(var i = 0; i < childList.length;i++){
//                        var childItem = childList[i];
//                        var uiStartX = childItem["ui_startx"];
//                        var uiEndX = childItem["ui_endx"];
//                        if(control.pressX >= uiStartX && control.pressX < uiEndX){
//                            var childIndex = i;
//                            console.log("clicked childIndex:",childIndex,"uiStartX:",uiStartX,"uiEndX:",uiEndX,"pressX:",pressX);
//                            break;
//                        }
//                    }
//                }
//                emit:itemClicked(modelData)
//            }
//            else{
//                parentView.currentIndex = index;
//                emit:itemSearch(modelData["data"])
//            }
//        }
    }

    onFocusChanged: {
        if(!focus){
            control.status = 1;
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
//            console.log("button clicked+++++++++++++++pressX:",mouseX,"ele width",parent.width);
            if(!parentView.isClickble){
                return;
            }
            if(!isLabelItem){
//                console.log("button clicked2")
                if(parentView.currentIndex === index){
//                    console.log("button clicked3")
                    parentView.isAllSent = false;
                    if(modelData["isHaveChild"] !== undefined && modelData["isHaveChild"] === true){
//                        console.log("button clicked4")
                        var childList = modelData["childList"];
                        var childIndex;
                        for(var i = 0; i < childList.length;i++){
                            var childItem = childList[i];
                            var uiStartX = childItem["ui_startx"];
                            var uiEndX = childItem["ui_endx"];

                            if(i === 0){
                                if(mouseX < uiStartX){
                                    childIndex = 0;
                                    break;
                                }
                            }
                            if(i === childList.length-1){
                                if(mouseX > uiEndX){
                                    childIndex = childList.length-1;
                                    break;
                                }
                            }
                            if(mouseX >= uiStartX && mouseX <= uiEndX){
                                childIndex = i;
//                                console.log("clicked childIndex:",childIndex,"uiStartX:",uiStartX,"uiEndX:",uiEndX,"pressX:",mouseX);
                                break;
                            }
                        }
//                        console.log("clicked childIndex:",childIndex,"uiStartX:",uiStartX,"uiEndX:",uiEndX,"pressX:",mouseX);
                        emit:itemClicked(modelData,childIndex)
                    }

                }
                else{
//                    console.log("button clicked5")
                    parentView.currentIndex = index;
                    emit:itemSearch(modelData["data"])
                }
            }
        }
    }

    function getTextColor(){
        if(parentView.currentIndex === index){
            return "#FF12CFA7"
        }
        else{
            return "#FFCECECE";
        }
    }

    function getBackColor(){
        if(control.status === 0 || control.status === 1)
            return "transparent"
        if(control.status === 2 || parentView.currentIndex === index)
            return Style.word_btn_bk_color
    }


}
