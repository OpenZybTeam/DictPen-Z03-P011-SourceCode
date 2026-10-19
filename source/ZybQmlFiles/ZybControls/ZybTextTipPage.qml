import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"

Pane {
    id:root

    signal backToParent
    property var pageType: "tippage"
    property string content : "答疑功能已关闭\n请在作业帮智能App上打开后重试"

    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }

    ZybBackButton
    {
        id :back
        onBackClicked:
        {
            backToParent();
        }
    }

    ZybText {
        id:mtext
        anchors.centerIn: parent
        text: content
        font.weight: Font.Normal
        color: "#FFFFFF"
        horizontalAlignment: Text.AlignHCenter
    }
}
