import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

TResizeBorder {
    id: root
    x: 0
    y: 0
    width: parent.width
    height: parent.height
    readonly property int borderMargin: 6
    readonly property int rotateHandleDistance: 25
    property var controller: parent
    property alias dragEnabled: dragItem.enabled

    signal clicked(real x, real y)
    signal doubleClicked(real x, real y)
    //big
    Rectangle {
        border.color: "#12CFA7"
        border.width:  2
        color: "transparent"
        //color: "black"
        //radius: 0
        anchors.fill: parent
        anchors.margins: borderMargin
    }
    //top left
    Rectangle {
        border.width: 0
        color: "transparent"
        width: 48
        height: 48
        anchors {
            top: parent.top
            left: parent.left
            topMargin: -3
            leftMargin: -3
        }

        Image{
            anchors.fill: parent
            source: "/images/lineTopLeft48.png"
        }
    }

    //top right
    Rectangle {
        border.width: 0
        color: "transparent"
        width: 48
        height: 48
        anchors {
            top: parent.top
            right: parent.right
            topMargin: -3
            rightMargin: -3
        }

        Image{
            anchors.fill: parent
            source: "/images/lineTopRight48.png"
        }
    }

    Rectangle {
        border.width: 0
        color: "transparent"
        width: 48
        height: 48
        anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: -3
            leftMargin: -3
        }

        Image{
            anchors.fill: parent
            source: "/images/lineBottomLeft48.png"
        }
    }
    Rectangle {
        border.width: 0
        color: "transparent"
        width: 48
        height: 48
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: -3
            rightMargin: -3
        }

        Image{
            anchors.fill: parent
            source: "/images/lineBottomRight48.png"
        }
    }

    MouseArea {
        id: dragItem
        anchors.fill: parent
        anchors.margins: borderMargin * 2
        cursorShape: Qt.PointingHandCursor
        drag.target: controller
        onClicked: {
            root.clicked(x, y)
        }
        onDoubleClicked: {
            root.doubleClicked(x, y)
        }
    }


}
