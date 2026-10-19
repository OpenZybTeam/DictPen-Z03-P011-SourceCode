import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import com.zyb.PingDefine 1.0
Rectangle {

    id:root
    color: Style.mainbgColor

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        onBackClicked: {
            root.visible = false
            UILogic.backToSetPage();
        }

    }


    ZybText {
        id: title
        text: qsTr("左右手切换")
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

    property  var res : new Object;
    RowLayout
    {
        anchors.centerIn: parent;

        BasicButton
        {
            id:questionNaviBtn
            text: qsTr("左手")
            backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
            implicitWidth: 320
            implicitHeight: 70
            radius:6

            autoExclusive: true
            checked: devManager.isLeftHand
            onClicked: {
                devManager.isLeftHand = true;
                res = {};
                res["model"] = "left";
                pingManager.addPingData(PingDefine.PING_EVENT_SET_HAND_SWITCH,res);
            }
        }

        BasicButton
        {
            id:transNaviBtn
            text: qsTr("右手")
            backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
            implicitWidth: 320
            implicitHeight: 70
            radius:6
            autoExclusive: true
            checked: devManager.isLeftHand === false

            onClicked: {
                devManager.isLeftHand = false
                res = {};
                res["model"] = "right";
                pingManager.addPingData(PingDefine.PING_EVENT_SET_HAND_SWITCH,res);
            }
        }
    }


    Component.onCompleted:
    {
        console.info("islefthand =",devManager.isLeftHand);
    }


}
