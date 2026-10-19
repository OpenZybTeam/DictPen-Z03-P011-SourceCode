import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Switch{
    id: sw
    width: 200
    height: 48
    property alias leftText: textLeft.text
    property alias rightText: textRight.text


    indicator:Rectangle {
        implicitHeight: sw.height
        implicitWidth: sw.width
        clip: false

        layer.enabled: true
        layer.smooth: true
        layer.samples: 4
        antialiasing: true
        radius: 24
        color: "#3C3D42"
        Rectangle {
          x: sw.checked ? 0 : parent.width - width
          width: 100
          height: sw.height
          radius: sw.height/2
          color: Style.highVersion ? "#12CFA7" : "#04BB95"
      }

        Text {
            id:textLeft
            textFormat: Text.PlainText
            font.pixelSize: 26
            font.family: Style.chFontFamily
            color: sw.checked ? "#FFFFFF" : "#999999"
            font.styleName: "Bold"
            anchors.fill: parent
            anchors.leftMargin: 24

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: "ON"
            antialiasing: true
        }

        Text {
            id:textRight
            textFormat: Text.PlainText
            font.pixelSize: 26
            font.family: Style.chFontFamily
            color: !sw.checked ? "#FFFFFF" : "#999999"
            text: "OFF"
            anchors.rightMargin: 24
            font.styleName: "Bold"
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            antialiasing: true
        }
    }

    MouseArea{
        anchors.centerIn: parent
        height: 100
        width: 200
        onClicked: {
            checked = !checked;
        }
    }
}

