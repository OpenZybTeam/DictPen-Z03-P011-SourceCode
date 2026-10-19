import QtQuick 2.0
import "../Style"
//滑动按钮
Rectangle {
    id: control

    property color offBorderColor: "black"
    property color offButtonColor: "white"
    property color offBackgroundColor: Style.digbgColor
    property color onBorderColor: Qt.darker("green")
    property color onButtonColor: "white"
    property color onBackgroundColor: "#30D158"
    signal modelChanged(var mode);

    implicitWidth: 74
    implicitHeight: 46

    radius: height/2
    border {
        width: 0
    }

    Rectangle{
        id: switch_button
        height: 40
        width: 40
        radius: height/2
        border.color: parent.border.color
        border.width: 0
        anchors.verticalCenter: parent.verticalCenter
        //本来想加个Off/On的文本在上面，貌似没必要
    }

    MouseArea{
        anchors.fill: parent
        anchors.margins: -30
        onClicked: {
            control.state=(control.state=="off")?"on":"off";
            var b = false;
            if(control.state === "on")
            {
                b = true;
            }

            modelChanged(b);
        }
    }


    state: "off"
    states: [
        State {
            name: "off"
            PropertyChanges {
                target: control
                border.color: offBorderColor
                color: offBackgroundColor
            }
            PropertyChanges {
                target: switch_button
                color: offButtonColor
                x: 3
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: control
                border.color: onBorderColor
                color: onBackgroundColor
            }
            PropertyChanges {
                target: switch_button
                color: onButtonColor
                x: control.width-switch_button.width-3
            }
        }
    ]

    transitions: [
        Transition {
            from: "off"
            to: "on"
            //按钮加渐变过渡感觉很奇怪，参照手机上的按钮就没加渐变动画
            //ColorAnimation { targets: [control]; duration: 300 }
            NumberAnimation { targets: [switch_button]; property: "x"; duration: 300 }
        },
        Transition {
            from: "on"
            to: "off"
            //ColorAnimation { targets: [control]; duration: 200 }
            NumberAnimation { targets: [switch_button]; property: "x"; duration: 200 }
        }
    ]
}
