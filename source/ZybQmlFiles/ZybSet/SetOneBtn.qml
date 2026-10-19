import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Style"

Rectangle {
    id:root
    //anchors.fill: parent
    color: Style.mainbgColor

    property alias  str2: text2.text
    property alias  str1: text1.text
    property alias title: title.text
    property string bottomBtnString : qsTr("退出登录")
    signal backToParent
    signal btnClicked

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            backToParent();
        }
    }

    ZybText {
        id: title
        text: qsTr("登录")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

   Row
   {
       id:crow
       anchors.centerIn: parent
       spacing: 4
       ZybText
       {
           id:text1
           text: qsTr("已登录账号：")
           font.pixelSize: Style.tipFontPixel

       }

       ZybText
       {
           id:text2
           text: qsTr("")
           color: Style.mainColor
           font.pixelSize: Style.tipFontPixel
       }
   }

    BasicButton
    {
        id:btn
        text: bottomBtnString
        backgroundTheme: Style.mainColor
        implicitWidth: 160
        implicitHeight: 56
        radius:6
        checked: true
        backgroundColor: Style.mainColor
        checkable: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 27

        onClicked:
        {
            btnClicked();
        }
    }

}
