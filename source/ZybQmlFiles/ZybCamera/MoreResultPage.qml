import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../ZybControls"
import "../Style"
Popup{
    id:root
    width:420
    height:120

    background: Rectangle {
        anchors.fill: parent
        color: Style.digbgColor
        radius:10
    }


    function init(num)
    {
        res1.checked = true;
        width = num*68+120;

        initPage(num);
    }

    signal numClicked(int num)

    FocusScope {
        id: pData
        anchors.fill: parent
        rotation: devManager.isLeftHand ? 180 : 0

        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 12
            spacing: 12

            ZybText {
                id:resText
                text: "结果 "
                font.pixelSize: Style.tipFontPixel
                font.styleName: "Bold"
                color:"#FFFFFF"
            }

            BasicRoundButton
            {
                id:res1

                mtext: qsTr("1")
                backgroundTheme: Style.btnOnDigColor
                bold:true
                fontsize: 36
                autoExclusive: true
                checked: true

                onClicked: {
                    numClicked(Number(mtext)-1)
                }

                onSeemClicked:
                {
                    root.visible = false;
                }
            }

            BasicRoundButton
            {
                id:res2

                mtext: qsTr("2")
                backgroundTheme: Style.btnOnDigColor
                fontsize: 36
                bold:true
                autoExclusive: true
                onClicked: {
                    numClicked(Number(mtext)-1)
                }

                onSeemClicked:
                {
                    root.visible = false;
                }
            }

            BasicRoundButton
            {
                id:res3

                mtext: qsTr("3")
                backgroundTheme: Style.btnOnDigColor
                fontsize: 36
                bold:true
                autoExclusive: true
                onClicked: {
                    numClicked(Number(mtext)-1)
                }

                onSeemClicked:
                {
                    root.visible = false;
                }
            }

            BasicRoundButton
            {
                id:res4

                mtext: qsTr("4")
                backgroundTheme: Style.btnOnDigColor
                fontsize: 36
                bold:true
                autoExclusive: true
                onClicked: {
                    numClicked(Number(mtext)-1)
                }

                onSeemClicked:
                {
                    root.visible = false;
                }
            }

            BasicRoundButton
            {
                id:res5
                mouse_margin:-14
                mtext: qsTr("5")
                backgroundTheme: Style.btnOnDigColor
                fontsize: 36
                bold:true
                autoExclusive: true
                onClicked: {
                    numClicked(Number(mtext)-1)
                }

                onSeemClicked:
                {
                    root.visible = false;
                }
            }

            Item {
               width: 10
            }
        }

    }


    function initPage(num)
    {
        switch(num)
        {
        case 1:
            res1.visible = true
            res2.visible = false
            res3.visible = false
            res4.visible = false
            res5.visible = false
        break;
        case 2:
            res1.visible = true
            res2.visible = true
            res3.visible = false
            res4.visible = false
            res5.visible = false
        break;
        case 3:
            res1.visible = true
            res2.visible = true
            res3.visible = true
            res4.visible = false
            res5.visible = false
        break;
        case 4:
            res1.visible = true
            res2.visible = true
            res3.visible = true
            res4.visible = true
            res5.visible = false
        break;
        case 5:
            res1.visible = true
            res2.visible = true
            res3.visible = true
            res4.visible = true
            res5.visible = true
        break;
        default:
            break;
        }
    }

}
