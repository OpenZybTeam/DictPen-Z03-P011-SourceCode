import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:root
    signal toNext();
    signal toPre();

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            toPre();
        }
    }

    ZybBackButton{
        id:nextButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        rotation: 180
        onBackClicked: {
            toNext();
        }
    }

    Text {
        id: tip
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 38
        color: "white"
        font.family: Style.chFontFamily
        font.styleName: "Bold"
        text: qsTr("必须联网激活后设备才能正常使用")
    }

}
