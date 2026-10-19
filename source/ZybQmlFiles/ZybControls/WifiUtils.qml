import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybStore"
import "../ZybSet"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:wifiutils
    property var mydlg: null
    Component{
        id:dlgtest

        Item{
            id:dlgItem
//            modal: true
            parent: main
            width: Style.gWidth
            height: Style.gHeight
//            leftPadding: 0; rightPadding: 0; topPadding: 0; bottomPadding: 0
            signal okClicked;
            signal cancelClicked();
            property var connectedCall: null
            property var cancelCall: null

            //使对话框打开时居于中心
            onVisibleChanged: {
                if(visible){
                    x = 0
                    y = 0
                }

            }
            //对话框不可自动关闭
//            closePolicy: Popup.NoAutoClose
//            standardButtons: Dialog.NoButton

            Item{
                anchors.fill: parent
//                rotation: devManager.isLeftHand ? 180 : 0
                SetWifiPage{
                    id:wifiPage
                    applyType: "init"
                    anchors.fill: parent
//                    rotation: 180//devManager.isLeftHand ? 180 : 0
                    onBackTo: {
                        if(UILogic.isValid(cancelCall)){
                            dlgItem.cancelCall();
                        }
                        dlgItem.destroy();
                        wifiutils.mydlg = null;
                    }

                    onWifiConnected: {
                        if(UILogic.isValid(dlgItem.connectedCall)){
                            dlgItem.connectedCall();
                        }
                    }
                }
            }

        }
    }

    function openWifiPage(connectCall,backCall){
        mydlg = dlgtest.createObject(wifiutils,{connectedCall:connectCall,cancelCall:backCall})
//        mydlg.open();
        return mydlg;
    }

    function close(){
        if(wifiutils.mydlg !== null){
            wifiutils.mydlg.destroy();
            wifiutils.mydlg = null;
        }

    }


}
