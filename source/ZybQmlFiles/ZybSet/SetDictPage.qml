import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "../../"
import "../Style"
import com.zyb.PingDefine 1.0

Rectangle {

    id:root
    color: Style.mainbgColor

    ButtonGroup{
        id:enBtnGroup
        exclusive:true
    }

    ButtonGroup{
        id:chBtnGroup
        exclusive:true
    }

    ButtonGroup{
        id:gradeBtnGroup
        exclusive:true
    }

    Flickable{
        id:flickable
        anchors.fill: parent
        contentHeight: colume.height + 50
        ScrollBar.vertical: ScrollBar {visible: false } //创建一个竖向的滚动条
        clip : true

        Column{
            id:colume
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            spacing: 0
            Item{
                id: header
                width:colume.width
                height: 56
                ZybBackButton{
                    id:backButton
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    onBackClicked: {
                        root.visible = false
                        UILogic.backToSetPage();
                    }
                }


                ZybText {
                    id: title
                    text: qsTr("词典")
                    font.styleName: "Bold"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: backButton.verticalCenter
                }
            }

            Item{
                width:colume.width
                height: 15
            }

            Item{
                id: chItem
                width:colume.width
                height: chRow.height + chtitle.height + 20

                ZybText
                {
                    id: chtitle
                    text: qsTr("扫描汉语时，优先查询的词典")
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    color: "#999999"
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 24
                }

                RowLayout
                {
                    id:chRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: chtitle.bottom
                    anchors.topMargin: 10
                    spacing: 10
                    BasicButton
                    {
                        id:cn
                        text: qsTr("汉语词典")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 20)/2//320
                        implicitHeight: 70
                        radius:6
                        autoExclusive: true

                        onClicked: {
                            var res = new Object;
                            devManager.setSelCurDict(1);
                            res["mode"] = "Ch";
                            pingManager.addPingData(PingDefine.PING_EVENT_SET_SWITCH_DICT,res);
                        }
                    }

                    BasicButton
                    {
                        id:en
                        text: qsTr("汉英词典")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 20)/2//320
                        implicitHeight: 70
                        radius:6

                        autoExclusive: true
                        onClicked: {
                            var res = new Object;
                            devManager.setSelCurDict(0)
                            res["mode"] = "EnCh";
                            pingManager.addPingData(PingDefine.PING_EVENT_SET_SWITCH_DICT,res);
                        }
                    }


                }


            }

            Item{
                width:colume.width
                height: 15
            }

            Item{
                id: enItem
                width:colume.width
                height: enRow.height + entitle.height + 20

                ZybText
                {
                    id: entitle
                    text: qsTr("扫描英语时，优先查询的词典")
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    color: "#999999"
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 24
                }

                GridLayout
                {
                    id:enRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: entitle.bottom
                    anchors.topMargin: 10
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 10

                    BasicButton
                    {
                        id:zyb
                        fontsize: 28
                        text: qsTr("作业帮学生必备词典")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 20)/2//320
                        implicitHeight: 70
                        radius:6
                        autoExclusive: true

                        onClicked: {
                            var res = new Object;
                            devManager.setSelEnCurDict(2);
                            res["mode"] = "zybdict";
                            pingManager.addPingData(PingDefine.PING_EVENT_SET_SWITCH_DICT,res);
                        }
                    }

                    BasicButton
                    {
                        id:enBrief
                        text: qsTr("简明词典")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 20)/2//320
                        implicitHeight: 70
                        radius:6

                        autoExclusive: true
                        onClicked: {
                            var res = new Object;
                            devManager.setSelEnCurDict(0)
                            res["mode"] = "enBrief";
                            pingManager.addPingData(PingDefine.PING_EVENT_SET_SWITCH_DICT,res);
                        }
                    }

                    BasicButton
                    {
                        id:oxford
                        fontsize: 28
                        text: qsTr("牛津高阶英汉双解第九版")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 20)/2//320
                        implicitHeight: 70
                        radius:6
                        autoExclusive: true

                        onClicked: {
                            var res = new Object;
                            devManager.setSelEnCurDict(1);
                            res["mode"] = "oxford";
                            pingManager.addPingData(PingDefine.PING_EVENT_SET_SWITCH_DICT,res);
                        }
                    }



                }


            }

            Item{
                width:colume.width
                height: 15
            }

            Item{
                id: gradeItem
                width:colume.width
                height: chRow.height + chtitle.height + 20

                ZybText
                {
                    id: gradetitle
                    text: qsTr("选择学段，在短语搭配中展示对应学段的内容")
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    color: "#999999"
                    font.family: Style.chFontFamily
                    font.styleName: "Bold"
                    font.pixelSize: 24
                }

                RowLayout
                {
                    id:gradeRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: gradetitle.bottom
                    anchors.topMargin: 10
                    spacing: 10
                    BasicButton
                    {
                        id:xiao
                        text: qsTr("小学")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 30)/3//320
                        implicitHeight: 70
                        radius:6
                        autoExclusive: true

                        onClicked: {
                            var res = new Object;
                            res["grade"] = "primary";
                            pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_GRADE_CLICK,res);
                            devManager.setSelDictGrade(0);
                        }
                    }

                    BasicButton
                    {
                        id:chu
                        text: qsTr("初中")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 30)/3
                        implicitHeight: 70
                        radius:6

                        autoExclusive: true
                        onClicked: {
                            var res = new Object;
                            res["grade"] = "junior";
                            pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_GRADE_CLICK,res);
                            devManager.setSelDictGrade(1);
                        }
                    }

                    BasicButton
                    {
                        id:gao
                        text: qsTr("高中")
                        backgroundTheme: Qt.rgba(18/255,207/255,167/255,0.1)
                        implicitWidth: (colume.width - 30)/3
                        implicitHeight: 70
                        radius:6

                        autoExclusive: true
                        onClicked: {
                            var res = new Object;
                            res["grade"] = "high";
                            pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_GRADE_CLICK,res);
                            devManager.setSelDictGrade(2);
                        }
                    }


                }


            }

        }
    }


    Component.onCompleted:
    {
        var mode = devManager.getSelCurDict();
        en.checked = (mode===0);
        cn.checked = (mode===1);

        var enMode = devManager.getSelEnCurDict();
        enBrief.checked = (enMode===0);
        oxford.checked = (enMode===1);
        zyb.checked = (enMode===2);

        var gradeMode = devManager.getSelDictGrade();
        xiao.checked = (gradeMode===0);
        chu.checked = (gradeMode===1);
        gao.checked = (gradeMode===2);
    }

}
