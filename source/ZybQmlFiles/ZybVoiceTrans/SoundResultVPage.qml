import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls"
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import com.zyb.PingDefine 1.0

Rectangle {

    id:control
    property alias src: edit1.text
    property alias des: edit2.text

    property  bool bFormKey : false
    width: Style.gHeight
    height: Style.gWidth
    color: Style.mainbgColor


    signal returnToParent()
    signal volBtnClicked()
    signal timeEnd()

    function speech(text)
    {
        var b = Segmentation.isEnglishStr(text)
        if(b)
        {
            console.log("play speech 1",b);
            QueryWordManager.play(text,0);   //1 是中文
        }
        else
        {
            console.log("play speech 2",b);
            QueryWordManager.play(text,1);
        }

    }

    function autoPlay()
    {
        if(edit2.text.length <= 0)
            return;
        speech(edit2.text);
        sound2.startConnection();
    }


    function scrollToBottom_1()
    {
        if(flick1.contentHeight > flick1.height)
            flick1.contentY = flick1.contentHeight-flick1.height;
    }

    function scrollToTop_1()
    {
            flick1.contentY = 0;
    }

    function scrollToBottom_2()
    {
        if(flick2.contentHeight > flick2.height)
            flick2.contentY = flick2.contentHeight-flick2.height;
    }


    ZybBackButton
    {
        id:back
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10

        onBackClicked: {
            QueryWordManager.playStop();
            if(bFormKey === true)
            {
                UILogic.backToHome();
            }
            else
            {
                returnToParent();
            }
        }
    }

    ZybVolumeButton
    {
        id:volBtn
        anchors.right: parent.right
        anchors.rightMargin: 28
        anchors.verticalCenter: back.verticalCenter

        onClicked:
        {
            volBtnClicked();
        }
    }


    ZybText {
        id: srcText
        text: qsTr("原文")
        font.pixelSize:Style.titleFontPixel
        color: Style.mainColor
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: back.bottom
        anchors.topMargin: 16
    }


    PlayButton
    {
        id:sound1
        anchors.left: srcText.right
        anchors.verticalCenter: srcText.verticalCenter
        anchors.leftMargin: 20
        onPlay:
        {
            console.log("sound1 onplay");
            speech(edit1.text);
            pingManager.addPingData(PingDefine.PING_EVENT_VOICE_TRANS_SRC);
        }

    }

    Flickable {
        id: flick1
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: srcText.bottom
        anchors.topMargin: 10
        width: Style.highVersion ?220:248
        height: Style.highVersion ?360:260
        contentWidth: flick1.width
        contentHeight: edit1.paintedHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar {
            visible: true
            policy: ScrollBar.AsNeeded
            size: flick1.height / edit1.paintedHeight
        } //创建一个竖向的滚动条

        TextEdit {
            id: edit1
            //anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width-15
            height: parent.height
            color: "#FFFFFF"
            font.pixelSize: Style.normalFontPixel
            font.family: Style.fontFamily
            wrapMode: TextEdit.Wrap
            readOnly: true
            text: "为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？"
        }
    }

    ZybText {
        id: desText
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top:flick1.bottom
        anchors.topMargin: 28
        font.pixelSize:Style.titleFontPixel
        color: Style.mainColor
        text: qsTr("译文")
    }

    PlayButton
    {
        id:sound2
        anchors.left: desText.right
        anchors.verticalCenter: desText.verticalCenter
        anchors.leftMargin: 20
        enabled: (edit2.text.length > 0)
        onPlay:
        {
            console.log("sound2 onplay");
            speech(edit2.text);
            pingManager.addPingData(PingDefine.PING_EVENT_VOICE_TRANS_DES);
        }
    }

    Flickable {
        id: flick2
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: desText.bottom
        anchors.topMargin: 10
        width: Style.highVersion ?220:248
        height: Style.highVersion ?360:260
        contentWidth: flick2.width
        contentHeight: edit2.paintedHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar {
            visible: true
            policy: ScrollBar.AsNeeded
            size: flick2.height / edit2.paintedHeight
        } //创建一个竖向的滚动条


        TextEdit {
            id: edit2
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width-15
            height: parent.height
            color: "#FFFFFF"
            font.pixelSize: Style.normalFontPixel
            wrapMode: TextEdit.Wrap
            readOnly: true
            font.family: Style.fontFamily

//            anchors.fill: parent
//            color: "#FFFFFF"
//            font.pixelSize: Style.normalFontPixel
//            wrapMode: TextEdit.Wrap
//            readOnly: true
            text: qsTr("为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？为什么派是无限不循环小数，派的平方等于多少？")
        }

    }



    Rectangle
    {
        id:countdown
        color: "#FF7256"
        opacity: 0.8
        width: 100
        height: width
        radius: width/2
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        y:520

        ZybText
        {
            id:countText
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 60
            text: "37"
        }
    }

    property int lasttime : 0
    Timer
    {
        id:countTimer
        repeat: true
        running: false
        interval: 1000
        onTriggered:
        {
            lasttime++;
            var num =  parseInt(countText.text);
            //console.log("countTimer val",num);
            num--;
            if(num <=5)
            {
                countdown.visible = true;
            }

            countText.text = num.toString();

            if(num === 0)
            {
                stopCountTimer();
                timeEnd();
            }
        }
    }

    function startCountTimer()
    {
        lasttime =0;
        countTimer.start();
        countText.text = "54";
    }

    function stopCountTimer()
    {
        countTimer.stop();
        countdown.visible = false;
    }

    Component.onCompleted:
    {
        edit1.text="";
        edit2.text="";
    }


    Component.onDestruction:
    {
        countTimer.running = false;
    }
}

