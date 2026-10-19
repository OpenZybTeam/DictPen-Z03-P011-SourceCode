import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"

RoundButton{
    id:control
    height: 56
    width: 180
    radius:6
    property bool isReport: false
    signal report();

    contentItem: Item{
        anchors.fill: control
        Item {
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: icon.width + 7 + contentText.width
            Image {
                id: icon
                source: control.isReport ? "qrc:/images/error_content2.png" : "qrc:/images/error_content1.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: contentText
                anchors.left: icon.right
                anchors.rightMargin: 7
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 24
                color: "#999999"
                text: control.isReport ? qsTr("已反馈") : qsTr("报错")
            }
        }


    }
    background: Rectangle{
        color: isReport ? "#44454A" : "transparent"//Style.word_btn_bk_color
        radius: 6
        Image {
            id: noreportback
            anchors.fill: parent
            visible: !isReport
            source: "qrc:/images/error_rect.png"
        }
    }

    onClicked: {
        if(!isReport){
            isReport = !isReport
            report();
        }

    }
}
