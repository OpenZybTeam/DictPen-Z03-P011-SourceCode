import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls"
import "../Style"

Rectangle {
    id:control
    color: "#993C3D42"
    radius: 6

    property alias ltext: ltext.text
    property alias rtext: rtext.text
    property string rcolor: "#FFFFFF"
    property bool imgVisible:false
    property string iconsource : ""
    property bool imageRotation : false

    RowLayout{
        id:rowlayout
        spacing: 8
        //anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 33
        anchors.left: parent.left
        anchors.rightMargin: 33
        anchors.right: parent.right

        ZybText {
            id: ltext
            text: "textLeft"
        }

        Item {
            Layout.fillWidth: true
        }

        ZybText {
            id: rtext
            text: "textRight"
            color: ( rcolor==="#12CFA7" && rtext.text!==qsTr("未登录"))?Style.mainColor:"#FFFFFF"

        }

        RotationImage
        {
            id: img
            source: iconsource
            running: imageRotation
            duration: 1000
        }

//        Image {
//            id: img
//            source: iconsource
//            fillMode: Image.PreserveAspectFit
//            clip: true
//        }

    }

}
