import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:root
    signal toPre
    signal toNext
    property var pageNum: 0

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: (pageNum > 0)
        z:10
        onBackClicked: {
            if(pageNum > 0){
                pageNum = pageNum - 1;
            }
            else{
                toPre();
            }
        }
    }

    ZybBackButton{
        id:nextButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        rotation: 180
        z:10
        onBackClicked: {
            if(pageNum < 4){
                pageNum = pageNum + 1;
            }
            else{
                toNext();
            }

        }
    }

    Item{
        id: page1
        visible: pageNum === 0
        anchors.fill: parent

        Image {
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 19 : 22
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 48 : 50
            source: Style.highVersion ? "qrc:/images/guide_pic_first_high.png" : "qrc:/images/guide_pic_first_low.png"
        }

        Text{
            id:numText
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 24
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: qsTr("1/5")
        }
    }

    Item{
        id: page2
        visible: pageNum === 1
        anchors.fill: parent

        Text{
            id:page2Title
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 76 : 88
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 32
            font.styleName: "Bold"
            font.family: Style.chFontFamily
            text: qsTr("模式设置")
        }

        Text{
            id:page2Text1
            color: "#FFFFFFFF"
            anchors.top: page2Title.bottom
            anchors.topMargin: Style.highVersion ? 20 : 24
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("查词模式——扫描的文本默认查词翻译")
        }

        Text{
            id:page2Text2
            color: "#FFFFFFFF"
            anchors.top: page2Text1.bottom
            anchors.topMargin: Style.highVersion ? 4 : 4
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("答疑模式——扫描的文本默认匹配答疑")
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 72 : 88
            anchors.right: parent.right
            anchors.rightMargin: Style.highVersion ? 40 : 0
            source: Style.highVersion ? "qrc:/images/guide_pic_second_high.png" : "qrc:/images/guide_pic_second_low.png"
        }

        Text{
            id:numText2
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.left: parent.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: qsTr("2/5")
        }
    }

    Item{
        id: page3
        visible: pageNum === 2
        anchors.fill: parent

        Text{
            id:page3Title
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 76 : 88
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 32
            font.styleName: "Bold"
            font.family: Style.chFontFamily
            text: qsTr("识题答疑")
        }

        Text{
            id:page3Text1
            color: "#FFFFFFFF"
            anchors.top: page3Title.bottom
            anchors.topMargin: Style.highVersion ? 20 : 24
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("点击屏幕功能入口，进入功能页面")
        }

        Text{
            id:page3Text2
            color: "#FFFFFFFF"
            anchors.top: page3Text1.bottom
            anchors.topMargin: Style.highVersion ? 4 : 4
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("按下设备上方按键触发识题答疑")
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 10 : 48
            anchors.right: parent.right
            anchors.rightMargin: Style.highVersion ? 83 : 50
            source: Style.highVersion ? "qrc:/images/guide_pic_third_high.png" : "qrc:/images/guide_pic_third_low.png"
        }

        Text{
            id:numText3
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.left: parent.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: qsTr("3/5")
        }
    }

    Item{
        id: page4
        visible: pageNum === 3
        anchors.fill: parent

        Text{
            id:page4Title
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 76 : 88
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 32
            font.styleName: "Bold"
            font.family: Style.chFontFamily
            text: qsTr("扫题答疑")
        }

        Text{
            id:page4Text1
            color: "#FFFFFFFF"
            anchors.top: page4Title.bottom
            anchors.topMargin: Style.highVersion ? 20 : 24
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("使用笔头扫描题目")
        }

        Text{
            id:page4Text2
            color: "#FFFFFFFF"
            anchors.top: page4Text1.bottom
            anchors.topMargin: Style.highVersion ? 4 : 4
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            text: qsTr("即可显示答疑结果")
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 76 : 102
            anchors.right: parent.right
            anchors.rightMargin: Style.highVersion ?40 : 36
            source: Style.highVersion ? "qrc:/images/guide_pic_fourth_high.png" : "qrc:/images/guide_pic_fourth_low.png"
        }

        Text{
            id:numText4
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.left: parent.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: qsTr("4/5")
        }
    }

    Item{
        id: page5
        visible: pageNum === 4
        anchors.fill: parent

        Text{
            id:page5Title
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 76 : 88
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 32
            font.styleName: "Bold"
            font.family: Style.chFontFamily
            text: qsTr("语音翻译")
        }

        Text{
            id:page5Text1
            color: "#FFFFFFFF"
            anchors.top: page5Title.bottom
            anchors.topMargin: Style.highVersion ? 20 : 24
            anchors.left: parent.left
            anchors.leftMargin: Style.highVersion ? 32 : 32
            font.pixelSize: 24
            font.styleName: "Normal"
            font.family: Style.chFontFamily
            text: qsTr("按住语音键录入音频，支持中英文互译")
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: Style.highVersion ? 28 : 37
            anchors.right: parent.right
            anchors.rightMargin: Style.highVersion ? 100 : 63
            source: Style.highVersion ? "qrc:/images/guide_pic_fifth_high.png" : "qrc:/images/guide_pic_fifth_low.png"
        }

        Text{
            id:numText5
            color: "#FFFFFFFF"
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.left: parent.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            font.family: Style.engFontFamily
            font.styleName: "Normal"
            text: qsTr("5/5")
        }
    }

//    Rectangle {
//        width: 70
//        height: 70
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter
//        color: "red"
//    }

}
