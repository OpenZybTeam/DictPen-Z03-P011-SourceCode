import QtQuick 2.0
import "../Style"

Item {
    id: root
    width: contentText.width + 4
    property var parentView: new Object
    property string text: itemText
    property int status: 1
    property var modelData: itemData
    signal itemClicked(var data);
    Rectangle {
        id:backGround
        anchors.fill: parent
//        anchors.topMargin: 2
//        anchors.bottomMargin: 2
        anchors.leftMargin: 2
        anchors.rightMargin: 2
//        color: Style.word_btn_bk_color
        color: getBackColor()
        radius: 6
    }

    Text {
        id: contentText
        text: root.text
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 36
        color: getTextColor()
        height: parent.height
    }

    MouseArea{
        anchors.fill: parent

        onClicked: {
            parentView.currentIndex = index;
            if(root.status <= 1){
                root.status = root.status + 1;
            }

            if(root.status === 2){
                emit:itemClicked(modelData)
            }

        }
    }

    Component.onCompleted: {
        //contentText.text = modelData.data
    }

    function getBackColor(){
        if(root.status === 0)
            return "transparent"
        if(root.status === 1 || root.status === 2)
            return "#993C3D42"
    }

    function getTextColor(){
        if(root.status === 0 || root.status === 1)
            return "#FFCECECE"
        if(root.status === 2 || parentView.currentIndex === index)
            return "#FF12CFA7"
    }

}

