import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:root
    height: explainContent.height //+ title.height + 32
    property var controlData: new Object;
    property bool isTitleViseble: true
    property var explainCells: new Array
    signal showDetailed(var data)

    Column{
        id:explainContent
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        width: parent.width
        Text{
            id:toptitle
            visible: root.isTitleViseble
            color: "#FF12CFA7"
            font.pixelSize: 36
            text: qsTr("文言文")
        }
        Item{
            visible: root.isTitleViseble
            height: 10
            width: parent.width
        }
        Item{
            id:titleContent
            height: 42
            width: parent.width
            Text {
                id:titleLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: 28
                color: "#CECECE"
                text: qsTr("出处：")
            }
            Text {
                id: title
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: titleLabel.right
                font.family: Style.chFontFamily
                font.pixelSize: 28
                font.styleName: "Bold"
                color: "#FFFFFF"
                text: qsTr("text")
            }

            Text {
                id:dynastyLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: title.right
                anchors.leftMargin: 9
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: 28
                color: "#CECECE"
                text: qsTr("朝代：")
            }
            Text {
                id: dynasty
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: dynastyLabel.right
                font.family: Style.chFontFamily
                font.pixelSize: 28
                font.styleName: "Bold"
                color: "#FFFFFF"
                text: qsTr("text")
            }

            Text {
                id:autherLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: dynasty.right
                anchors.leftMargin: 9
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                font.pixelSize: 28
                color: "#CECECE"
                text: qsTr("作者：")
            }
            Text {
                id: auther
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: autherLabel.right
                font.family: Style.chFontFamily
                font.pixelSize: 28
                font.styleName: "Bold"
                color: "#FFFFFF"
                text: qsTr("text")
            }

        }

        Item{
            height: 18
            width: parent.width
        }

        Text {
            id: original
            width: parent.width
            font.family: Style.chFontFamily
            font.pixelSize: 28
            wrapMode: Text.WrapAnywhere
            font.styleName: "Bold"
            lineHeight:1.5
            color: "#FFFFFF"
        }

        Item{
            height: 18
            width: parent.width
        }

        ZybSoundPlayButton{
            id:orgPlay
            text: qsTr("原文")
            onClicked: {
                var te = qsTr("君自故乡来，应知故乡事。")
//                console.log("original",original.text);
                QueryWordManager.play(original.text,1);
//                QueryWordManager.play(te,1);

            }
        }

        Item{
            height: 20
            width: parent.width
        }

        Text {
            id: transTitle
            visible: false
            text: qsTr("译文")
            color: "#12CFA7"
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Normal"
        }

        Item{
            height: 10
            width: parent.width
        }

        Text {
            id: trans
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            lineHeight:1.5
            color: "#FFFFFF"
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Normal"
        }

        Item{
            height: 16
            width: parent.width
        }

        Text {
            id: explainTitle
            visible: false
            text: qsTr("注释")
            color: "#12CFA7"
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Normal"
        }
        Item{
            height: 10
            width: parent.width
        }
        Text {
            id: explain
            visible: false
            width: parent.width
            wrapMode: Text.WrapAnywhere
            lineHeight:1.5
            color: "#FFFFFF"
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Normal"
        }

//        Text {
//            id: authorTitle
//            visible: false
//            text: qsTr("作者简介")
//            color: "#22ffff"
//            font.pixelSize: 28
//            font.bold:true
//        }
//        Text {
//            id: author
//            visible: false
//            width: parent.width
//            wrapMode: Text.WrapAnywhere
//            color: "#FFCECECE"
//            font.pixelSize: 28
//        }
//        Text {
//            id: backgroundTitle
//            visible: false
//            text: qsTr("背景")
//            color: "#22ffff"
//            font.pixelSize: 28
//            font.bold:true
//        }
//        Text {
//            id: background
//            visible: false
//            width: parent.width
//            wrapMode: Text.WrapAnywhere
//            color: "#FFCECECE"
//            font.pixelSize: 28
//        }
//        Text {
//            id: analyseTitle
//            visible: false
//            text: qsTr("评析")
//            color: "#22ffff"
//            font.pixelSize: 28
//            font.bold:true
//        }
//        Text {
//            id: analyse
//            visible: false
//            width: parent.width
//            wrapMode: Text.WrapAnywhere
//            color: "#FFCECECE"
//            font.pixelSize: 28
//        }

    }

    Component.onCompleted: {
        var data = controlData[0];
        if(data["title"] !== undefined){
            title.text = qsTr("《") + data["title"] + qsTr("》");
        }

        if(data["auther"] !== undefined){
            auther.text = data["auther"];
        }

        if(data["dynasty"] !== undefined){
            dynasty.text = data["dynasty"];
        }

        if(data["original"] !== undefined){
            original.visible = true;
            original.text = data["original"];
        }
        else{
            original.visible = false;
            originalTitle.visible = false;
        }

        if(data["trans"] !== undefined){
            trans.visible = true;
            transTitle.visible = true;
            trans.text = data["trans"];
        }
        else{
            trans.visible = false;
            transTitle.visible = false;
        }

        if(data["explain"] !== undefined){
            explain.visible = true;
            explainTitle.visible = true;
            explain.text = data["explain"];
        }
        else{
            explain.visible = false;
            explainTitle.visible = false;
        }
    }


    function setData(data){
        controlData = data[0];
        if(controlData["title"] !== undefined){
            title.text = qsTr("《") + controlData["title"] + qsTr("》");
        }

        if(controlData["auther"] !== undefined){
            auther.text = controlData["auther"];
        }

        if(controlData["dynasty"] !== undefined){
            dynasty.text = controlData["dynasty"];
        }

        if(controlData["original"] !== undefined){
            original.visible = true;
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

        if(devManager.getAutoSpeak() === true || devManager.getAutoSpeak()){
//            orgPlay.play();
//            QueryWordManager.play(original.text,1);
        }



//        if(controlData["author"] !== undefined){
//            author.visible = true;
//            authorTitle.visible = true;
//            author.text = controlData["author"];
//        }
//        else{
//            author.visible = false;
//            authorTitle.visible = false;
//        }

//        if(controlData["analyse"] !== undefined){
//            analyse.visible = true;
//            analyseTitle.visible = true;
//            analyse.text = controlData["analyse"];
//        }
//        else{
//            analyse.visible = false;
//            analyseTitle.visible = false;
//        }
    }

//    function setData(data){
//        console.log("wyw setData+++====1")

//        controlData = data;
//        var cell;
//        var cellCount = explainCells.length;
//        for(var i = 0;i < cellCount;i++){
//            cell = explainCells.pop();
//            cell.destroy();
//        }
//        console.log("wyw setData+++====2:",cellCount)
//        var resCount  = data.length;
//        for(i = 0;i < resCount;i++){
//            var contentItem = data[i];
//            if(contentItem["title"] !== undefined && contentItem["original"] !== undefined){
//                var strTitle,strExplain;
//                strTitle = contentItem["title"];
//                strExplain = contentItem["original"];
//                var strExpElide = strExplain.substr(0,40);
//                cell = explainComponent.createObject(explainContent,{titleText: strTitle,briefExplainText:strExpElide,itemData:contentItem})
//                explainCells.push(cell);
//            }
//        }
//    }
}
