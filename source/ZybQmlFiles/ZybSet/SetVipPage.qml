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
    property string strTitle : ""
    property string content1: ""
    property string content2: ""
    property string content3: ""
    property color content2Color: "#999999"
    property int topMargin : 96

    state: "init"
    states: [
        State {
            name: "init"
            StateChangeScript {
                script: {
                    console.log("init state")
                    setLabelVisible(false)
                    vipStatus.visible = false
                    title.text = qsTr("会员中心")
                    if(dataManager.getLive() === false)
                    {
                        remainDays.visible = false;
                        remainDays.text = qsTr("请联网更新");
                    }

                    if(devManager.isVipHaveAlert())
                    {
                        vipRedDot.visible=true;
                    }
                    else
                    {
                        vipRedDot.visible=false;
                    }

                    if(devManager.isSvipHaveAlert())
                    {
                        svipRedDot.visible=true;
                    }
                    else
                    {
                        svipRedDot.visible=false;
                    }

                }
            }
        },

        State {
            name: "vip"
            StateChangeScript {
                script: {
                    console.log("vip")
                    setVipStatus();
                    updateOfflineState();
                }
            }
        },

        State {
            name: "svip"
            StateChangeScript {
                script: {
                    console.log("svip")
                    setSvipStatus();    
                    updateOfflineState();
                }
            }
        }
    ]

    function updateOfflineState()
    {
        if(dataManager.getLive() === false)
        {
            vipStatus.visible = false;
            remainDays.visible = true;
            remainDays.text = qsTr("请联网更新");
            firstPageTip2.visible = false
        }
    }


    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        onBackClicked: {
            if(root.state === "vip" || root.state==="svip")
            {
                root.state = "init";
            }
            else
            {
                root.visible = false
                UILogic.backToSetPage();
            }

        }

    }

    Component {
        id: vipBtn
        Rectangle {
            radius: 6
            color: Qt.rgba(18/255,207/255,167/255,0.1)
            width: 200
            height: 70
            Text {
                anchors.centerIn: parent
                text: name
                font.styleName: "Bold"
                color: Style.mainColor
                font.pixelSize: Style.normalFontPixel

            }
        }
    }


    RowLayout {
         id: layout
         anchors.horizontalCenter: parent.horizontalCenter
         anchors.verticalCenter: parent.verticalCenter
         spacing: 36
         visible: root.state === "init"
         Rectangle {
             radius: 6
             color: Qt.rgba(18/255,207/255,167/255,0.1)
             width: 200
             height: 70
             Text {
                 anchors.centerIn: parent
                 text: "VIP"
                 font.styleName: "Bold"
                 color: Style.mainColor
                 font.pixelSize: Style.normalFontPixel

             }

             Rectangle
             {
                 id:vipRedDot
                 width: 12
                 height: 12
                 radius: width/2
                 color: "red"
                 anchors.right: parent.right
                 anchors.top: parent.top
                 visible: false
             }

             MouseArea
             {
                 anchors.fill: parent
                 onClicked:
                 {
                     root.state = "vip"
                 }
             }
         }

         Rectangle {
             radius: 6
             color: Qt.rgba(18/255,207/255,167/255,0.1)
             width: 200
             height: 70
             Text {
                 anchors.centerIn: parent
                 text: "SVIP"
                 font.styleName: "Bold"
                 color: Style.mainColor
                 font.pixelSize: Style.normalFontPixel

             }

             Rectangle
             {
                 id:svipRedDot
                 width: 12
                 height: 12
                 radius: width/2
                 color: "red"
                 anchors.right: parent.right
                 anchors.rightMargin: 4
                 anchors.top: parent.top
                 anchors.topMargin: 4
                 visible: false
             }

             MouseArea
             {
                 anchors.fill: parent
                 onClicked:
                 {
                     root.state = "svip"
                 }
             }
         }

     }

    ZybText {
        id: vipStatus
        text: qsTr("已开通")
        anchors.verticalCenter: backButton.verticalCenter
        anchors.left: backButton.right
        anchors.leftMargin: 32
        font.pixelSize: Style.tipFontPixel
        color: "#999999"

    }

    ZybText {
        id: title
        text: qsTr("会员中心")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
        font.styleName: "Bold"
    }


    ZybText {
        id:strRemaindays
        text: qsTr("有效期至:")
        anchors.verticalCenter: backButton.verticalCenter
        anchors.right: remainDays.left
        anchors.rightMargin: 10
        font.pixelSize: Style.tipFontPixel
        color: "#999999"
    }

    ZybText {
        id: remainDays
        text: qsTr("2021-12-06")
        anchors.verticalCenter: backButton.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        font.pixelSize: Style.tipFontPixel
    }

    ListModel {
        id: vipMode
        ListElement { name: "视频讲解"; }
        ListElement { name: "知识点讲解"; }
        //ListElement { name: "流量"; }
    }

    ListModel {
        id: svipMode
        ListElement { name: "解题大招"; }
        ListElement { name: "视频讲解"; }
        ListElement { name: "知识点讲解"; }
    }

    Component {
        id: mdelegate

        Rectangle {
            id:btn
            radius: 6
            color: Qt.rgba(18/255,207/255,167/255,0.1)
            width: 200
            height: 70
            Text {
                id:modelName
                anchors.centerIn: parent
                text: name
                font.styleName: "Bold"
                color: Style.mainColor
                font.pixelSize: Style.normalFontPixel

            }
            MouseArea
            {
                id:mouse
                anchors.fill: parent
                onClicked:
                {
                    strTitle = modelName.text;
                    if(modelName.text === qsTr("视频讲解"))
                    {
                        content1 = qsTr("题目看不懂？答案看不懂？老师手把手教你搞懂这道题。")
                        content2 = "";
                        content3 = qsTr("搜索题目后，配有视频解析的题目会出现此内容")
                        content2Color = "#999999"
                        topMargin = 96
                        pingManager.addPingData(PingDefine.PING_EVENT_SET_VIP_VIDEO_ENTER);
                    }
                    else if(modelName.text === qsTr("解题大招"))
                    {
                        content1 = qsTr("名师精讲，手把手带你分模块专项突破，扫清薄弱点。")
                        content2 = qsTr("并提供学霸解题大招，不仅教你大招公式，更教你大招思维。")
                        content3 = qsTr("搜索题目后，配有解题大招的题目会出现此内容")
                        content2Color = "#999999"
                        topMargin = 88
                    }
                    else if(modelName.text === qsTr("知识点讲解"))
                    {
                        content1 = qsTr("根据各学科知识点，精心打造知识点大招短视频。")
                        content2 = qsTr("每个大招都配有真题验证与记忆口诀。")
                        content3 = qsTr("搜索题目后，配有知识点讲解的题目会出现此内容")
                        content2Color = "#999999"
                        topMargin = 88
                        pingManager.addPingData(PingDefine.PING_EVENT_SET_VIP_POINT_ENTER);
                    }

                    pageLoader.sourceComponent = itemInfo
                }
            }

        }
    }


    ListView {
        id: naListView
        spacing: 36
        width:400+36*2
        height: 65
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset:  0
        orientation: ListView.Horizontal
        model:vipMode
        delegate: mdelegate
        focus: true
        visible: root.state == "vip" || root.state == "svip"
    }


    ZybText
    {
        id:firstPageTip1
        text: qsTr("会员权益仅限本设备有效")
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Style.tipFontPixel
        color: "#999999"
        anchors.bottom: firstPageTip2.top
        anchors.bottomMargin: 8
    }

    ZybText
    {
        id:firstPageTip2
        text: qsTr("VIP权益将在10天后过期，请在（作业帮智能APP或设备端）充值续费")
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Style.tipFontPixel
        color: "#999999"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 9
    }

    Loader { id: pageLoader }

    Component {
        id: itemInfo

        Pane
        {
            id:page

            background: Rectangle
            {
                anchors.fill: parent
                color: Style.mainbgColor
            }

            width: Style.gWidth
            height: Style.gHeight

            ZybBackButton{
                id:back
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                onBackClicked: {
                    root.visible = true
                    pageLoader.sourceComponent = null
                }

            }

            ZybText {
                id: tit
                text: strTitle
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: back.verticalCenter
                font.pixelSize: Style.normalFontPixel
                font.styleName: "Bold"
                elide: Text.ElideMiddle
            }

            ZybText {
                id: info1
                text: content1
                visible: content1.length>0
                lineHeightMode: Text.FixedHeight
                lineHeight: 35
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: topMargin
                font.pixelSize: Style.tipFontPixel
            }
            ZybText {
                id: info2
                text: content2
                visible: content2.length>0
                lineHeightMode: Text.FixedHeight
                lineHeight: 35
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: info1.bottom
                anchors.topMargin: 2
                font.pixelSize: Style.tipFontPixel
            }

            ZybText {
                id: info3
                text: content3
                color: content2Color
                horizontalAlignment: Text.AlignHCenter
                lineHeightMode: Text.FixedHeight
                lineHeight: 35
                font.pixelSize: Style.tipFontPixel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: content2.length>0 ? info2.bottom:info1.bottom
                anchors.topMargin: 6
            }
        }
    }

    function setLabelVisible(b)
    {
        console.log("setLabelVisible:",b)
        strRemaindays.visible = b
        remainDays.visible = b
        firstPageTip1.visible =b
        firstPageTip2.visible = b;
    }

    function setVipStatus()
    {
        console.log("setVipStatus")
        title.text = qsTr("VIP")
        naListView.model = vipMode;
        naListView.width = 400+36*2
        setLabelVisible(true);
        vipStatus.visible = true
        remainDays.text = devManager.getVipExpireData();
        firstPageTip2.text = devManager.getVipAlertMsg();
        if(devManager.getVipStatus() === -1)
        {
            vipStatus.text = qsTr("已过期")
            setLabelVisible(false);
        }
        else if(devManager.getVipStatus() === 0 || devManager.getVipStatus() === -2)
        {
            vipStatus.text = qsTr("非会员")
            setLabelVisible(false);
        }
        else if(devManager.getVipStatus() === 1)
        {
            vipStatus.text = qsTr("已开通")
        }

        firstPageTip1.visible = true
        firstPageTip2.visible = true;

        if(devManager.getVipRemainDays() <= 10 && devManager.getVipRemainDays() > 1)
        {
            devManager.setVipRed10Entered();
        }

        if(devManager.getVipRemainDays() <= 1)
        {
            devManager.setVipRed10Entered();
            devManager.setVipRed1Entered();
        }
    }

    function setSvipStatus()
    {
        console.log("setSVipStatus",devManager.getSvipStatus())
        title.text = qsTr("SVIP")
        naListView.model = svipMode
        naListView.width = 600+36*2
        setLabelVisible(true);
        vipStatus.visible = true
        remainDays.text = devManager.getSvipExpireData();
        firstPageTip2.text = devManager.getSvipAlertMsg();
        if(devManager.getSvipStatus() === -1)
        {
            vipStatus.text = qsTr("已过期")
            setLabelVisible(false);
        }
        else if(devManager.getSvipStatus() === 0 || devManager.getSvipStatus() === -2)
        {
            vipStatus.text = qsTr("非会员")
            setLabelVisible(false);
        }
        else if(devManager.getSvipStatus() === 1)
        {
            vipStatus.text = qsTr("已开通")
        }

        firstPageTip1.visible = true
        firstPageTip2.visible = true;
        if(devManager.getSvipRemainDays() <= 10 && devManager.getSvipRemainDays() > 1)
        {
            devManager.setSvipRed10Entered();
        }

        if(devManager.getSvipRemainDays() <= 1)
        {
            devManager.setSvipRed10Entered();
            devManager.setSvipRed1Entered();
        }
    }

    Component.onCompleted:
    {
        pingManager.addPingData(PingDefine.PING_EVENT_SET_VIP_ENTER);
    }
}
