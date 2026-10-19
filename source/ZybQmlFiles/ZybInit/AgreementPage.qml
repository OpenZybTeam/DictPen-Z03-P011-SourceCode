import QtQuick 2.0
import QtQuick.Controls 2.3
import DevStateMonitor.DevStateDefine 1.0
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:root
    signal toNext();

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: false
        onBackClicked: {
            if(welText.visible === false){
                agreements.visible = false;
                welText.visible = true;
                agCheckItem.visible = true;
            }
            else{
                devStateMonitor.setDevState(DevStatus.DevState_Normal);
                UILogic.backToHome();
            }

        }
    }

    ZybBackButton{
        id:nextButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        rotation: 180
        visible: checkImage.checked
        onBackClicked: {
            toNext();
        }
    }

    Text {
        id:welText
        y:72
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 28
        color: "white"
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        text: qsTr("欢迎使用作业帮学习笔！")
    }
    Item{
        id: agCheckItem
        anchors.top: welText.bottom
        anchors.topMargin: 48
        anchors.horizontalCenter: parent.horizontalCenter
        width: checkImage.width + 12 + agText.width + 2 + ag2.width
        height: 36
        Image {
            id: checkImage
            property var checked: false
            anchors.left: parent.left
            anchors.verticalCenter: agText.verticalCenter
            width: 32
            height: 32
            source: "qrc:/images/circle_check1.png"
            MouseArea{
                anchors.centerIn: parent
                width: 50
                height: 50
                onClicked: {
                    if(checkImage.checked){
                        checkImage.source = "qrc:/images/circle_check1.png"
                        checkImage.checked = false;
                        checkImage2.source = "qrc:/images/circle_check1.png"
                        checkImage2.checked = false;
                    }
                    else{
                        checkImage.source = "qrc:/images/circle_check2.png"
                        checkImage.checked = true;
                        checkImage2.source = "qrc:/images/circle_check2.png"
                        checkImage2.checked = true;
                        toNext();
                    }
                }
            }
        }
        Text {
            id: agText
            anchors.top: parent.top
            anchors.left: checkImage.right
            anchors.leftMargin: 12
            color: "#FFFFFFFF"
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("同意")

        }
        Text {
            id: ag2
            anchors.top: parent.top
            anchors.left: agText.right
            anchors.leftMargin: 2
            color: "#FF12CFA7"
            font.pixelSize: 24
            font.underline: true
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("用户隐私协议")
            MouseArea{
                anchors.centerIn: parent
                width: parent.width
                height: 70
                onClicked: {
                    welText.visible = false;
                    agCheckItem.visible = false;
                    agreements.visible = true;
                }
            }
        }
    }


    Flickable{
        id:agreements
        anchors.top: backButton.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
//        anchors.fill: parent
        visible: false
        contentHeight: agreementtext.height + bootItem.height
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true
        Text {
            id: agreementtext
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            color: "white"
            wrapMode: Text.WrapAnywhere
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("隐私协议")
        }
        Item{
            id: bootItem
            anchors.top: agreementtext.bottom
            anchors.topMargin: 48
            anchors.horizontalCenter: parent.horizontalCenter
            width: checkImage2.width + 12 + agText2.width + 2 + ag4.width
            height: 36
            Image {
                id: checkImage2
                property var checked: false
                anchors.left: parent.left
                anchors.verticalCenter: agText2.verticalCenter
                width: 32
                height: 32
                source: "qrc:/images/circle_check1.png"
                MouseArea{
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    onClicked: {
                        if(checkImage.checked){
                            checkImage.source = "qrc:/images/circle_check1.png"
                            checkImage.checked = false;
                            checkImage2.source = "qrc:/images/circle_check1.png"
                            checkImage2.checked = false;
                        }
                        else{
                            checkImage.source = "qrc:/images/circle_check2.png"
                            checkImage.checked = true;
                            checkImage2.source = "qrc:/images/circle_check2.png"
                            checkImage2.checked = true;
                            toNext();
                        }
                    }
                }
            }
            Text {
                id: agText2
                anchors.top: parent.top
                anchors.left: checkImage2.right
                anchors.leftMargin: 12
                color: "#FFFFFFFF"
                font.pixelSize: 24
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                text: qsTr("同意")

            }
            Text {
                id: ag4
                anchors.top: parent.top
                anchors.left: agText2.right
                anchors.leftMargin: 2
                color: "#FF12CFA7"
                font.pixelSize: 24
                font.underline: true
                font.family: Style.chFontFamily
                font.styleName: "Normal"
                text: qsTr("用户隐私协议")
                MouseArea{
                    anchors.centerIn: parent
                    width: parent.width
                    height: 70
                    onClicked: {
                        welText.visible = true;
                        agCheckItem.visible = true;
                        agreements.visible = false;
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if(visible){
            agreements.visible = false;
            welText.visible = true;
            agCheckItem.visible = true;
        }
    }
}
