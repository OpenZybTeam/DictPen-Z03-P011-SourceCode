import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: element
    property alias  val: rectangle.width
    property bool ischarging:false
    property int powerNum : 0
    property int max: 38

    function setPer(num)
    {
        powerNum = num;
        val = num*max/100
        updataBettery();
    }

    function updataBettery()
    {
        if(ischarging)
        {
            if(powerNum <= 20)
            {
                color1.color = "#FE3B30"
                color2.color = "#FE3B30";
            }
            else if(powerNum >20)
            {
                color1.color = "#59F574";
                color2.color = "#0DBE2A";
            }

        }
        else
        {
            if(powerNum <= 20)
            {
                color1.color = "#FE3B30"
                color2.color = "#FE3B30";
            }
            else
            {
                color1.color = "#FFFFFF";
                color2.color = "#FFFFFF";
            }
        }
    }

    function setCharging()
    {
        ischarging = true
        updataBettery();
    }

    function setNormal()
    {
        ischarging = false
        updataBettery();
    }

    width: 51
    height: 24

    Image {
        id: image
        anchors.fill: parent
        source: "qrc:/images/bettery.png"

        Rectangle {
            id: rectangle
            width: val
            radius: 4
            clip: true
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 4
            anchors.bottomMargin: 4
            anchors.topMargin: 4

            LinearGradient {            ///--[Mark]
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)      ///1.横向渐变
                source: rectangle
                gradient: Gradient {
                    GradientStop {id:color1;  position: 0.0;    color: "#0DBE2A" }
                    GradientStop {id:color2;  position: 1.0;    color: "#59F574" }
                }
            }
        }

        Image {
            id: chargeing
            source: "qrc:/images/charging.png"
            anchors.centerIn: parent
            visible: ischarging
        }

    }

    Component.onCompleted: {
        //val = 32
    }
}
