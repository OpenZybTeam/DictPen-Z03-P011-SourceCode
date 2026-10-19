import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import com.zyb.PingDefine 1.0

Item {
    id:root
//    contentHeight: title.height + listenControl.height + 100
//    ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
//    clip : true
    property var controlData: new Object
    property var exampleCells: new Array
    property var wordText: ""
    property var transText: ""
    signal back();
    signal backToFollowStart()



    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            enabled = false;
            QueryWordManager.playStop();
            back();
        }
    }
    Flickable{
        id:titleFlick
        height: 54
        width: (title.width > (parent.width - 183)) ? (parent.width - 183) : (title.width + 5)
        contentWidth: title.width
        anchors.left: backButton.right
        anchors.leftMargin: 22
        anchors.verticalCenter: backButton.verticalCenter
//        anchors.right: parent.right
//        anchors.rightMargin: 20
        ScrollBar.horizontal: ScrollBar {visible: false }
        clip: true
        property var contentCoordX: 0 //记录滚动条位置
        Text {
            id: title
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 36
            font.family: Style.engFontFamily
            font.styleName: "Medium"
            color: "#FF12CFA7"
            text: qsTr("select by examination select by examination select by examination select by examination select by examination")
        }

        Component.onCompleted: {
            contentCoordX = contentX;
        }

        onVisibleChanged: {
            if(visible){
                contentX = contentCoordX;
            }
        }
    }

    ZybMicrophoneButton{
        id: microPhoneButton
        anchors.left: titleFlick.right
        anchors.leftMargin: 16
        anchors.verticalCenter: titleFlick.verticalCenter
        onClicked: {
            enabled = false;
            QueryWordManager.playStop();
            pingManager.addPingData(PingDefine.PING_EVENT_DICT_FOLLOWUP_RE);
//            back();
            backToFollowStart();
        }
    }

    Image {
        id: badge
        anchors.left: backButton.left
        anchors.leftMargin: -4
        anchors.top: backButton.bottom
        anchors.topMargin: 1
        source: "qrc:/images/followup_badge.png"
    }

    ScoreControl{
        id:scoreControl
        anchors.left: badge.right
        anchors.leftMargin: 12
        anchors.top: backButton.bottom
        anchors.topMargin: 24
    }

    ZybSoundPlayButton{
        id:orgSound
        anchors.verticalCenter: scoreControl.verticalCenter
        anchors.left: scoreControl.right
        anchors.leftMargin: 40
        text: qsTr("原音")
        onClicked: {
//            QueryWordManager.playStop();
            pingManager.addPingData(PingDefine.PING_EVENT_DICT_FOLLOWUP_SRC_SPEECH);
            QueryWordManager.play(title.text,2,4)
        }
    }

    ZybSoundPlayButton{
        id:mySound
        anchors.verticalCenter: scoreControl.verticalCenter
        anchors.left: orgSound.right
        anchors.leftMargin: 22
        text: qsTr("我的")
        onClicked: {
//            QueryWordManager.playStop();
            pingManager.addPingData(PingDefine.PING_EVENT_DICT_FOLLOWUP_SELF_SPEECH);
            QueryWordManager.playMp3("/home/userdata/yvyin.mp3");
        }
    }


    Text{
        id:fluency_text
        anchors.left: scoreControl.left
        anchors.top: scoreControl.bottom
        anchors.topMargin: 30
        font.pixelSize: 24
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        color: "#FF999999"
        text: qsTr("流利度：")
    }
    Text{
        id:fluency_score
        anchors.left: fluency_text.right
        anchors.verticalCenter: fluency_text.verticalCenter
        font.pixelSize: 30
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        color: "#FF12CFA7"
        text: "75"
    }

    Text{
        id:accurate_text
        anchors.left: fluency_score.right
        anchors.leftMargin: 56
        anchors.top: scoreControl.bottom
        anchors.topMargin: 30
        font.pixelSize: 24
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        color: "#FF999999"
        text: qsTr("准确度：")
    }
    Text{
        id:accurate_score
        anchors.left: accurate_text.right
        anchors.verticalCenter: accurate_text.verticalCenter
        font.pixelSize: 30
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        color: "#FF12CFA7"
        text: "75"
    }

    Text{
        id:integrity_text
        anchors.left: accurate_score.right
        anchors.leftMargin: 56
        anchors.top: scoreControl.bottom
        anchors.topMargin: 30
        font.pixelSize: 24
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        color: "#FF999999"
        text: qsTr("完整度：")
    }
    Text{
        id:integrity_score
        anchors.left: integrity_text.right
        anchors.verticalCenter: integrity_text.verticalCenter
        font.pixelSize: 30
        font.family: Style.chFontFamily
        font.styleName: "Normal"
        color: "#FF12CFA7"
        text: "75"
    }

    onVisibleChanged: {
        if(visible){
            backButton.enabled = true;
            microPhoneButton.enabled = true;
        }
    }

    function setData(resObj){
        if(resObj["word"] !== undefined){
            title.text = resObj["word"];
        }

        if(resObj["score"] !== undefined){
            scoreControl.setScore(resObj["score"])
        }

        if(resObj["accurate_score"] !== undefined){
            accurate_score.text = resObj["accurate_score"] + qsTr("分")
        }

        if(resObj["integrity_score"] !== undefined){
            integrity_score.text = resObj["integrity_score"] + qsTr("分")
        }

        if(resObj["fluency_score"] !== undefined){
            fluency_score.text = resObj["fluency_score"] + qsTr("分")
        }
    }
}
