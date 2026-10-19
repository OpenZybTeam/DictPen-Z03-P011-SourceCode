import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Item{
    id:control
    property var isStored: false
    height: 56
    width: 56
    signal clicked();

    Image {
        id: icon
        anchors.centerIn: parent
        source: isStored ? "qrc:/images/store56.png" : "qrc:/images/storeno56.png"  //"qrc:/images/store56.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        anchors.centerIn: parent
        width: 80
        height: 60
        onClicked: {
            control.clicked();
        }
    }
}
