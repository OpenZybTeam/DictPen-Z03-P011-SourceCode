import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import "../Style"

RoundButton
{
    id:control

    property bool bold:true
    property int fontsize : Style.normalFontPixel
    property color fontcolor : Style.fontColor
    property alias mtext : btn_text.text
    property color backgroundTheme: Style.btnOnDigColor
    property color backgroundColor: control.checked ? Style.mainColor: backgroundTheme

    property var mouse_margin : -9
    signal seemClicked()

    implicitWidth: 56
    implicitHeight: implicitWidth
    radius: implicitWidth/2

    checkable: true

    contentItem: Text{
            id:btn_text
            font.pixelSize: fontsize
            anchors.centerIn: control
            font.family: Style.fontFamily
            //font.bold: bold
            font.styleName: "Bold"
            text: mtext
            color: fontcolor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            //wrapMode: Text.NoWrap
            elide: Text.ElideRight
    }

    background: Rectangle{
        id:bg
        anchors.fill: parent
        radius: control.radius
        color: backgroundColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: mouse_margin
        onClicked: {

            console.log("basic round button clicked",mtext);
            if(checked)
            {
                seemClicked();
                return;
            }
            else
            {
                control.clicked()
                checked = true;
            }

        }
    }

}

