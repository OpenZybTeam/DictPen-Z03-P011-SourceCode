import QtQuick 2.0
import QtQuick.Controls 2.3

RadioButton
{
    id:root
    property string mytext : ""
    font.styleName: "Normal"
    font.pixelSize: 28
    checked: false
    contentItem:ZybText {
        text: mytext
        font.styleName:root.font.styleName
        font.pixelSize:root.font.pixelSize
        opacity: enabled ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left;
        anchors.leftMargin: 27;
        anchors.verticalCenter: parent.verticalCenter;
    }

    indicator: Image {
        anchors.verticalCenter: parent.verticalCenter;
        source: root.checked?"qrc:/images/radioChecked.png":"qrc:/images/radioUnchecked.png"
    }
}
