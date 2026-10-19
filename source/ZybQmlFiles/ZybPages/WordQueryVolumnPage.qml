import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"

VolumnPage {
    id:root
    anchors.fill: parent

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        onBackClicked: {
            root.destroy();
        }

    }

    Connections {
        target: scanManager;

        onSig_scanDown:{
            root.destroy();
        }
    }

}
