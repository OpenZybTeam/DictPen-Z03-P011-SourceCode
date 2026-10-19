import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Flickable {
    id:root
    contentHeight: colume.height + title.height + 100
    ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
    clip : true
    property var controlData: new Object
    signal back();

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            back();
        }
    }

    Text {
        id: title
        text: qsTr("text")
        font.family: Style.fontFamily
        font.pixelSize: 36
        color: Style.fontColor
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column{
        id:colume
        anchors.top: title.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 27

        Text {
            id: originalTitle
            visible: false
            text: qsTr("正文")
            color: "#22ffff"
            font.pixelSize: 28
            font.bold:true
        }
        Text {
            id: original
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            color: "#FFCECECE"
            font.pixelSize: 28
        }
        Text {
            id: transTitle
            visible: false
            text: qsTr("译文")
            color: "#22ffff"
            font.pixelSize: 28
            font.bold:true
        }
        Text {
            id: trans
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            color: "#FFCECECE"
            font.pixelSize: 28
        }
        Text {
            id: explainTitle
            visible: false
            text: qsTr("注解")
            color: "#22ffff"
            font.pixelSize: 28
            font.bold:true
        }
        Text {
            id: explain
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            color: "#FFCECECE"
            font.pixelSize: 28
        }

        Text {
            id: authorTitle
            visible: false
            text: qsTr("作者简介")
            color: "#22ffff"
            font.pixelSize: 28
            font.bold:true
        }
        Text {
            id: author
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            color: "#FFCECECE"
            font.pixelSize: 28
        }
        Text {
            id: backgroundTitle
            visible: false
            text: qsTr("背景")
            color: "#22ffff"
            font.pixelSize: 28
            font.bold:true
        }
        Text {
            id: background
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            color: "#FFCECECE"
            font.pixelSize: 28
        }
        Text {
            id: analyseTitle
            visible: false
            text: qsTr("评析")
            color: "#22ffff"
            font.pixelSize: 28
            font.bold:true
        }
        Text {
            id: analyse
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            color: "#FFCECECE"
            font.pixelSize: 28
        }
    }

    function setData(data){
        controlData = data;
        if(controlData["title"] !== undefined){
            title.text = controlData["title"];
        }

        if(controlData["original"] !== undefined){
            original.visible = true;
            originalTitle.visible = true;
            original.text = controlData["original"];
        }
        else{
            original.visible = false;
            originalTitle.visible = false;
        }

        if(controlData["trans"] !== undefined){
            trans.visible = true;
            transTitle.visible = true;
            trans.text = controlData["trans"];
        }
        else{
            trans.visible = false;
            transTitle.visible = false;
        }

        if(controlData["explain"] !== undefined){
            explain.visible = true;
            explainTitle.visible = true;
            explain.text = controlData["explain"];
        }
        else{
            explain.visible = false;
            explainTitle.visible = false;
        }

        if(controlData["author"] !== undefined){
            author.visible = true;
            authorTitle.visible = true;
            author.text = controlData["author"];
        }
        else{
            author.visible = false;
            authorTitle.visible = false;
        }

        if(controlData["background"] !== undefined){
            background.visible = true;
            backgroundTitle.visible = true;
            background.text = controlData["background"];
        }
        else{
            background.visible = false;
            backgroundTitle.visible = false;
        }

        if(controlData["analyse"] !== undefined){
            analyse.visible = true;
            analyseTitle.visible = true;
            analyse.text = controlData["analyse"];
        }
        else{
            analyse.visible = false;
            analyseTitle.visible = false;
        }
    }
}
