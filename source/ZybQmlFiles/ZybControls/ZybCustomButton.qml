import QtQuick 2.0
import QtQuick.Controls 2.3

RoundButton {
    id: control
    hoverEnabled: true
    font.family: Style.font_notosanscjksc_bold

    property alias iconItem: icon
    property alias textItem: contentText

    //内容
    contentItem: Item {
        anchors.fill: control
        //图标
        Image {
            id: icon
            width: Math.min(control.height/2, control.width/2)
            height: Math.min(control.height/2, control.width/2)
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
