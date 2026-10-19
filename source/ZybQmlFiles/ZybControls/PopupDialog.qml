import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Style/"
import "../Funcs/UILogics.js" as UILogic

Popup {
    id: control
    closePolicy :Popup.NoAutoClose
    width: 600
    height: 190
    focus: true
    modal: true
    margins: 0
    padding: 0
    topPadding: 0
    visible: false


    property bool closeBtnVisible : false
    property color bgColor : Style.digbgColor
    property bool leftTxtVisble : true
    property string content: qsTr("程序即将关机...")
    property int titleFontSize:28
    property bool titleFontBold:false
    property bool content2Visible : false
    property string content2 : ""

    property string leftTxt: qsTr("取消")
    property string rightTxt: qsTr("确定")
    property int dialogMode : 2
    property bool isVertical : false
    property int myRotation : isVertical?(devManager.isLeftHand ? 90 : -90) :(devManager.isLeftHand ? 180 : 0)
    property int btnWidth : 130

    signal leftClicked()
    signal rightClicked()

    background: Rectangle {
        anchors.fill: parent
        color: bgColor
        radius: 10
    }


    FocusScope {
        id: pData
        anchors.fill: parent
        rotation: isVertical?(devManager.isLeftHand ? -90 : 90) :(devManager.isLeftHand ? 180 : 0)
        Image
        {
            id:btnClose
            visible: closeBtnVisible
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 12

            source: "qrc:/images/close44x44.png"

            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -16
                onClicked:
                {
                    control.close();
                }
            }



        }

        ColumnLayout
        {
//            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 28
            spacing: 30

            Text {
                id:t
                text: content
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: titleFontSize
                font.family: Style.fontFamily
                color: Style.fontColor
                font.bold: titleFontBold
            }

            Text {
                id:t2
                text: content2
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: 24
                font.family: Style.fontFamily
                color: Style.fontColor
                visible: content2Visible
            }

            Row{
                Layout.alignment: Qt.AlignCenter
                spacing: 110
                BasicButton{
                    id:cancel
                    text: leftTxt
                    backgroundTheme: Style.btnOnDigColor
                    implicitWidth: btnWidth
                    implicitHeight: 56
                    radius:6
                    checkable: false
                    visible: leftTxtVisble
                    onClicked:
                    {
                        leftClicked();
                    }
                }

                BasicButton{
                    id:reGet
                    text: rightTxt
                    implicitWidth: btnWidth
                    implicitHeight: 56
                    radius:6
                    backgroundTheme: Style.mainColor
                    checkable: false
                    checked: true
                    visible: dialogMode===2
                    onClicked:
                    {
                        rightClicked();
                    }
                }
            }
        }

    }


}
