import QtQuick 2.0
import QtQuick.Controls 2.3

import "../Style"

RoundButton {
    id: control
    hoverEnabled: true
    checkable: false
//    checked: false
    //font.family: Style.font_notosanscjksc_bold
    property alias textItem: contentText
    property var isAllsent: true
    radius: 6

    background: Rectangle{
        color: Style.word_btn_bk_color
        radius: control.radius
    }//Style.word_btn_bk_color

    //内容
    contentItem: Item {
        anchors.fill: control
        Text {
            id: contentText
            text: qsTr("text")
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            color:control.isAllsent ? Style.word_light_color : Style.word_gray_color
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

//    onClicked: {
//        control.focus = !control.focus;
//    }


}
