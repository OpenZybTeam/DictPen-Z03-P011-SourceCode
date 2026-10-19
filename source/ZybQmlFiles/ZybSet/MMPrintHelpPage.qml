import QtQuick 2.0
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Rectangle {
    id:root
    anchors.fill: parent
    color: Style.mainbgColor
    signal toNext();

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    ZybBackButton
    {
        id :back
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        z:10
        onBackClicked:
        {
            root.destroy();
        }
    }

    Text{
        id:title
        font.pixelSize: Style.normalFontPixel
        font.family: Style.chFontFamily
        text: qsTr("未发现可连接的设备")
        color: Style.fontColor
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: back.verticalCenter
    }

    Row{
        spacing: 50
        anchors.top: back.bottom
        anchors.topMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter

        Item{
            height: image1.height + 6 + text1.height
            width: image1.width
            Image {
                id: image1
                source: "qrc:/images/mm_nopwer.png"
            }

            Text {
                id:text1
                font.pixelSize: Style.normalFontPixel
                font.family: Style.chFontFamily
                color: Style.fontColor
                text: qsTr("设备未开机或没电")
                anchors.horizontalCenter: image1.horizontalCenter
                anchors.top: image1.bottom
                anchors.topMargin: 6
            }
        }

        Item{
            height: image2.height + 6 + text2.height
            width: image2.width
            Image {
                id: image2
                source: "qrc:/images/mm_toofar.png"
            }

            Text {
                id:text2
                font.pixelSize: Style.normalFontPixel
                font.family: Style.chFontFamily
                color: Style.fontColor
                text: qsTr("设备离的太远")
                anchors.horizontalCenter: image2.horizontalCenter
                anchors.top: image2.bottom
                anchors.topMargin: 6
            }
        }

        Item{
            height: image3.height + 6 + text3.height
            width: image3.width
            Image {
                id: image3
                source: "qrc:/images/mm_nodevice.png"
            }

            Text {
                id:text3
                font.pixelSize: Style.normalFontPixel
                font.family: Style.chFontFamily
                color: Style.fontColor
                text: qsTr("无可用的设备")
                anchors.horizontalCenter: image3.horizontalCenter
                anchors.top: image3.bottom
                anchors.topMargin: 6
            }
        }
    }

}
