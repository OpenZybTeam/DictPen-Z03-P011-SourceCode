import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Style"
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import DevConnection.StatusDefine 1.0
import com.zyb.PingDefine 1.0
import QtGraphicalEffects 1.0

Pane
{
    id:control
    //anchors.fill: parent

    signal sig_open();
    signal sig_close();


    background: Image{
        id:bg
        anchors.fill: parent
        source: "qrc:/images/main_bg.png"
    }


    property bool edited: false
    property bool lightChanged :false
    property bool volumeChanged : false
    property bool interactive: true
    property  var res : new Object;
    BasicSlider
    {
        id:soundslider
        x:Style.highVersion ?80:50
        y:Style.highVersion ?18:30
        incompleteColor: "#993C3D42"
        width: Style.highVersion ?320:295
        height: 80
        z:10
        leftImageSource: "qrc:/images/soundoff.png"
        onPositionChanged:
        {
            //console.log("soundslider position=",position)
            initSoundSlider(value);
            engineSocket.sendVolumnChanged(position);
            edited = true;
            volumeChanged = true;
        }

        property int num: 0
        onPressedChanged:
        {
            num++;
            if(num%2 === 0)
            {
                res = {};
                res["value"] = position
                pingManager.addPingData(PingDefine.PING_EVENT_MENU_CHANGE_VOLUME,res);
            }
        }
    }


    BasicSlider
    {
        id:lightslider
        anchors.left: soundslider.right
        anchors.leftMargin: Style.highVersion ? 130:92
        incompleteColor: "#993C3D42"
        y:Style.highVersion ?18:30
        width: Style.highVersion ?320:295
        height: 80
        from: 0
        to:1
        leftImageSource: "qrc:/images/control_icon_bright_medium.png"
        z:10
        onPositionChanged:
        {
            //console.log("light changed",position);
            initLightSlider(position);
            engineSocket.sendLightChanged(position);
            edited = true;
            lightChanged = true;
        }

        property int num: 0
        onPressedChanged:
        {
            num++;
            if(num%2 === 0)
            {
                res = {};
                res["value"] = position
                pingManager.addPingData(PingDefine.PING_EVENT_MENU_CHANGE_LIGHT,res);
            }
        }
    }



    ImageButton
    {
        id:wifibtn
        x:soundslider.x+3
        y:Style.highVersion ?125:148
        implicitWidth:98
        implicitHeight:80
        radius:14
        z:10
        backgroundTheme: "#CCFFFFFF"
        source: wifibtn.checked ? "qrc:/images/drawer_wifi_open.png":"qrc:/images/drawer_wifi_close.png"
        onClicked:
        {
            res = {};
            if(wifibtn.checked)
            {
                console.log("send wifi on")
                engineSocket.sendWifiOn();
                res["model"] = "on"
                //phoneA2BManager.creatTest();
            }
            else
            {
                console.log("send wifi off")
                engineSocket.sendWifiOff();
                res["model"] = "off"
                //phoneA2BManager.releaseTest();
            }

            edited = true;
            pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_WIFI,res);
        }
    }

    ImageButton
    {
        id:btn4g
        implicitWidth:98
        implicitHeight:80
        radius:14
        y:Style.highVersion ?125:148
        z:10
        x:Style.highVersion ?196:164
        backgroundTheme: "#CCFFFFFF"
        source: btn4g.checked ? "qrc:/images/control_icon_data_on.png":"qrc:/images/control_icon_data_off.png"
        onClicked:
        {
            res = {};
            if(btn4g.checked)
            {
                console.log("send 4g on")
                engineSocket.send4GOn();
                res["model"] = "on"
            }
            else
            {
                console.log("send 4g off")
                engineSocket.send4GOff();
                res["model"] = "off"
            }
            edited = true;
            pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_4G,res);
        }
    }

    ImageButton
    {
        id:speakbtn
        implicitWidth:98
        implicitHeight:80
        radius:14
        y:Style.highVersion ?125:148
        z:10
        x:lightslider.x +3
        backgroundTheme: "#CCFFFFFF"
        //checked: devManager.getAutoSpeak()
        source: speakbtn.checked ? "qrc:/images/speakon56.png":"qrc:/images/speakoff56.png"
        onClicked:
        {
            res = {};
            res["model"] = speakbtn.checked?"on":"off";
            devManager.setAutoSpeak(speakbtn.checked);
            edited = true;
            pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_AUTO_SPEECH,res);
        }
    }

    ImageButton
    {
        id:blzbtn
        implicitWidth:98
        implicitHeight:80
        radius:14
        y:Style.highVersion ?125:148
        z:10
        backgroundTheme: "#CCFFFFFF"
        anchors.left: speakbtn.right
        anchors.leftMargin:10
        source: blzbtn.checked ? "qrc:/images/blzOn.png":"qrc:/images/blzOff.png"
        onClicked:
        {
            res = {};
            if(blzbtn.checked)
            {
                console.log("send blz on")
                engineSocket.sendBtOn();
                res["model"] = "on"
            }
            else
            {
                console.log("send blz off")
                engineSocket.sendBtOff();
                res["model"] = "off"
            }
            edited = true;
            pingManager.addPingData(PingDefine.PING_EVENT_MENU_SWITCH_BT,res);
        }
    }


    function initSoundSlider(value)
    {
        if(value > 0.6)
        {
            soundslider.leftImageSource = "qrc:/images/soundon.png"
        }
        else if(value < 0.01)
        {
            soundslider.leftImageSource = "qrc:/images/soundoff.png";
        }
        else
        {
            soundslider.leftImageSource = "qrc:/images/control_icon_volume_low.png"
        }
    }

    function initLightSlider(value)
    {
        if(value > 0.65)
        {
            lightslider.leftImageSource = "qrc:/images/control_icon_bright_high.png"
        }
        else if(value < 0.25)
        {
            lightslider.leftImageSource = "qrc:/images/control_icon_bright_low.png";
        }
        else
        {
            lightslider.leftImageSource = "qrc:/images/control_icon_bright_medium.png"
        }
    }


    function open()
    {
        if(interactive === false)
            return;
        edited = false;

        wifibtn.checked = (wifiManager.getStatus() >= 1);

        speakbtn.checked = devManager.getAutoSpeak();
        blzbtn.checked = btManager.isOpen();
        btn4g.checked = flow4GManager.isOpen();

        soundslider.value = devManager.getSoundVal();
        initSoundSlider(devManager.getSoundVal());

        //console.log("onopen light val=",devManager.getLightVal());
        lightslider.value = devManager.getLightVal();
        initLightSlider(devManager.getLightVal());


        sig_open();
    }


    function close()
    {
        if(edited === true)
        {
            console.log("short menu close save config file");
            devManager.saveConfigFile();
            edited = false;
        }
        sig_close();
    }


    SwipeArea
    {
        id:videoMouseArea
        anchors.fill: parent;

        onPressed:
        {
            //close();
        }

        onUpmove:{
            console.log("onUpmove");
            close();
        }

        onDownmove:{
            //close();
        }

    }

}





