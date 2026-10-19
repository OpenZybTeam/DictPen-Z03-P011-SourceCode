import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Item{
    id:control
    height: 56
    width: 56
    signal clicked();

    Image {
        id: icon
        anchors.centerIn: parent
        source: "qrc:/images/volume.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        anchors.centerIn: parent
        width: 80
        height: 80
        onClicked: {
            control.clicked();
        }
    }
}
