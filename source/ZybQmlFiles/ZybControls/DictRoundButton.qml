import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Rectangle {
    id: control
    width: content.width + 40//235
    height: 56
    radius: 28
    color: "#663C3D42"
    property var soundFilePath: ""
    property var soundIndex: -1
    property alias text: contentText.text
    property alias textColor: contentText.color
    property var isHaveSound: true
    signal clicked();

    Item {
        id:content
        height: parent.height
        width: contentText.width + 8
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id:contentText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#FFCECECE"
            font.pixelSize: Style.scanresult_explain_fontSize
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: control.text
        }

    }

    MouseArea{
        width: parent.width
        height: parent.height + 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:parent.verticalCenter
        onClicked: {
            control.clicked();
        }
    }
}

