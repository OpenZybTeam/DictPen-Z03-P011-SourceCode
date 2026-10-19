import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0  // 导入这个模块
//qtquickcontrols2\src\imports\controls\Slider.qml
//from Customizing Slider
Slider {
    id: control

    //live: false
    property bool acceptWheel: true //滚轮滑动
    //本来想在原来的基础上增加个opposite direction相反方向的属性
    //奈何handle是和鼠标判定区域挂钩的，所以要做这个的话就不能用原来的handle
    //相当于自己重新组合一个slider控件
    property color handleBorderColor: "black"     //按钮边框颜色
    property color handleNormalColor: "darkCyan"  //按钮颜色
    property color handleHoverColor: Qt.lighter(handleNormalColor)
    property color handlePressColor: Qt.darker(handleNormalColor)
    property color completeColor: "cadetblue"
    property color incompleteColor: "#000000"   //背景颜色

    property string leftImageSource : ""
    property string rightImageSource : ""
    property bool rightImageVisible : false

    /*implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)*/

    implicitWidth: horizontal? 280: 24;
    implicitHeight: horizontal? 24: 280;
    //padding把长条背景挤压
    //padding: horizontal? height/6: width/4;

    handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        //width: control.horizontal?(control.height/2):(control.width)
        width: control.horizontal?(40):(control.width)
        height: control.horizontal?(control.height):(control.width/2)
        radius: 0  //感觉方形比原型更协调点，或许也可以用圆角矩形那种scrollbar的样式
//        color: ""
        color: control.pressed
               ?handlePressColor
               :control.hovered
                 ?handleHoverColor
                 :handleNormalColor
        opacity: 0
        border.width: 0
        border.color: "#00000000"//handleBorderColor
    }

    background: Rectangle {
        id:bg
        //以control.horizontal为例：
        //control.availableHeight为去掉padding的高度
        //所以如果control很高的话，只根据padding来算y可能就贴着上面
        //这时候就需要加一部分(control.availableHeight - height) / 2来对齐
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 200 : 6
        implicitHeight: control.horizontal ? 80 : 200
        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight
        radius: 14
        color: control.incompleteColor
        scale: control.horizontal && control.mirrored ? -1 : 1
        //clip: true

        layer.enabled: true
           layer.effect: OpacityMask {
               maskSource: Rectangle {
                   width: bg.width
                   height: bg.height
                   radius: bg.radius
               }
           }
        //opacity: 0.4
        //用另一个方块分别已完成和未完成的颜色
        RoundRectangle {
            //anchors.fill: parent
            id:val
            radius: 0

            //radiusCorners: (value>=0.9)? (Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop | Qt.AlignBottom):(Qt.AlignLeft | Qt.AlignTop | Qt.AlignBottom)
            //radiusCorners:Qt.AlignLeft | Qt.AlignTop | Qt.AlignBottom
            y: control.horizontal ? 0 : control.visualPosition * parent.height
            //width: control.horizontal ? control.position * parent.width : parent.width
            //width: control.position * parent.width<20? 0 :control.position * parent.width
            width: control.position * parent.width
            height: control.horizontal ? parent.height : control.position * parent.height
            color: "#1DC09E"
            smooth: true

        }

        Image {
            id: leftImg
            source: leftImageSource
            x:18
            y:(parent.height-height)/2
        }

        Image {
            id: rightImg
            source: rightImageSource
            x:control.availableWidth -rightImg.width-18
            y:(parent.height-height)/2
            visible: rightImageVisible
        }
    }

//    onValueChanged:
//    {
//        if(value <= 0.1 || val >=0.9)
//        {
//            val.color = "#000000"
//        }
//        console.log(value)
//    }

    MouseArea{
        anchors.fill: parent
        //避免和handle冲突
        acceptedButtons: Qt.NoButton
        onWheel: {
            if(wheel.angleDelta.y<0){
                control.decrease();
            }else{
                control.increase();
            }
        }
    }
}
