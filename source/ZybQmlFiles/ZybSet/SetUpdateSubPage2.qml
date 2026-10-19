import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"

Item {
    id:root
    width: parent.width
    height: progressBar.height + 40 + progressText.height + 36 + 10
    property var progressValue: 50
    property var progressIndeterminate: false

    CustomProgressBar{
        id:progressBar
        width: 600
        height: 8
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        value: progressValue
        indeterminate: progressIndeterminate
    }

    Text{
        id:progressText
        anchors.top: progressBar.bottom
        anchors.topMargin: 36
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        font.pixelSize: 28
        color: "#FFFFFFFF"
        text: progressBar.indeterminate ? qsTr("安装中...") : (qsTr("下载中…  ") + progressValue.toFixed(0) + qsTr("%"))
    }


}
