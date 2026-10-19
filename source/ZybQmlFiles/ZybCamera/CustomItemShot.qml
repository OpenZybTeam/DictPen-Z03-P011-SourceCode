import QtQuick 2.10
import QtQuick.Dialogs 1.2
import "../Funcs/UILogics.js" as UILogic
import "../Style"
//框选截图工具
//使用时需要anchors.fill目标，并把目标赋值给shotTarget
//pop()初始化显示，close()隐藏
//注意要放在target Item的外部，不然截图组件的影像也被捕获了

//2019-12-21
//设置preventStealing: true防止鼠标事件被偷走
//如在ScrollView或Map中，MouseArea不能正常处理拖动效果
Item {
    id: control
    visible: false

    property bool dragChanged : false
    property int areaMinSize: 35
    property int mouseMargin : -30
    property int indicatorWidth:  48
    property alias areaBorder: shot_area.border
    property alias areaColo: shot_area.color
    property alias shotArea : shot_area

    anchors.topMargin: 0//Style.cameraMarginUpAndDown
    anchors.bottomMargin: 0//Style.cameraMarginUpAndDown

    // 要截图的Item，通过ShaderEffectSource来获取目标区域
    property alias shotTarget: shot_shader.sourceItem

    // 尺寸改变时，避免超出范围
    onWidthChanged: {
        if(shot_area.x+shot_area.width>control.width){
            shot_area.width=control.width-shot_area.x;
        }
    }
    onHeightChanged: {
        if(shot_area.y+shot_area.height>control.height){
            shot_area.height=control.height-shot_area.y;
        }
    }

    function pop(){
        shot_area.x=0;
        shot_area.y=0;
        shot_area.width=control.width;
        shot_area.height=control.height;
        control.visible=true;
    }

    function close(){
        control.visible=false;
    }

    function requestshot(){
        shot_shader.sourceRect=Qt.rect(shot_area.x
                                       ,shot_area.y
                                       ,shot_area.width
                                       ,shot_area.height);
        if(shotTarget){
            console.log("requestshot dragchanged =",dragChanged);
            if(dragChanged)
            {
                console.log("dragChanged:",shot_shader.sourceRect,control.width,control.height)

                //    QRect r;
                //    r.setWidth(rect.width());
                //    r.setHeight(rect.height());
                //    r.setX(rect.x());
                    var r= shot_shader.sourceRect;
                    if(devManager.isLeftHand)
                    {
                        r.y = (Style.gHeight-shot_shader.sourceRect.y-shot_shader.sourceRect.height);
                    }

                console.log("dragChanged convert:",shot_shader.sourceRect,control.width,control.height)
                //    return;
                UILogic.getQuesResult(r,control.width,control.height);
            }
            else
            {
                dataManager.searchCaptureImageResults();
            }
        }
    }

    //用于截图
    ShaderEffectSource{
        id: shot_shader
        visible: false
        anchors.fill: shot_area
        //数据源
        //sourceItem:
        //截图区域
        //sourceRect: shot_area.layer.sourceRect
    }

    //截屏区域
    //这里没有处理和窗口等比缩放
    Rectangle{
        id: shot_area
        implicitWidth: control.width
        implicitHeight: control.height

        color: "transparent"
        border{
            width: 1
            color: Style.mainColor
        }

        MouseArea{
            id: click_area
            anchors.fill: parent
            property int pressPointX: 0
            property int pressPointY: 0
            preventStealing: true
            //anchors.margins: 30
            onPressed: {
                pressPointX=mouse.x;
                pressPointY=mouse.y;
            }

            //onDoubleClicked: control.requestshot();
            onPositionChanged: {
                //判断范围，贴边移动的情况需要细化处理
                if((shot_area.x+mouse.x-pressPointX>0)
                        &&(shot_area.x+shot_area.width+mouse.x-pressPointX<=control.width)){
                    shot_area.x+=mouse.x-pressPointX;
                }
                if((shot_area.y+mouse.y-pressPointY>0)
                        &&(shot_area.y+shot_area.height+mouse.y-pressPointY<=control.height)){
                    shot_area.y+=mouse.y-pressPointY;
                }
            }
        }

        //四角的四个拖动按钮
        Rectangle{
            id: btn_top_left
            border.width: 0
            color: "transparent"
            width: indicatorWidth
            height: width
            anchors {
                top: parent.top
                left: parent.left
                topMargin: -10
                leftMargin: -10
            }

            Image{
                anchors.fill: parent
                source: "/images/lineTopLeft48.png"
            }

            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.margins: mouseMargin
                preventStealing: true
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }
                onPositionChanged: {
                    dragChanged = true;
                    var new_width=shot_area.width-(mouse.x-pressPosX);
                    var new_height=shot_area.height-mouse.y+pressPosY;

                    if(new_width>=control.areaMinSize){
                        shot_area.width=new_width;
                        shot_area.x+=mouse.x-pressPosX;
                        if(shot_area.x<0){
                            shot_area.width+=shot_area.x;
                            shot_area.x=0;
                        }
                    }
                    if(new_height>=control.areaMinSize){
                        shot_area.height=new_height;
                        shot_area.y+=mouse.y-pressPosY;
                        if(shot_area.y<0){
                            shot_area.height+=shot_area.y;
                            shot_area.y=0;
                        }
                    }
                }
            }
        }


        //top
        Rectangle{
            id: btn_top
            border.width: 0
            color: "transparent"
            width: parent.width-(38+30)*2
            height: 1
            anchors {
                top: parent.top
                left: parent.left
                //topMargin: -24
                topMargin: 0
                leftMargin: 38+30
            }

            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.topMargin: mouseMargin
                anchors.bottomMargin: mouseMargin
                preventStealing: true
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }

                onPositionChanged: {
                    dragChanged = true;
                    var new_height=shot_area.height-mouse.y+pressPosY;

                    if(new_height>=control.areaMinSize){
                        shot_area.height=new_height;
                        shot_area.y+=mouse.y-pressPosY;
                        if(shot_area.y<0){
                            shot_area.height+=shot_area.y;
                            shot_area.y=0;
                        }
                    }

                }
            }
        }


        Rectangle{
            id: btn_top_right
            border.width: 0
            color: "transparent"
            width: indicatorWidth
            height: width
            anchors {
                top: parent.top
                right: parent.right
                topMargin: -10
                rightMargin: -10
            }

            Image{
                anchors.fill: parent
                source: "/images/lineTopRight48.png"
            }

            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.margins: mouseMargin
                preventStealing: true
                onPressed:
                {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }

                onPositionChanged: {
                    dragChanged = true;
                    var new_width=shot_area.width+mouse.x-pressPosX;
                    var new_height=shot_area.height-mouse.y+pressPosY;
                    if(new_width>=control.areaMinSize){
                        shot_area.width=new_width;
                        if(shot_area.x+shot_area.width>control.width){
                            shot_area.width=control.width-shot_area.x;
                        }
                    }
                    if(new_height>=control.areaMinSize){
                        shot_area.height=new_height;
                        shot_area.y+=mouse.y-pressPosY;
                        if(shot_area.y<0){
                            shot_area.height+=shot_area.y;
                            shot_area.y=0;
                        }
                    }
                }
            }
        }


        //left
        Rectangle{
            id: btn_left
            border.width: 0
            color: "transparent"
            width: 1
            height: parent.height-(38+30)*2
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 38+30
            }

            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.leftMargin: mouseMargin
                anchors.rightMargin: mouseMargin
                preventStealing: true
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }
                onPositionChanged: {
                    dragChanged = true;
                    var new_width=shot_area.width-mouse.x+pressPosX;
                    if(new_width>=control.areaMinSize){
                        shot_area.width=new_width;
                        shot_area.x+=mouse.x-pressPosX;
                        if(shot_area.x<0){
                            shot_area.width+=shot_area.x;
                            shot_area.x=0;
                        }
                    }
                }
            }
        }


        Rectangle{
            id: btn_bottom_left
            border.width: 0
            color: "transparent"
            width: indicatorWidth
            height: width
            anchors {
                bottom: parent.bottom
                left: parent.left
                bottomMargin: -10
                leftMargin: -10
            }

            Image{
                anchors.fill: parent
                source: "/images/lineBottomLeft48.png"
            }

            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.margins: mouseMargin
                preventStealing: true
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }
                onPositionChanged: {
                    dragChanged = true;
                    var new_width=shot_area.width-(mouse.x-pressPosX);
                    var new_height=shot_area.height+mouse.y-pressPosY;
                    if(new_width>=control.areaMinSize){
                        shot_area.width=new_width;
                        shot_area.x+=mouse.x-pressPosX;
                        if(shot_area.x<0){
                            shot_area.width+=shot_area.x;
                            shot_area.x=0;
                        }
                    }
                    if(new_height>=control.areaMinSize){
                        shot_area.height=new_height;
                        if(shot_area.y+shot_area.height>control.height){
                            shot_area.height=control.height-shot_area.y;
                        }
                    }
                }
            }
        }

        //bottom
        Rectangle{
            id: btn_bottom

            border.width: 0
            color: "transparent"
            width: parent.width-(38+30)*2
            height: 1
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: 38+30
            }


            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.topMargin: mouseMargin
                anchors.bottomMargin: mouseMargin
                preventStealing: true
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }

                onPositionChanged: {
                    dragChanged = true;
                    var new_height=shot_area.height+mouse.y-pressPosY;
                    if(new_height>=control.areaMinSize){
                        shot_area.height=new_height;
                        if(shot_area.y+shot_area.height>control.height){
                            shot_area.height=control.height-shot_area.y;
                        }
                    }
                }
            }
        }


        Rectangle{
            id: btn_bottom_right
            border.width: 0
            color: "transparent"
            width: indicatorWidth
            height: width
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: -10
                rightMargin: -10
            }

            Image{
                anchors.fill: parent
                source: "/images/lineBottomRight48.png"
            }
            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                anchors.margins: mouseMargin
                preventStealing: true
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }
                onPositionChanged: {
                    dragChanged = true;
                    var new_width=shot_area.width+mouse.x-pressPosX;
                    var new_height=shot_area.height+mouse.y-pressPosY;
                    if(new_width>=control.areaMinSize){
                        shot_area.width=new_width;
                        if(shot_area.x+shot_area.width>control.width){
                            shot_area.width=control.width-shot_area.x;
                        }
                    }
                    if(new_height>=control.areaMinSize){
                        shot_area.height=new_height;
                        if(shot_area.y+shot_area.height>control.height){
                            shot_area.height=control.height-shot_area.y;
                        }
                    }
                }
            }
        }


        //right
        Rectangle{
            id: btn_right
            border.width: 0
            color: "transparent"
            width: 1
            height: parent.height-(38+30)*2
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 38+30
            }


            MouseArea{
                property int pressPosX: 0
                property int pressPosY: 0
                anchors.fill: parent
                preventStealing: true
                anchors.margins: mouseMargin
                onPressed: {
                    pressPosX=mouse.x;
                    pressPosY=mouse.y;
                }
                onPositionChanged: {
                    dragChanged = true;
                    var new_width=shot_area.width+mouse.x-pressPosX;
                    if(new_width>=control.areaMinSize){
                        shot_area.width=new_width;
                        if(shot_area.x+shot_area.width>control.width){
                            shot_area.width=control.width-shot_area.x;
                        }
                    }

                }
            }
        }
    }
}
