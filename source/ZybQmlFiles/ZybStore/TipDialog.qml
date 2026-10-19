import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"
import "../ZybControls"

Dialog {
    id:root
    modal: true
    parent: Overlay.overlay
    width: 550
    height: 190

    leftPadding: 0; rightPadding: 0; topPadding: 0; bottomPadding: 0
    property var closeBtnVisible: false
    property var strTip: qsTr("确定清空所有内容")
    property alias leftBtnText: can.text
    property alias rightBtnText: mok.text
    property var isOneBtn: true
    signal okClicked;
    signal cancelClicked();

    //使对话框打开时居于中心
    onOpened: {
        x = (parent.width - width)/2
        y = (parent.height - height)/2
    }
    //对话框不可自动关闭
    closePolicy: Popup.NoAutoClose
    standardButtons: Dialog.NoButton

    background: Rectangle{
        color: "#FF3C3D42"
        radius: 10
    }

    Item{
        anchors.fill: parent
        rotation: devManager.isLeftHand ? 180 : 0

        Image {
            id: closeBtn
            width: 44
            height: 44
            anchors.top: parent.top
            anchors.right: parent.right
            visible: closeBtnVisible
            source: "qrc:/images/close44x44.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.close();
                }
            }
        }

        Label
        {
            id:msglab
            text: strTip
            font.pixelSize: 28//Style.tipFontPixel
            font.family: Style.fontFamily
            //font.weight: Font.Bold
            color:Style.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
        }

        Row
        {
            spacing: 110
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 28

            BasicButton
            {
                id:can
                text: qsTr("取消")
                checkable: false
                backgroundColor: Style.btnOnDigColor
                implicitWidth: 130
                implicitHeight: 56
                radius:6
                visible: root.isOneBtn
                onClicked:
                {
                    cancelClicked();
                    //dig.close();
                }
            }

            BasicButton
            {
                id:mok
                text: qsTr("确定")
                checked:true
                backgroundColor: Style.mainColor
                implicitWidth: 130
                implicitHeight: 56
                onClicked:
                {
    //                console.log("ok clicked")
                    okClicked();
                }
            }
        }
    }



}
