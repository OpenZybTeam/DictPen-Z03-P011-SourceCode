import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybCamera"
import "../ZybControls"
import "./"
import "../ZybPages/ZybDict"

Item {
    id:root
    property alias wordModel: storeList.model
    property string notext: ""
    signal gotoQuestionPage();
    property color bgColor:  "#993C3D42"
    property bool isAllLoaded:true
    property string curWord: ""
    state: "normal"

    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    console.log("normal state")
                    //cancel.visible = false
                }
            }
        },
        State {
            name: "edit"
            StateChangeScript {
                script: {
                    console.log("edit state")
                    //back.visible = false
                }
            }
        }
    ]

    GradeSelectDialog{
        id:gradeDlg
        onOkClicked: {
            UILogic.showWordResView(root.curWord);
        }
    }

    PopupDialog
    {
        id:dig
        x:devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y:devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
        content:qsTr("确定清空所有内容?")
        onLeftClicked:
        {
            dig.close();
        }

        onRightClicked:
        {
            console.log("onOkClicked")
            WordHistoryManager.removeAllHistory();
            root.refreshGridView();
            console.log("root.refreshGridView end")
            root.state = "normal"
            dig.close();
            console.log("onOkClicked end")
        }

    }

    ZybText {
        id: tiptext
        text:  qsTr("还没有历史记录哦") //"还没有收藏的内容哦~"
        font.pixelSize: Style.tipFontPixel
        font.styleName: "Normal"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 25
        z:3
        visible: (storeList.count <= 0 && root.state === "normal")

    }

    Image{
        id : topbtn
        source: "qrc:/images/top66x56.png"
        //visible: view.flicking
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        z:9
        MouseArea{
            anchors.fill: parent
            onClicked: {
                storeList.positionViewAtBeginning()
            }
        }
    }

    Timer{
        id:flicktimer
        interval: 2000;
        repeat: false;
        running: false
        onTriggered: {
            topbtn.visible = false
        }
    }

    Component{
        id:headerComponent
        Item {
            width: storeList.width
            height: 66
            Item
            {
                id:headerItem1
                width: parent.width
                height: 66

                Image{
                    id :back
                    source: "qrc:/images/back56x56.png"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    visible: root.state == "normal"
                    MouseArea{
                        anchors.centerIn: parent
                        width: parent.width + 40
                        height: parent.height + 40
                        onClicked: {
                            UILogic.backToHome();
                        }
                    }
                }


                Text{
                    id :cancel
                    text: "取消"
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.verticalCenterOffset: -10

                    font.pixelSize: Style.tipFontPixel
                    font.weight: Font.Normal
                    font.family: Style.fontFamily
                    color: Style.fontColor
                    visible: root.state === "edit"
                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: -26
                        onClicked: {
                            root.state = "normal"
                        }
                    }
                }

                RowLayout
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    BasicButton
                    {
                        id:transNaviBtn
                        text: qsTr("查词")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: 140
                        implicitHeight: 56
                        radius:6
                        autoExclusive: true
                        fontsize:28
                        checked: true

                        onClicked: {
                        }
                    }

                    BasicButton
                    {
                        id:questionNaviBtn
                        text: devManager.getNetMainTitle()
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: 140
                        implicitHeight: 56
                        radius:6
                        fontsize:28
                        autoExclusive: true
                        checked: false
                        checkable: false

                        onClicked: {
                            root.gotoQuestionPage()
                        }
                    }


                }

                Image{
                    id :del
                    source: "qrc:/images/del26x26.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -10
                    visible: root.state === "normal" && storeList.count > 0
                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: -26
                        onClicked: {
                            root.state = "edit"
                            console.log("del onclicked")
                        }
                    }
                }

                Image{
                    id :clear
                    source: "qrc:/images/clear48x36.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -10
                    visible: root.state === "edit"
                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: -26
                        onClicked: {
                            dig.open();
                        }
                    }
                }


            }
            Item {
                id: headerItem2
                width: parent.width
                height: 10
                anchors.top: headerItem1.bottom
            }

        }

    }

    GridView{
        id:storeList
//        width: parent.width
//        height: 150
        cellWidth: Style.itemWidth; cellHeight: 80
        clip: true
//        anchors.top: parent.top
//        anchors.topMargin: 20
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 5
//        anchors.left: parent.left
//        anchors.leftMargin: 20
        header: headerComponent
        anchors.fill: parent
        anchors.margins: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        model: ListModel{}
        property var footerVisible: false
//        visible: root.state !== "query"

        Component {
            id:wordDelegate
            Rectangle {
                radius: 6
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                width: Style.itemWidth-10
                height: 70
                color: mouseArea.pressed ? Qt.darker(bgColor) : bgColor
                opacity: mouseArea.pressed ? 0.49:1

                MouseArea {
                    id:mouseArea
                    anchors.fill: parent
                    onClicked:
                    {
                        root.curWord = word.text;
                        if(devManager.getSelDictGrade() === 3 && !gradeDlg.opened){
                            gradeDlg.open();
                        }
                        else{
                            UILogic.showWordResView(word.text);
                        }
                    }
                }

                Text {
                    id: word
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 69
                    color: "#FFFFFFFF"
                    font.family: Style.chFontFamily
                    font.styleName: "Normal"
                    font.pixelSize: 28
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    property var createTime: addtime
                    text: wordText
                }

                Image{
                    z:2
                    source: "qrc:/images/close23x23.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 23
                    anchors.verticalCenter:  parent.verticalCenter
                    visible: root.state == "edit"
                    MouseArea{
                        anchors.centerIn: parent
                        height: 70
                        width: 70
                        onClicked: {
//                            console.log("removeHistoryItem")
                            WordHistoryManager.removeHistoryItem(word.text,word.createTime);
                            root.refreshGridView();
                            //var path = view.model.data(index).imagePath;
                        }
                    }
                }
            }
        }

        states: [
            State {
                id: downRefresh
                name: "downRefresh"; when: storeList.atYEnd//loaded===true && (storeList.contentHeight > 0) && (storeList.contentY > (storeList.contentHeight - root.height + nPullHeight))
                StateChangeScript {
                    name: "funDownRefresh"
                    script: funDownRefresh()
                }
            }
        ]
        delegate: wordDelegate
        focus: true

        footer:Rectangle {
            width: storeList.width
            height: 0.7 * storeList.cellHeight
            color: "transparent"
            ZybText {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
                color:"#999999"
                text:qsTr("已经到底")
                visible: storeList.footerVisible
//                visible: root.isAllLoaded===true && (storeList.model.length > 6)
            }

        }


        onFlickStarted:
        {
            topbtn.visible = true
        }

        onFlickEnded:
        {
            flicktimer.restart();
        }

        onAtYEndChanged:
        {
            if(atYEnd)
            {
                //sigEndOfListReached()
                console.log("end Y gridview");
                //发送get历史记录列表
            }
        }
    }

    Component.onCompleted: {
        refreshGridView();
    }

    onVisibleChanged: {
        if(visible)
            refreshGridView();
    }

    Connections{
        target: WordHistoryManager
        onSig_updateWordHistoryList:{
            refreshGridView();
        }
    }

    function refreshGridView(){
        wordModel.clear();
        var storeArray = WordHistoryManager.getHistoryList();
//        console.log(JSON.stringify(storeArray))
        for(var i = 0;i < storeArray.length;i++){
            var tempObj = storeArray[i];
            wordModel.append({"wordText":tempObj["word"],"addtime":tempObj["addtime"]});
        }
        if(storeArray.length > 6){
            storeList.footerVisible  = true;
        }
        else{
            storeList.footerVisible  = false;
        }
    }

    function funDownRefresh(){
//        console.log("contentY at end");
//        WordHistoryManager.getNextPageHistoryList();
    }

}
