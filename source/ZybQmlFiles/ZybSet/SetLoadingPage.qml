import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls/"
import "../Style"
import "../Funcs/UILogics.js" as UILogic

Rectangle {
    id:root

    color: Style.mainbgColor
    property color itemBgColor: "#993C3D42"
    property string source : "qrc:/images/setLoading46x44.png"
    property alias titleText: title.text
    property bool titleVisible :false
    property bool bottomTextVisible : false
    property alias bottomText: bottomtext.text
    property bool autoHide : false

    signal backClicked


    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            UILogic.backToSetPage()
        }
    }

    ZybText {
        id: title
        text: qsTr("")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

    RotationImage
    {
        id:img
        source: root.source
        anchors.centerIn: parent
    }

//    Image {
//        id: img
//        width: 46
//        height: 44
//        source: root.source
//        anchors.centerIn: parent
//        //rotation: 180

//        RotationAnimation on rotation {
//            id : animation
//            from: 0
//            to: 360
//            duration: 2000
//            loops: Animation.Infinite
//        }
//    }

    ZybText
    {
        id:bottomtext
        text: qsTr("")
        font.pixelSize: Style.tipFontPixel
        anchors.horizontalCenter: img.horizontalCenter
        anchors.top:img.bottom
        anchors.topMargin: 8
    }


    Timer{
        id:hidetimer
        interval: 1500;
        repeat: false;
        running: false
        onTriggered: {
            root.visible = false;
        }
    }

    function hidePage()
    {
        hidetimer.start();
    }

    Component.onCompleted: {
        img.running = true
    }

}
