import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style/"
import "../Funcs/UILogics.js" as UILogic

Popup {
    id: control
    width: 400
    height: 160
    focus: true
    modal: true
    margins: 0
    padding: 0
    topPadding: 0
    visible: false

    property string content: "程序即将关机..."

    background: Rectangle {
        anchors.fill: parent
        color: Style.digbgColor

    }

    FocusScope {
        id: pData
        anchors.fill: parent
        rotation: devManager.isLeftHand ? 180 : 0

        MouseArea
        {
            anchors.fill: parent
            anchors.margins: -16
            onClicked:
            {
                console.debug("电量关闭按钮点击")
                control.close();
            }
        }


        Image
        {
            id:btnClose
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 12
            source: "qrc:/images/close44x44.png"



        }

        ZybText {
            id: text
            anchors.centerIn: parent
            text: content
        }

    }


}
