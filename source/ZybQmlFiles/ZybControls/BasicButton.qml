import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import "../Style"

Button
{
    id:control

    //可以像源码一样，定义一个全局的样式，然后取全局样式中对应的颜色
    //checked选中状态，down按下状态，hovered悬停状态
    property alias fontsize : btn_text.font.pixelSize
    property color textColor: "#FFFFFF"
    property color backgroundTheme: Style.mainColor
    property alias bgOpacity: bg.opacity
//    property color backgroundColor: control.down
//                                    ? Qt.darker(backgroundTheme)
//                                    : (control.hovered||control.highlighted)
//                                      ? Qt.lighter(backgroundTheme)
//                                      : control.checked
//                                        ? backgroundTheme
//                                        : Style.digbgColor
    property color backgroundColor: control.down
                                    ? Qt.darker(backgroundTheme)
                                    : (control.highlighted)
                                      ? Qt.darker(backgroundTheme)
                                      : control.checked
                                        ? Style.mainColor
                                        : backgroundTheme
    property int radius: 6     //背景rect的圆角

    implicitWidth: 90
    implicitHeight: 56
    leftPadding: 5
    rightPadding: 5
    spacing: 5


    checkable: true

    //按钮中显示的内容
    contentItem: Row{
        id:btn_row
        width: control.width
        spacing: control.spacing
        Image {
            id:btn_icon
            anchors{
                verticalCenter: parent.verticalCenter
            }
            source: control.icon.source //借用icon的接口
        }
        ZybText{
            id:btn_text
            anchors{
                verticalCenter: parent.verticalCenter
            }
            width: btn_icon.width
                   ? btn_row.width-btn_row.spacing-btn_icon.width
                   : btn_row.width
            text: control.text
            color: textColor
            font.family: Style.chFontFamily
            font.styleName: "Bold"
//            font.weight : Font.Medium
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            //wrapMode: Text.NoWrap
            elide: Text.ElideRight

        }
    }

    //背景
    background: Rectangle{
        id:bg
        implicitWidth: control.implicitWidth
        implicitHeight: control.implicitHeight
        radius: control.radius
        //visible: !control.flat || control.down || control.checked || control.highlighted
        color: mouseArea.pressed? Qt.darker(backgroundColor): backgroundColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {

            control.clicked()
            if(checkable)
            {
                console.log("clicked ",control.checkable,control.checked)
                if(control.checked)
                    return;
                control.checked = !control.checked
            }
        }

    }

}

