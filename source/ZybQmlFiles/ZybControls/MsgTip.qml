import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"
Rectangle {
    id: sideTip
    visible: true
    width: Style.gWidth
    height: 72
    color: Style.digbgColor
    x:0
    y:Style.gHeight
    z:1000

    property var animationDuration : 300
    property alias content: text.text
    Text {
        id: text
        anchors.centerIn: parent
        font.pixelSize: Style.tipFontPixel
        font.family: Style.fontFamily
        color: Style.fontColor
        text: "请将题目扫描完整，才能搜索到结果哦~"
    }

    //这是弹窗弹出的效果
    Behavior on y {
        NumberAnimation { //一个动画的类型
            duration: animationDuration //动画持续时间，以ms计算
        }
    }

    onVisibleChanged:
    {
        if(sideTip.visible === true)
        {
            animationDuration = 300
        }
        else
        {
            animationDuration = 1
        }
    }
}
