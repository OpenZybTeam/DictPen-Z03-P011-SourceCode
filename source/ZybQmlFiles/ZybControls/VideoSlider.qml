import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

//音量调节Slider
Rectangle {
    id:volume
    implicitWidth: 206
    implicitHeight: 28
    radius: 19
    color: "#000000"
    property alias slider: control
    property alias imgSource: img.source
    opacity: 0.3

    Image {
        id: img

        width: 18
        height: 18
        anchors.left: parent.left
        anchors.leftMargin: 8

        anchors.verticalCenter: parent.verticalCenter
        source: imgSource
    }

    Slider{
        id: control
        //anchors.centerIn: parent
        anchors.verticalCenter:  img.verticalCenter
        anchors.left: img.right
        anchors.leftMargin: 8
        implicitWidth: 160;
        implicitHeight: 2;
        orientation:Qt.Horizontal
        padding: 0

        background: Rectangle {
            implicitWidth: control.implicitWidth
            implicitHeight: control.implicitHeight
            color: "#FFFFFF"
            opacity: 0.4
            //radius: 2

            Rectangle {
                y: control.horizontal ? 0 : control.visualPosition * parent.height
                width: control.horizontal ? control.position * parent.width : parent.width
                height: control.horizontal ? parent.height : control.position * parent.height
                color: "#12CFA7"
                radius:1
            }
        }

        handle: Item {
            x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
            y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
            //width: control.horizontal?control.height:control.width
            //height: control.horizontal?control.height:control.width
            implicitWidth: 0
            implicitHeight: 0
            Rectangle{
                id:rect_out
                anchors.fill: parent
                radius: width/2
                color:Qt.rgba(175/255,175/255,175/255,1)
            }

        }
    }

}
