import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Funcs/ScanViewLogics.js" as ScanViewLogic
import "../Style"
import "../ZybCamera"

Rectangle {
    id:root
    anchors.fill: parent
    color: Style.mainbgColor
    property var scanRes: ""
    signal toNext();
    signal back();
    property int num:0
    property bool btimeout:false
    property string tip: "<b>请<font color=black>扫描</font>内容</b>"

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: false
        z:101
        onBackClicked: {
            ScanViewLogic.gotoScanTipPage();
            root.destroy();
        }
    }


    Connections {
        target: scanManager;

        onSig_scanDown:{
//            root.scanRes = ""
            searchTip.text = ""
            backButton.visible = false;
        }

        onSig_scanUp:{
            if(!visible){
                return;
            }
        }

        onSig_getText:{

            if(main.bReady===false)
                return;
            root.scanRes = str;
            edit.text = str;
        }

        onSig_getTextFinshed:{
            edit.text = str;
            if(!visible){
                return;
            }
            if(main.bReady===false)
                return;
            if(devManager.getSelDictGrade() === 3 ){
                ScanViewLogic.gotoScanTipPage();
                return;
            }
            if(str.length > 0){
                root.scanRes = Segmentation.regularString(str);
                if(root.scanRes.length > 0){
                    ScanViewLogic.goToWordResultPage(root.scanRes,false)
//                    ScanViewLogic.goToWordResultPage(scanManager.getScanResult(),false)
                }
                else{
                    ScanViewLogic.gotoScanTipPage();
                    UILogic.showTip(qsTr("未识别到有效内容"));
                }
            }
            else{
                ScanViewLogic.gotoScanTipPage();
                UILogic.showTip(qsTr("未识别到有效内容"));
            }


        }
    }

    Connections{
        target: engineSocket
        onSig_offScreenKey:{
            if(visible && !scanManager.isScanUp()){
                scanManager.screenOff();
                UILogic.backToHome();
                root.visible = false;
            }
        }
    }

    Flickable {
        id:flick
        anchors.left: backButton.visible ? backButton.right : parent.left
        anchors.leftMargin: backButton.visible ? 10 : 0
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentWidth: parent.width
        contentHeight: edit.contentHeight
        flickableDirection: Flickable.VerticalFlick
        TextEdit {
            id:edit
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 14
            anchors.leftMargin: 19
            anchors.rightMargin: 19
            text: ""
            width: parent.width
            cursorVisible: true
            cursorPosition: length
            cursorDelegate: cursor
            color:Style.mainColor
            font.bold:true
            font.pixelSize:Style.normalFontPixel
            font.family:Style.fontFamily
            wrapMode: TextEdit.Wrap

            Component{
                id:cursor
                Rectangle{
                    id:cursorRect
                    width: 2
                    height: 40
                    color: (num == 1) ? "#OFOFOF" : "white"
                }
            }

            Timer{
                interval: 300;
                repeat: true;
                running: true
                onTriggered: {
                    num = (num == 1) ? 0 : 1
                }
            }


//            MouseArea{
//                anchors.fill: parent
//                onClicked: {
//                    main.showTip(tip)
//                }

//                onDoubleClicked:
//                {
//                    UILogic.backToHome()
//                    main.showTip(tip)
//                }
//            }


        }

        Label {
            id:searchTip
            anchors.top: edit.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 19
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignLeft
            text: ""
            color:Style.fontColor
            font.bold:false
            font.pixelSize:Style.normalFontPixel
            font.family:Style.fontFamily
        }

        onContentHeightChanged: {
            if(flick.contentHeight > flick.height){
                flick.contentY = flick.contentHeight-flick.height;
            }
        }
    }

    onVisibleChanged: {
        if(visible){
//            if(dataManager.getLive() === true){
//                UILogic.openWebSocket(2);
//            }
            if(flick.contentHeight > flick.height){
                flick.contentY = flick.contentHeight-flick.height;
            }
        }
    }
    Component.onCompleted:
    {
        flick.flick(0,edit.contentHeight)
    }
}
