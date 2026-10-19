import QtQuick 2.0
import QtQuick.Window 2.10
pragma Singleton

QtObject {

    property bool highVersion : false
    //屏幕尺寸
    property int gWidth: highVersion==true?960:800
    property int gHeight: highVersion==true?240:268
    //颜色定义
    property color mainColor: "#12CFA7"             //主色
    property color transMainColor: "#1A12CFA7"      //主色 %10
    property color subColor: "#ff7256"              //辅助色
    property color transSubColor: "#1Aff7256"       //辅助色%10
    property color thirdColor: "#00b9f5"            //次辅助色
    property color transThirdColor: "#1A00b9f5"     //次辅助色%10

    property color mainbgColor: "#0f0f0f"           //背景色
    property color digbgColor: "#3c3d42"             //弹窗背景色
    property color btnOnDigColor: "#74757e"         //弹窗按钮底色

    //不透明度%30 "4D"
    //字体定义
    property int titleFontPixel: 36
    property int normalFontPixel: 28
    property int tipFontPixel:24
    property int mainModePixel : 20
    property color fontColor: "#ffffff"
    //property string fontFamily: "Source Han Sans CN"
    //readonly property string fontFamily: "思源黑体 CN Bold"
    readonly property string fontFamily: "Source Han Sans SC"
    readonly property string engFontFamily: "Inter"
    readonly property string chFontFamily: "Source Han Sans SC"

    readonly property color word_btn_bk_color: "#993C3D42"
    readonly property color word_gray_color: "#FFCECECE"
    readonly property color word_light_color: "#FF12CFA7"

    //设置页面
    readonly property int aviItemWidth : highVersion==true?310:258

    //语音翻译
    readonly property int pen_x : highVersion==true?221:172

    //历史记录和生疏归纳 错题本
    readonly property int itemWidth : highVersion==true? 465 :385

    //扫描查词
    readonly property int scanresult_volume_x: 750
    readonly property int scanresult_volume_y: 171
    readonly property int scanresult_microphone_x: 750
    readonly property int scanresult_microphone_y: 99
    readonly property int scanresult_text_width: 730
    readonly property int scanresult_column_width: 750
    readonly property int scanresult_title_fontSize: 36
    readonly property int scanresult_explain_fontSize: 28
    //拍照页面选取框的上下margin
    readonly property int cameraMarginUpAndDown: 35

    Component.onCompleted:
    {
        console.info("Style.onCompleted",Screen.desktopAvailableHeight)
        if(Screen.desktopAvailableHeight === 960)
        {
            highVersion = true
        }
        else
        {
            highVersion = false
        }

        devManager.setHighVersion(highVersion);
        engineSocket.sendLightChanged(devManager.getLightVal());
    }

}
