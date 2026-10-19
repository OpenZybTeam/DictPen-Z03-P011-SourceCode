import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"

Pane {
    id:digVk

    signal commitInput(string t1)
    signal backToBefore
    //color: "#0F0F0F"
    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }

    function showKeyboard(){
        input.focus = true
        if(digVk.y == Style.gHeight)
        {
            digVk.y -= Style.gHeight
        }
        else
        {
            digVk.y = Style.gHeight
        }
    }

    function hideKeyboard(){
        digVk.y = Style.gHeight
        input.text = ""
    }


    ListModel {
        id:nummodel

        ListElement {
            name: "1"
        }
        ListElement {
            name: "2"
        }
        ListElement {
            name: "3"
        }
        ListElement {
            name: "4"
        }
        ListElement {
            name: "5"
        }
        ListElement {
            name: "6"
        }
        ListElement {
            name: "7"
        }
        ListElement {
            name: "8"
        }
        ListElement {
            name: "9"
        }
        ListElement {
            name: "0"
        }
    }



    RowLayout
    {
        id:top
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        Rectangle
        {
            implicitHeight: 56
            implicitWidth: Style.highVersion ?90:56
            color: "transparent"
            ZybText
            {
                text: qsTr("取消")
                anchors.centerIn: parent
                font.pixelSize: Style.tipFontPixel
            }

            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -15
                onClicked:
                {
                    hideKeyboard();
                    backToBefore();
                }
            }
        }

        Rectangle
        {
            id:middle
            color: Qt.rgba(60/255, 61/255, 66/255, 0.6);
            Layout.fillWidth: true
            height: 56
            radius: 6
            BasicTextInput
            {
                id:input
                anchors.fill: parent
                anchors.leftMargin: 9
                //Layout.fillWidth: true
                tipText :qsTr("请输入手机号")
                backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                focus: true
                font.wordSpacing: 2.15
            }
        }


        Rectangle
        {
            implicitWidth: 90
            implicitHeight: 56
            color: "transparent"
            ZybText
            {
                text: qsTr("提交")
                anchors.centerIn: parent
                font.pixelSize: Style.tipFontPixel
                color: Style.mainColor
            }

            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -15
                onClicked:
                {
                    console.log("input text=",input.text)
                    var t = input.text
                    commitInput(t);
                }
            }
        }
    }


    GridView
    {
        id:numView
        model: nummodel
        width: Style.highVersion ?850:698
        height: 66
        cellWidth: Style.highVersion ?82:66
        cellHeight: 66
        clip: true

        Layout.fillWidth: true
        Layout.fillHeight: true

        anchors.top: top.bottom
        anchors.topMargin: 10
        anchors.left: top.left
        anchors.right: delbtn.left

        Component {
            id:modeldelegate
            BasicButton {
                radius: 6
                text: name
                backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);//Style.digbgColor
                implicitWidth: Style.highVersion ?72:56
                implicitHeight: 56
                checkable: false
                textColor:"white"
                onClicked:
                {
                    input.insert(input.cursorPosition,name)
                }

            }
        }

        delegate: modeldelegate
    }

    NoFocusImageButton
    {
        id:delbtn
//        anchors.left: numView.right
//        anchors.leftMargin: 10
        anchors.top: top.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        implicitWidth: 90
        implicitHeight: 56
        source: "qrc:/images/keydel46x46.png"
        checkable:false
        backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
        onClicked:
        {
            if(input.cursorPosition>0)
            {
                var position = input.cursorPosition-1
                console.log("position=",position)
                var front = input.text.slice(0,input.cursorPosition-1)
                var back = input.text.slice(input.cursorPosition,input.text.length)

                input.text =  front+back;
                input.cursorPosition=position
            }
        }

    }

}
