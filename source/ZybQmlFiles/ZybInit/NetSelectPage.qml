import QtQuick 2.0
import QtQuick.Controls 2.3
import DevStateMonitor.DevStateDefine 1.0
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    property var tipText: ""
    signal toNext(var is4g);
    signal back();
    property int clickCount;

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: false
        onBackClicked: {
            back();
            clickCount = 0;
            textid.text = ""
        }
    }

    Text{
        id:title
        anchors.top: parent.top
        anchors.topMargin: 24
//        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#FFFFFFFF"
        font.pixelSize: 28
        font.family: Style.chFontFamily
        font.styleName: "Bold"
        text: qsTr("选择联网方式")
    }

    Rectangle{
        id:activeBtn
        width: 144
        height: 56
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        radius: 6
        color: "#1A12CFA7"
        Text {
            anchors.centerIn: parent
            color: "#FF12CFA7"
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            text: qsTr("激活设备")
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                toNext(fgBtn.isSelect);
                clickCount = 0;
                textid.text = ""
            }
        }
    }

    RoundButton{
        id:fgBtn
        radius: 6
        height: 70
        anchors.top: backButton.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5
        property var isSelect: true

        background: Rectangle{
            radius: 6
            color: fgBtn.isSelect ? "#FF12CFA7" : "#1A12CFA7"
        }

        contentItem: Text {
            anchors.centerIn: parent
            color: fgBtn.isSelect ? "#FFFFFFFF" : "#FF12CFA7"
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("移动网络")
        }

        onClicked: {
            if(!isSelect){
                isSelect = true;
                wifiBtn.isSelect = false;
                clickCount = 0;
                textid.text = ""
            }
        }

//        onCheckedChanged: {
//            if(checked){
//                wifiBtn.checked = false;
//            }
//        }
    }

    RoundButton{
        id:wifiBtn
        height: 70
        radius: 6
        anchors.top: backButton.bottom
        anchors.topMargin: 10
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 20
        checkable:true
        checked:false
        property var isSelect: false

        background: Rectangle{
            radius: 6
            color: wifiBtn.isSelect ? "#FF12CFA7" : "#1A12CFA7"
        }

        contentItem: Text {
            anchors.fill: parent
            color: wifiBtn.isSelect ? "#FFFFFFFF" : "#FF12CFA7"
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("无线局域网")
        }

        onClicked: {
            if(!isSelect){
                isSelect = true;
                fgBtn.isSelect = false;
                clickCount = 0;
                textid.text = ""
            }
        }      
    }
    Rectangle{
        id:beterrdebug
        width: 100
        height: Style.gHeight /2-20
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: fgBtn.bottom
        anchors.topMargin: 10
        color: "#1A12CFA7"

        Text {
            id:textid
            //anchors.centerIn: parent
            anchors.top: parent.left
            anchors.left: parent.left
            color: "#FF12CFA7"
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Bold"
            text: qsTr("")
            visible: false;
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                clickCount ++;
                console.log("beterrdebug click-whb:",clickCount);

                if(clickCount === 6){
                    clickCount = 0;

                    var sdata = devManager.getberret("/sys/class/power_supply/sc27xx-fgu/has_counted");
                    if(sdata === "0\n"){
                        textid.text = "NA";
                        textid.visible = true;

                    }else if(sdata === "1\n"){
                        sdata = devManager.getberret("/sys/class/power_supply/sc27xx-fgu/temp_cap");
                        textid.text = sdata;
                        textid.visible = true

                    }
                }
            }
        }
    }

    Rectangle{
        id:beterrhide
        width: Style.gWidth /2
        height: Style.gHeight /2-20
        anchors.left: beterrdebug.right
        anchors.leftMargin: 0
        anchors.top: wifiBtn.bottom
        anchors.topMargin: 10
        color: "#1A12CFA7"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log("beterrhide click=======whb:");
                clickCount = 0
                textid.visible = false

            }
        }
    }
}
