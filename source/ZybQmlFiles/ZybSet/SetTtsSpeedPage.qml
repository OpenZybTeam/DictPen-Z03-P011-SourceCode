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
                    text: qsTr("语速")
                    font.styleName: "Bold"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: backButton.verticalCenter
                }
            }

            Item{
                width:colume.width
                height: 24
            }

            Item{
                id: enItem
                width:colume.width
                height: enRow.height

                RowLayout {
                    id:enRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: enItem.top
                    anchors.topMargin: 0
                    spacing: 0

                    ZybText {
                        id: enTitle
                        text: qsTr("英文语速：")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                    }

                    Item{
                        width:79
                        height: 24
                    }

                    BasicRaidoButton
                    {
                        id: enSlow
                        checked: devManager.getLightIndex() === 1
                        mytext: qsTr("慢速")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                        autoExclusive: true

                        onToggled:
                        {
                            if(checked === true)
                            {
                                devManager.setEnTtsSpeed(0);
                                var res = new Object;
                                res["language"] = "en";
                                res["speed"] = "slow";
                                pingManager.addPingData(PingDefine.PING_EVENT_TTS_SPEED_CHANGED,res);
                            }
                        }
                    }

                    Item{
                        width:123
                        height: 24
                    }

                    BasicRaidoButton
                    {
                        id: enMid
                        checked: devManager.getLightIndex() === 1
                        mytext: qsTr("适中")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                        autoExclusive: true
                        onToggled:
                        {
                            if(checked === true)
                            {
                                devManager.setEnTtsSpeed(1);
                                var res = new Object;
                                res["language"] = "en";
                                res["speed"] = "mid";
                                pingManager.addPingData(PingDefine.PING_EVENT_TTS_SPEED_CHANGED,res);
                            }
                        }
                    }

                    Item{
                        width:123
                        height: 24
                    }

                    BasicRaidoButton
                    {
                        id: enFast
                        checked: devManager.getLightIndex() === 1
                        mytext: qsTr("快速")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                        autoExclusive: true

                        onToggled:
                        {
                            if(checked === true)
                            {
                                devManager.setEnTtsSpeed(2);
                                var res = new Object;
                                res["language"] = "en";
                                res["speed"] = "fast";
                                pingManager.addPingData(PingDefine.PING_EVENT_TTS_SPEED_CHANGED,res);
                            }
                        }
                    }
                }


            }

            Item{
                width:colume.width
                height: 30
            }

            Item{
                id: chItem
                width:colume.width
                height: chRow.height

                RowLayout {
                    id:chRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: chItem.top
                    anchors.topMargin: 0
                    spacing: 0

                    ZybText {
                        id: chTitle
                        text: qsTr("中文语速：")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                    }

                    Item{
                        width:79
                        height: 24
                    }

                    BasicRaidoButton
                    {
                        id: chSlow
                        checked: devManager.getLightIndex() === 1
                        mytext: qsTr("慢速")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                        autoExclusive: true

                        onToggled:
                        {
                            if(checked === true)
                            {
                                devManager.setChTtsSpeed(0);
                                var res = new Object;
                                res["language"] = "ch";
                                res["speed"] = "slow";
                                pingManager.addPingData(PingDefine.PING_EVENT_TTS_SPEED_CHANGED,res);
                            }
                        }
                    }

                    Item{
                        width:123
                        height: 24
                    }

                    BasicRaidoButton
                    {
                        id: chMid
                        checked: devManager.getLightIndex() === 1
                        mytext: qsTr("适中")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                        autoExclusive: true
                        onToggled:
                        {
                            if(checked === true)
                            {
                                devManager.setChTtsSpeed(1);
                                var res = new Object;
                                res["language"] = "ch";
                                res["speed"] = "mid";
                                pingManager.addPingData(PingDefine.PING_EVENT_TTS_SPEED_CHANGED,res);
                            }
                        }
                    }

                    Item{
                        width:123
                        height: 24
                    }

                    BasicRaidoButton
                    {
                        id: chFast
                        checked: devManager.getLightIndex() === 1
                        mytext: qsTr("快速")
                        font.styleName: "Bold"
                        font.pixelSize: 24
                        autoExclusive: true

                        onToggled:
                        {
                            if(checked === true)
                            {
                                devManager.setChTtsSpeed(2);
                                var res = new Object;
                                res["language"] = "ch";
                                res["speed"] = "fast";
                                pingManager.addPingData(PingDefine.PING_EVENT_TTS_SPEED_CHANGED,res);
                            }
                        }
                    }
                }


            }
        }
    }


    Component.onCompleted:
    {
        var enSpeed = devManager.getEnTtsSpeed();
        enSlow.checked = (enSpeed === 0);
        enMid.checked = (enSpeed === 1);
        enFast.checked = (enSpeed === 2);

        var chSpeed = devManager.getChTtsSpeed();
        chSlow.checked = (chSpeed === 0);
        chMid.checked = (chSpeed === 1);
        chFast.checked = (chSpeed === 2);
    }

}
