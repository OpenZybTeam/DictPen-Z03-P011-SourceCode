import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"




TextInput{
    id: control

    property color backgroundTheme: Style.digbgColor
    property string tipText : qsTr("输入密码")

    color: "#FFFFFF"
    text: qsTr("")
    font.pixelSize: Style.normalFontPixel
    font.family: Style.fontFamily
    horizontalAlignment: TextInput.AlignLeft
    verticalAlignment: TextInput.AlignVCenter
    //默认鼠标选取文本设置为false
    selectByMouse: false

    autoScroll: true

    ZybText {
        id: placeholder
        width: parent.width
        font.pixelSize: 26
        font.family: Style.fontFamily
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: TextInput.horizontalAlignment
        color: "#999999"
        text: tipText
        opacity: !control.text.length && (control.cursorRectangle.x <= 3)
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }

    //截取超出部分
    clip: true
    //默认Text.QtRendering看起来比较模糊
    renderType: Text.NativeRendering
    //文本字符最大允许长度
    maximumLength: 60

    cursorDelegate: Rectangle {
        id: cursorRect
        width: 3
        color: Style.mainColor
        visible:  control.text.length
        Timer {
            running: control.focus
            interval: 750
            repeat: true
            onTriggered: {
                cursorRect.visible = !cursorRect.visible
            }
        }
    }

    onCursorRectangleChanged: {
        if (!control.text.length) {
            placeholder.opacity = Qt.binding(function () {
                return !control.text.length && (control.cursorRectangle.x <= 2)
            })
        }
    }
}




////密码输入框
//TextField{
//    id: control

//    property color backgroundTheme: Style.digbgColor
//    property string tipText : qsTr("输入密码")

//    padding: 8
//    color: "#FFFFFF"
//    text: qsTr("")
//    placeholderText: qsTr("输入密码")
//    //placeholderTextColor: Style.btnOnDigColor
//    horizontalAlignment: TextInput.AlignLeft
//    verticalAlignment: TextInput.AlignVCenter
//    //光标样式是可以自定义的
//    //cursorVisible: focus
//    //默认鼠标选取文本设置为false
//    selectByMouse: false
////    //选中文本的颜色
////    selectedTextColor: "white"
////    //选中文本背景色
////    selectionColor: "black"
////    //超出宽度时开启允许滚动，默认为true
//    autoScroll: true
//    //显示模式：Normal普通文本，Password密码，NoEcho无显示，

//    font{
//        pixelSize: 26
//        family: Style.fontFamily
//        bold: false
//    }
//    //截取超出部分
//    clip: true
//    //默认Text.QtRendering看起来比较模糊
//    renderType: Text.NativeRendering
//    //文本字符最大允许长度
//    maximumLength: 60


//    cursorDelegate: Rectangle {
//        id: cursorRect
//        width: 3
//        color: Style.mainColor

//        Timer {
//            running: control.focus
//            interval: 750
//            repeat: true
//            onTriggered: {
//                cursorRect.visible = !cursorRect.visible
//            }
//        }
//    }


//    background: Rectangle
//    {
//        radius: 6
//        anchors.fill: parent
//        color: backgroundTheme
//    }
//}


//Rectangle{
//    width: 573
//    height: 56
//    radius: 6
//    border.color: textinput_2.activeFocus? Qt.lighter(Style.digbgColor): Style.digbgColor
//    border.width: textinput_2.activeFocus? 0: 0
//    color: Style.digbgColor
//    //密码输入框
//    TextField{
//        id: textinput_2
//        anchors.fill: parent
////        leftPadding: 5
////        rightPadding: 5
//        //padding: 10
//        color: "#999999"
//        text: qsTr(" 输入密码")
//        placeholderText: "Gong Jian Bo"
//        placeholderTextColor: "gray"
//        horizontalAlignment: TextInput.AlignLeft
//        verticalAlignment: TextInput.AlignVCenter
//        //光标样式是可以自定义的
//        //cursorVisible: focus
//        //默认鼠标选取文本设置为false
//        selectByMouse: true
//        //选中文本的颜色
//        selectedTextColor: "white"
//        //选中文本背景色
//        selectionColor: "black"
//        //超出宽度时开启允许滚动，默认为true
//        autoScroll: true
//        //显示模式：Normal普通文本，Password密码，NoEcho无显示，
//        //PasswordEchoOnEdit显示在编辑时输入的字符，否则与相同TextInput.Password
//        //echoMode: TextInput.Password
//        //Password显示的字符，默认是个圆点
//        //passwordCharacter: "*"
//        //Password由普通字符到被特殊符号替换的间隔
//        //passwordMaskDelay: 1000
//        //输入掩码，参照Widgets版本的的QLineEidt::inputMask，类似正则
//        //inputMask: ">XXXXX;*"
//        //输入限制，如IntValidator,DoubleValidator,RegExpValidator
//        //我这里配合maximumLength限制了输入为6个数字
//        validator: RegExpValidator{
//            regExp: /[0-9]+/
//        }
//        //字体的属性也比较多，可以自行看文档
//        font{
//            pixelSize: Style.normalFontPixel
//            family: Style.fontFamily
//            bold: false
//        }
//        //截取超出部分
//        clip: true
//        //默认Text.QtRendering看起来比较模糊
//        renderType: Text.NativeRendering
//        //文本字符最大允许长度
//        maximumLength: 60

//        background: Rectangle
//        {
//            anchors.fill: parent
//            color: Style.digbgColor
//        }
//    }
//}
