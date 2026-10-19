import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import BtManager.BtStatusDefine 1.0

Rectangle {
    id:storeUI
    color: "#0F0F0F"
    property color thisbgColor: Qt.rgba(60/255, 61/255, 66/255, 0.6)

    signal backClicked()


    ListModel {
        id: setModel
        ListElement { name: qsTr("扫题答疑");icon: "qrc:/images/set_help_scanquestion.png"; circle: false; source: "scanquestion" }
        ListElement { name: qsTr("识题答疑");icon: "qrc:/images/set_help_camera.png"; circle: false; source: "cameraquestion"}
        ListElement { name: qsTr("查词翻译");icon: "qrc:/images/set_help_scanword.png"; circle: false; source: "scanword"}
        ListElement { name: qsTr("语音通话");icon: "qrc:/images/set_help_phone.png"; circle: false; source: "phone"}
    }

    GridView {
        id:view

        anchors.fill: parent
        anchors.topMargin: 10
        anchors.leftMargin: 10

        cellWidth: Style.aviItemWidth; cellHeight: 80
        clip: true

        header:Item {
            id: header
            width: parent.width
            height: 65
            ZybBackButton{
                id:backButton
                anchors.top: parent.top
                //anchors.topMargin: 20
                anchors.left: parent.left
                //anchors.leftMargin: 20
                onBackClicked: {
                    UILogic.backToSetPage();
                }
            }

            ZybText {
                id: title
                text: qsTr("使用帮助")
                font.styleName: "Bold"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: backButton.verticalCenter
            }
        }

        Component {
            id:setDelegate
            MButtonPic {
                radius: 6
                width: Style.aviItemWidth-10
                height: 70
                displayMode:2
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                textColor:Style.fontColor
                fontfamily:Style.fontFamily
                fontsize: Style.normalFontPixel
                //bgColor: GridView.isCurrentItem ? Qt.lighter(thisbgColor) : thisbgColor
                bgColor:  thisbgColor
                text: name
                pic: icon
                haveCircle :circle

                onClicked:
                {

                    if(model.source === "scanquestion"){
                        UILogic.openTipPage("scanquestion")
                    }
                    else if(model.source === "cameraquestion"){
                        UILogic.openTipPage("cameraquestion")
                    }
                    if(model.source === "scanword"){
                        UILogic.openTipPage("scanword")
                    }
                    if(model.source === "phone"){
                        UILogic.openTipPage("phone")
                    }
                }
            }
        }

        model: setModel
        delegate: setDelegate
        focus: true
    }
}
