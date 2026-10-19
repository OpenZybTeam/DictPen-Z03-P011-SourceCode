import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style/"
import "../Funcs/UILogics.js" as UILogic

Popup {
    id: control
    width: text.contentWidth +120
    height: text.contentHeight +90
    focus: true
    modal: true
    margins: 0
    padding: 0
    topPadding: 0
    visible: false

    property string content: qsTr("实时语音通话模式已开，设备耗电量大幅\n增加，如需关闭请到作业帮智能App关闭")
    property string title: "设备电量低于20%"

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

        ZybText {
            id: titleText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            text: title
        }

        Image
        {
            id:btnClose
            anchors.verticalCenter: titleText.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 12
            source: "qrc:/images/close44x44.png"
        }

        ZybText {
            id: text
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titleText.bottom
            anchors.topMargin: 15
            font.pixelSize: 20
            color: "#999999"
            text: content
            lineHeight: 1.2
        }

    }


}
