import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"
import "../../ZybControls"
import com.zyb.PingDefine 1.0

Dialog {
    id:root
    modal: true
    width: 580
    height: 192

    leftPadding: 0; rightPadding: 0; topPadding: 0; bottomPadding: 0
    property var closeBtnVisible: false
    property var strTip: qsTr("确定清空所有内容")
    property var isOneBtn: true
    signal okClicked();
    signal cancelClicked();

    //使对话框打开时居于中心
    onOpened: {
//        x = (parent.width - width)/2
//        y = (parent.height - height)/2
        x=devManager.isLeftHand?(parent.width - (parent.width - width)/2):((parent.width - width) / 2)
        y=devManager.isLeftHand?(parent.height-(parent.height - height) / 2):((parent.height - height) / 2)
    }
    //对话框不可自动关闭
    closePolicy: Popup.NoAutoClose
    standardButtons: Dialog.NoButton

    background: Rectangle{
        color: "#FF3C3D42"
        radius: 10
    }

    Item{
        anchors.fill: parent
        rotation: devManager.isLeftHand ? 180 : 0

        Label
        {
            id:titleStr
            text: qsTr("选择学段")
            font.pixelSize: 28
            font.family: Style.fontFamily
            font.weight: Font.Bold
            color:Style.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 18
        }

        Label
        {
            id:tipStr
            text: qsTr("选择学段，在短语搭配中展示对应学段的内容")
            font.pixelSize: 20
            font.family: Style.fontFamily
            font.weight: Font.Bold
            color:"#FF999999"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titleStr.bottom
            anchors.topMargin: 18
        }

        Row
        {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tipStr.bottom
            anchors.topMargin: 16

            BasicButton
            {
                id:primary
                text: qsTr("小学")
                checkable: false
                backgroundColor: "#1A12CFA7"
                textColor: "#FF12CFA7"
                implicitWidth: 160
                implicitHeight: 70
                fontsize: 28
                radius:6
                visible: root.isOneBtn
                onClicked:
                {
                    var res = new Object;
                    res["grade"] = "primary";
                    pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_GRADE_CLICK,res);
                    devManager.setSelDictGrade(0);
                    devManager.saveConfigFile();
                    okClicked();
                    root.close();
                }
            }

            BasicButton
            {
                id:junior
                text: qsTr("初中")
                checkable: false
                backgroundColor: "#1A12CFA7"
                textColor: "#FF12CFA7"
                implicitWidth: 170
                implicitHeight: 70
                fontsize: 28
                onClicked:
                {
                    var res = new Object;
                    res["grade"] = "high";
                    pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_GRADE_CLICK,res);
                    devManager.setSelDictGrade(1)
                    devManager.saveConfigFile();
                    okClicked();
                    root.close();
                }
            }

            BasicButton
            {
                id:high
                text: qsTr("高中")
                checkable: false
                backgroundColor: "#1A12CFA7"
                textColor: "#FF12CFA7"
                implicitWidth: 170
                implicitHeight: 70
                fontsize: 28
                onClicked:
                {
                    var res = new Object;
                    res["grade"] = "high";
                    pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_GRADE_CLICK,res);
                    devManager.setSelDictGrade(2)
                    devManager.saveConfigFile();
                    okClicked();
                    root.close();
                }
            }
        }
    }



}
