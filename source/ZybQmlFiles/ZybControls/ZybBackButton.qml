import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

Image{
    id :back


    signal backClicked()
    source: "qrc:/images/back56x56.png"
    //opacity: 0.6
    MouseArea{
        anchors.fill: parent
        anchors.margins: -16
        onClicked: {
            backClicked()
        }
    }
}

//Rectangle{
//    id:control
//    height: 56
//    width: 56
//    radius:4
//    contentItem: Item{
//        anchors.fill: control
//        Image {
//            id: icon
//            anchors.centerIn : parent.Center
//            source: "qrc:/images/return48x48.png"
////            anchors.verticalCenter: parent.verticalCenter
//        }
//    }
//    background: Rectangle{
//        color: "#00000000"
//    }
//}
