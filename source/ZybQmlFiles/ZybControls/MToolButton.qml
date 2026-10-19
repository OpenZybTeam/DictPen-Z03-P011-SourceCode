import QtQuick 2.0
import "../Style"
Item {
    id: rec

    property alias pix: icon.source
    property alias txt: button.text
    property alias tmouseArea : mouseArea
    property color bgColor: Qt.rgba(153/255,153/255,153/255,0.1)
    //activeFocusChanged:
    //自定义点击信号
    signal myclicked()

    //color: mouseArea.pressed ? Qt.lighter(bgColor) : bgColor
    //color:  "transparent"
 //   opacity: mouseArea.pressed ? 0.49:1

    opacity: mouseArea.containsMouse ? 0.49:1

    Image {
        id: icon
        fillMode: Image.PreserveAspectFit
        clip: true
        anchors.top: parent.top
        anchors.topMargin: 0
        //anchors.horizontalCenter: parent.horizontalCenter
    }

    ZybText {
        id: button
        anchors.top: icon.bottom
        anchors.topMargin: Style.highVersion?12:16
        anchors.horizontalCenter: icon.horizontalCenter
        font.pixelSize: 26
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        //preventStealing : true
        onClicked: {
            //console.time("button clicked")
            myclicked()
            //console.timeEnd("button clicked")
            //mouse.accepted = true;
        }

//        onPressed:
//        {
//            console.log("onPressed");
//            //mouse.accepted = false;
//        }

//        onReleased:
//        {
//            mouse.accepted = false;
//            //console.log("onReleased");
//        }
    }
}

