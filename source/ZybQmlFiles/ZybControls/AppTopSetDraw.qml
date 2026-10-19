import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Style"
import DevConnection.StatusDefine 1.0
import com.zyb.PingDefine 1.0


Drawer {
    id: drawer

    visible: false
    modal: true
    clip: true
    //抽屉起始方向

    edge: devManager.isLeftHand ? Qt.BottomEdge:Qt.TopEdge
    //closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    property bool edited: false
    property bool lightChanged :false
    property bool volumeChanged : false

    background: Rectangle{
        anchors.fill: parent
        color: "#aa0f0f0f"
        //color: "yellow"
        rotation: devManager.isLeftHand ? 180 : 0
        //opacity: 0.8

        Rectangle
        {
            id:inner
            width: Style.gWidth
            height: Style.gHeight
            x:0
            y:106

            color: "#aa0f0f0f"
//            gradient:Gradient {
//                GradientStop {position:0.0;color:Qt.rgba(46/255, 50/255, 56/255, 0.3)}
//                GradientStop {position:1.0;color:Qt.rgba(47/255, 50/255, 56/255, 0.7)}
//            }

            BasicSlider
            {
                id:soundslider
                x:50
                y:30
                incompleteColor: "#993C3D42"
                width: 400
                height: 80
                leftImageSource: "qrc:/images/soundoff.png"
                onPositionChanged:
                {
                    //console.log("soundslider position=",position)
                    initSoundSlider(value);
                    engineSocket.sendVolumnChanged(position);
                    edited = true;
                    volumeChanged = true;
                }
            }


            BasicSlider
            {
                id:lightslider
                anchors.left: soundslider.right
                anchors.leftMargin: 100
                incompleteColor: "#993C3D42"
                y:30
                width: 400
                height: 80
                from: 0
                to:1
                leftImageSource: "qrc:/images/control_icon_bright_medium.png"

                onPositionChanged:
                {
                    //console.log("light changed",position);
                    initLightSlider(position);
                    engineSocket.sendLightChanged(position);
                    edited = true;
                    lightChanged = true;
                }
            }



            ImageButton
            {
                id:wifibtn
                x:soundslider.x+3
                y:148
                implicitWidth:98
                implicitHeight:80
                radius:14
                backgroundTheme: Qt.rgba(1, 1, 1, 0.8);
                source: wifibtn.checked ? "qrc:/images/drawer_wifi_open.png":"qrc:/images/drawer_wifi_close.png"
                onClicked:
                {
                    if(wifibtn.checked)
                    {
                        console.log("send wifi on")
                        engineSocket.sendWifiOn();
                        //wifibtn.source = "qrc:/images/drawer_wifi_open.png";
                    }
                    else
                    {
                        console.log("send wifi off")
                        //apiNetWork.clearCache();
                        engineSocket.sendWifiOff();
                        //wifibtn.source = "qrc:/images/drawer_wifi_close.png";
                    }

                    edited = true;
                    pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_WIFI);
                }
            }

            ImageButton
            {
                id:btn4g
                implicitWidth:98
                implicitHeight:80
                radius:14
                y:148
                x:164
                backgroundTheme: Qt.rgba(1, 1, 1, 0.8);
                source: btn4g.checked ? "qrc:/images/control_icon_data_on.png":"qrc:/images/control_icon_data_off.png"
                onClicked:
                {
                    if(btn4g.checked)
                    {
                        console.log("send 4g on")
                        engineSocket.send4GOn();
                    }
                    else
                    {
                        console.log("send 4g off")
                        engineSocket.send4GOff();
                    }
                    edited = true;
                    pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_4G);
                }
            }

            ImageButton
            {
                id:speakbtn
                implicitWidth:98
                implicitHeight:80
                radius:14
                y:148
                x:lightslider.x +3
                backgroundTheme: Qt.rgba(1, 1, 1, 0.8);
                //checked: devManager.getAutoSpeak()
                source: speakbtn.checked ? "qrc:/images/speakon56.png":"qrc:/images/speakoff56.png"
                onClicked:
                {
                    devManager.setAutoSpeak(speakbtn.checked);
                    edited = true;
                    pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_AUTO_SPEECH);
                }
            }

//            ImageButton
//            {
//                id:blzbtn
//                implicitWidth:98
//                implicitHeight:80
//                radius:14
//                backgroundTheme: Qt.rgba(1, 1, 1, 0.8);
//                y:148
//                anchors.left: speakbtn.right
//                anchors.leftMargin:10
//                source: blzbtn.checked ? "qrc:/images/blzOn.png":"qrc:/images/blzOff.png"
//                onClicked:
//                {
//                    if(blzbtn.checked)
//                    {
//                        console.log("send blz on")
//                        engineSocket.sendBlzOn();
//                    }
//                    else
//                    {
//                        console.log("send blz off")
//                        engineSocket.sendBlzOff();
//                    }
//                    blzManager.setStatus(blzbtn.checked);

//                    edited = true;
//                }
//            }

        }
    }





    function initSoundSlider(value)
    {
        if(value >= 0.2 && value <= 0.6)
        {
            soundslider.leftImageSource = "qrc:/images/control_icon_volume_low.png"
        }
        if(value > 0.6)
        {
            soundslider.leftImageSource = "qrc:/images/soundon.png"
        }
        else if(value < 0.01)
        {
            soundslider.leftImageSource = "qrc:/images/soundoff.png";
        }
    }

    function initLightSlider(value)
    {
        if(value >= 0.25 && value <= 0.65)
        {
            lightslider.leftImageSource = "qrc:/images/control_icon_bright_medium.png"
        }
        if(value > 0.65)
        {
            lightslider.leftImageSource = "qrc:/images/control_icon_bright_high.png"
        }
        else if(value < 0.25)
        {
            lightslider.leftImageSource = "qrc:/images/control_icon_bright_low.png";
        }
    }

    onClosed:
    {
        if(edited === true)
            devManager.saveConfigFile();
    }

    onOpened:
    {
        edited = false;

        wifibtn.checked = (wifiManager.getStatus() >= 1);

        speakbtn.checked = devManager.getAutoSpeak();
        //blzbtn.checked = blzManager.getStatus();
        btn4g.checked = flow4GManager.isOpen();

        soundslider.value = devManager.getSoundVal();
        initSoundSlider(devManager.getSoundVal());

        //console.log("onopen light val=",devManager.getLightVal());
        lightslider.value = devManager.getLightVal();
        initLightSlider(devManager.getLightVal());
    }
}




