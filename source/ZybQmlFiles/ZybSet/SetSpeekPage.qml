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
        text: qsTr("发音")
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

    property  var res : new Object;

    BasicSwitchButton
    {
        id:switchButton
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: backButton.verticalCenter
        //state: "on"
        onModelChanged:
        {
            devManager.setAutoSpeak(mode);
            res = {};
            res["model"] = mode?"on":"off";
            pingManager.addPingData(PingDefine.PING_EVENT_SET_AUTO_SPEECH_SWITCH,res);
        }
    }


    Text
    {
        text: qsTr("自动发音")
        color: "#999999"
        font.pixelSize: 24
        anchors.right: switchButton.left
        anchors.rightMargin: 13
        anchors.verticalCenter: backButton.verticalCenter
    }


    RowLayout
    {
        anchors.centerIn: parent;

        BasicButton
        {
            id:speak_american
            text: qsTr("美音")
            backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
            implicitWidth: 320
            implicitHeight: 70
            radius:6

            autoExclusive: true
            onClicked: {
                devManager.setSpeekMode(0)
                res = {};
                res["model"] = "us";
                pingManager.addPingData(PingDefine.PING_EVENT_SET_AUTO_SPEECH_ENG,res);
            }
        }

        BasicButton
        {
            id:speek_eng
            text: qsTr("英音")
            backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
            implicitWidth: 320
            implicitHeight: 70
            radius:6
            autoExclusive: true
            //checked: devManager.getHandMode() === 1

            onClicked: {
                devManager.setSpeekMode(1)
                res = {};
                res["model"] = "eng";
                pingManager.addPingData(PingDefine.PING_EVENT_SET_AUTO_SPEECH_ENG,res);
            }
        }
    }


    Component.onCompleted:
    {
        var mode = devManager.getSpeekMode();
        speak_american.checked = (mode===0);
        speek_eng.checked = (mode===1);
        switchButton.state = (devManager.getAutoSpeak()===true?"on":"off");
    }

}
