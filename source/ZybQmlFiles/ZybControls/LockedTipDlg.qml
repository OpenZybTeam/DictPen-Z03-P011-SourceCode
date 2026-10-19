import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Dialog {
    id:root
    modal: true
    parent: Overlay.overlay
    width: 550
    height: 190

    leftPadding: 0; rightPadding: 0; topPadding: 0; bottomPadding: 0
    property var closeBtnVisible: false
//    property var strTip: qsTr("确定清空所有内容")
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
        Label
        {
            id:msglab
            text: ""
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            font.pixelSize: 28//Style.tipFontPixel
            font.family: Style.fontFamily
            //font.weight: Font.Bold
            color:Style.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            lineHeight: 1.5
//            anchors.top: parent.top
//            anchors.topMargin: 30
        }
    }

    Component.onCompleted: {
        var tipmesg = "";
        tipmesg += qsTr("设备已被锁定\n");
        tipmesg += qsTr("sn:") + devManager.getSN() + "\n";
        tipmesg += qsTr("请联系客服")
        msglab.text = tipmesg;
    }

}
