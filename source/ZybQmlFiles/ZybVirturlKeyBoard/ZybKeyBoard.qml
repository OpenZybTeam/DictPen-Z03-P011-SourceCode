import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"


Pane {
    id:vk

    signal commitInput(string t1)
    //color: "#0F0F0F"
    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }
    //anchors.fill: parent
    Behavior on y {PropertyAnimation {duration: 200} }

    function showKeyboard(){
        //vk.visible = true
        num.checked = true;
        flickable.contentY = 0;
        num.clicked();
        input.text = ""
        input.focus = true
        if(vk.y == Style.gHeight)
        {
            vk.y -= Style.gHeight
        }
        else
        {
            vk.y = Style.gHeight
        }
    }

    function hideKeyboard(){
        vk.y = Style.gHeight

        //vk.visible = false
    }


    ListModel {
        id:bigABCmodel

        ListElement {
            name: "A"
        }
        ListElement {
            name: "B"
        }
        ListElement {
            name: "C"
        }
        ListElement {
            name: "D"
        }
        ListElement {
            name: "E"
        }
        ListElement {
            name: "F"
        }
        ListElement {
            name: "G"
        }
        ListElement {
            name: "H"
        }
        ListElement {
            name: "I"
        }
        ListElement {
            name: "J"
        }
        ListElement {
            name: "K"
        }
        ListElement {
            name: "L"
        }
        ListElement {
            name: "M"
        }
        ListElement {
            name: "N"
        }
        ListElement {
            name: "O"
        }
        ListElement {
            name: "P"
        }
        ListElement {
            name: "Q"
        }
        ListElement {
            name: "R"
        }
        ListElement {
            name: "S"
        }
        ListElement {
            name: "T"
        }
        ListElement {
            name: "U"
        }
        ListElement {
            name: "V"
        }
        ListElement {
            name: "W"
        }
        ListElement {
            name: "X"
        }
        ListElement {
            name: "Y"
        }
        ListElement {
            name: "Z"
        }
    }

    ListModel {
        id:smallABCmodel

        ListElement {
            name: "a"
        }
        ListElement {
            name: "b"
        }
        ListElement {
            name: "c"
        }
        ListElement {
            name: "d"
        }
        ListElement {
            name: "e"
        }
        ListElement {
            name: "f"
        }
        ListElement {
            name: "g"
        }
        ListElement {
            name: "h"
        }
        ListElement {
            name: "i"
        }
        ListElement {
            name: "j"
        }
        ListElement {
            name: "k"
        }
        ListElement {
            name: "l"
        }
        ListElement {
            name: "m"
        }
        ListElement {
            name: "n"
        }
        ListElement {
            name: "o"
        }
        ListElement {
            name: "p"
        }
        ListElement {
            name: "q"
        }
        ListElement {
            name: "r"
        }
        ListElement {
            name: "s"
        }
        ListElement {
            name: "t"
        }
        ListElement {
            name: "u"
        }
        ListElement {
            name: "v"
        }
        ListElement {
            name: "w"
        }
        ListElement {
            name: "x"
        }
        ListElement {
            name: "y"
        }
        ListElement {
            name: "z"
        }
    }

    ListModel {
        id:nummodel

        ListElement {
            name: "0"
        }
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
            name: "."
        }
        ListElement {
            name: ","
        }
        ListElement {
            name: "?"
        }
        ListElement {
            name: "!"
        }
        ListElement {
            name: "'"
        }
        ListElement {
            name: "|"
        }
        ListElement {
            name: "“"
        }
        ListElement {
            name: ":"
        }
        ListElement {
            name: ";"
        }
        ListElement {
            name: "("
        }
        ListElement {
            name: ")"
        }
        ListElement {
            name: "@"
        }
    }

    ListModel {
        id:symbolmodel

        ListElement {
            name: "."
        }
        ListElement {
            name: ","
        }
        ListElement {
            name: "?"
        }
        ListElement {
            name: "!"
        }
        ListElement {
            name: "‘"
        }
        ListElement {
            name: "-"
        }
        ListElement {
            name: "“"
        }
        ListElement {
            name: ":"
        }
        ListElement {
            name: ";"
        }
        ListElement {
            name: "("
        }
        ListElement {
            name: ")"
        }
        ListElement {
            name: "@"
        }
        ListElement {
            name: "$"
        }
        ListElement {
            name: "&"
        }
        ListElement {
            name: "#"
        }
        ListElement {
            name: "*"
        }
        ListElement {
            name: "+"
        }
        ListElement {
            name: "="
        }
        ListElement {
            name: "—"
        }
        ListElement {
            name: "_"
        }
        ListElement {
            name: "'\'"
        }
        ListElement {
            name: "|"
        }
        ListElement {
            name: "/"
        }

        ListElement {
            name: "L"
        }

        ListElement {
            name: "["
        }

        ListElement {
            name: "]"
        }
        ListElement {
            name: "{"
        }
        ListElement {
            name: "}"
        }
        ListElement {
            name: "%"
        }
        ListElement {
            name: "^"
        }
        ListElement {
            name: "<"
        }
        ListElement {
            name: ">"
        }
        ListElement {
            name: "~"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 10
        RowLayout
        {
            spacing: 10
            ZybBackButton
            {
                id:back
                onBackClicked:
                {
                    hideKeyboard();
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
                    tipText :qsTr("请输入密码")
                    backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                    focus: true
                }
            }



            NoFocusImageButton
            {
                id:commit
                implicitWidth: 111
                implicitHeight: 56
                source: "qrc:/images/commit46x46.png"
                checkable:false

                backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                onClicked:
                {
                    console.log("input text=",input.text)
                    var t = input.text
                    commitInput(t);
                    hideKeyboard();
                }
            }
        }


        Flickable {
            id: flickable;
            width: parent.width
            height: Style.highVersion ?180:200;
            contentWidth: parent.width
            contentHeight: Style.highVersion ?260:340
            clip: true
            flickableDirection: Flickable.VerticalFlick

            Layout.fillWidth: true
            //Layout.fillHeight: true


            GridView
            {
                id:keyview
                width: Style.highVersion ?720:548
                height: Style.highVersion ?280:320
                cellWidth: Style.highVersion ?78:78
                cellHeight: 66
                clip: true
                interactive: false
                Layout.fillWidth: true
                Layout.fillHeight: true

                Component {
                    id:modeldelegate
                    BasicButton {
                        radius: 6
                        text: name
                        backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);//Style.digbgColor
                        implicitWidth: Style.highVersion ?70:65
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
                model: smallABCmodel
            }

            Flow
            {
                spacing: 10
                height: contentHeight
                width: 232
                anchors.top: keyview.top
                anchors.right: parent.right
                BasicButton
                {
                    id:samllabc
                    text: qsTr("abc")
                    backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                    implicitWidth: 111
                    implicitHeight: 56
                    textColor:"white"
                    checked: false
                    autoExclusive: true
                    onClicked:
                    {
                        keyview.model = smallABCmodel
                    }
                }

                NoFocusImageButton
                {
                    id:delbtn
                    implicitWidth: 111
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

                BasicButton
                {
                    id:bigabc
                    text: qsTr("ABC")
                    backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                    implicitWidth: 111
                    implicitHeight: 56
                    checked: false
                    autoExclusive: true
                    textColor:"white"
                    onClicked:
                    {
                        keyview.model = bigABCmodel
                    }
                }

                BasicButton
                {
                    id:num
                    text: qsTr("123")
                    backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                    implicitWidth: 111
                    implicitHeight: 56
                    checked: true
                    autoExclusive: true
                    textColor:"white"
                    onClicked:
                    {
                        keyview.model = nummodel
                    }
                }

                BasicButton
                {
                    id:symbol
                    text: qsTr("!@#")
                    backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                    implicitWidth: 111
                    implicitHeight: 56
                    checked: false
                    autoExclusive: true
                    textColor:"white"
                    onClicked:
                    {
                        keyview.model = symbolmodel
                    }
                }

                NoFocusImageButton
                {
                    id:blankbtn
                    implicitWidth: 111
                    implicitHeight: 56
                    source: "qrc:/images/keyblank46x46.png"
                    backgroundTheme: Qt.rgba(60/255, 61/255, 66/255, 0.6);
                    checkable:false
                    onClicked:
                    {
                        input.insert(input.cursorPosition," ")
                    }
                }

                Item
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }


}
