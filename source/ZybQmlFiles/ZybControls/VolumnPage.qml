import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../../"
import "../Style"
Rectangle {

    id:root
    color: Style.mainbgColor
    property int num: 0
    signal volmueChanged()

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    ZybText {
        id: title
        text: qsTr("音量")
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
    }

    BasicSlider
    {
        id : volunm
        width: 640
        height: 70
        stepSize: 0.01
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset : 16
        leftImageSource: "qrc:/images/soundoff.png"
        rightImageSource: "qrc:/images/soundon.png"
        rightImageVisible:true
        incompleteColor: "#993C3D42"  //Qt.rgba(60,61,66)
        //opacity: 0.6
        value: devManager.getSoundVal();
        onPositionChanged:
        {
            QueryWordManager.setPcmPlayerVolumn(position);
            engineSocket.sendVolumnChanged(position);

        }

        onPressedChanged:
        {
            num++;
            if(num%2 === 0)
            {
                volmueChanged();
            }
        }
    }

    onVisibleChanged: {
        if(visible){
            volunm.value = devManager.getSoundVal();
            num=0;
        }
    }
}
