import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../ZybControls"
import "../Style"

Rectangle {
    id:control
    //color: "#3C3D42"
    radius: 6
    //opacity: 0.6
    property alias ltext: ltext.text
    property bool hasKey: true
    property int signalNum : 0

    function setSignal(num)
    {
        switch(num)
        {
        case 0:
            imgSignal.source = ""
            break;
        case 1:
            imgSignal.source = "qrc:/images/statusbar_icon_wifi_1.png"
            break;
        case 2:
            imgSignal.source = "qrc:/images/statusbar_icon_wifi_2.png"
            break;
        case 3:
            imgSignal.source = "qrc:/images/statusbar_icon_wifi_2.png"
            break;
        case 4:
            imgSignal.source = "qrc:/images/statusbar_icon_wifi_3.png"
            break;
        }
    }

    state: "normal"

    states: [
        State {
            name: "normal"
            StateChangeScript {
                script: {
                    rtext.visible = false
                    imgLoading.visible =false
                    imgLoading.running =false
                    setSignal(signalNum);
                    if(hasKey)
                    {
                        imgStatus.visible = true
                        imgStatus.source = "qrc:/images/lock56x56.png"
                    }
                    else
                    {
                        imgStatus.visible = false
                    }
                }
            }
        },
//        State {
//            name: "refresh"
//            StateChangeScript {
//                script: {


//                }
//            }
//        },
        State {
            name: "connected"
            StateChangeScript {
                script: {
                    setSignal(signalNum);
                    imgLoading.visible =false
                    imgLoading.running =false
                    rtext.visible = false
                    imgStatus.visible = true
                    imgStatus.source = "qrc:/images/wifi_set_connected.png"

                }
            }
        },

        State {
            name: "connecting"
            StateChangeScript {
                script: {
                    setSignal(signalNum);
                    imgLoading.visible = true
                    imgLoading.running = true

                    rtext.visible = true
                    imgStatus.visible = false
                }
            }
        }
    ]

    RowLayout{
        id:rowlayout
        spacing: 8
        //anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 33
        anchors.left: parent.left
        anchors.rightMargin: 33
        anchors.right: parent.right

        ZybText {
            id: ltext
            font.styleName: "Bold"
            text: "textLeft"
        }

        Item {
            Layout.fillWidth: true
        }

        ZybText {
            id: rtext
            text: qsTr("连接中")
            color: "#FFFFFF"

        }

        RotationImage
        {
            id: imgLoading
            source: "qrc:/images/connecting56x56.png"
            running: false
            duration: 1000
        }


        Image {
            id: imgStatus
            fillMode: Image.PreserveAspectFit
            clip: true
        }

        Image {
            id: imgSignal
            fillMode: Image.PreserveAspectFit
            clip: true
        }



    }

}
