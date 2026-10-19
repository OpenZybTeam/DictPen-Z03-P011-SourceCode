import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style/"
import "../Funcs/UILogics.js" as UILogic

Popup {
    id: control
    focus: true
    modal: true
    margins: 0
    padding: 0
    topPadding: 0
    visible: false

    property string content: "关机中"

    background: Rectangle {
        anchors.fill: parent
        color: Style.mainbgColor
        rotation: devManager.isLeftHand ? 180 : 0

        RotationImage
        {
            id:popbusyIndicator
            source: "qrc:/images/setLoading46x44.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -15
            visible: true
            running: visible
        }

        ZybText {
            id: text
            anchors.top: popbusyIndicator.bottom
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            text: content
        }

    }


}
