import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import com.zyb.PingDefine 1.0

VolumnPage
{
    id:root;
    z:8
    visible: false;
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

    onVolmueChanged:
    {
        pingManager.addPingData(PingDefine.PING_EVENT_SET_CHANGE_VOLUME);
    }
}

