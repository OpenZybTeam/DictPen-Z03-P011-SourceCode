import QtQuick 2.0
import QtQuick.Controls 2.3
import DevStateMonitor.DevStateDefine 1.0
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybSet/"

Item {
    id:root
    property var tipText: ""
    property var clicktime: 0
    signal back();

    state: "tip"
    states: [
        State {
            name: "tip"
        },

        State {
            name: "loading"
            StateChangeScript {
                script: {

                }
            }
        }
    ]

    MouseArea{
//        anchors.fill: parent
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 200
        height: 200

        onClicked: {
            clicktime = clicktime+1;
            if(clicktime >30)
            {
                vk.showKeyboard();
                clicktime = 0;
            }
        }
    }

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: root.state === "tip"
        onBackClicked: {
            back();
        }
    }

    Text {
        id: tip
        color: "#FFFFFFFF"
        visible: root.state === "tip"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 28
        font.family: Style.chFontFamily
        font.styleName: "Bold"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.tipText
    }

    Item{
        id:loadingItem
//        anchors.fill: parent
        anchors.centerIn: parent
        height: imgLoading.height + 10 + loadtip.height
        width: loadtip.width
        visible: root.state === "loading"
        RotationImage
        {
            id: imgLoading

//            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
            source: "qrc:/images/connecting56x56.png"
            running: root.state === "loading"
            duration: 1000
        }

        Text {
            id: loadtip
            color: "#FFFFFFFF"
            anchors.top:imgLoading.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("设备激活中，请耐心等待")
        }
    }

    SetDebugPage
    {
        id:debugPage
        anchors.fill: parent
        z:10
        visible: false

        onBackToParent:
        {
            visible = false;
            clicktime = 0;
        }
    }

    Connections
    {
        target: vk;
        onCommitInput:
        {
            if(t1 ==  "abort@@zyb#.spee")
            {
                debugPage.visible = true;
            }

        }
    }


    onVisibleChanged: {
        if(visible){
            clicktime = 0;
        }
    }
}
