import QtQuick 2.0
import "../ZybStore"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:dlgutils
    property var mydlg: null
    property var mylockdlg: null
    property var myforceOtadlg: null
    Component{
        id:dlgtest

        TipDialog{
            property var okCall: null
            property var cancelCall: null
            onOkClicked: {
                if(UILogic.isValid(okCall)){
                    okCall();
                }
                destroy();  //关闭后销毁
            }

            onCancelClicked: {
                if(UILogic.isValid(cancelCall)){
                    cancelCall();
                }
                destroy();  //关闭后销毁
            }

            onClosed: {
                destroy();  //关闭后销毁
            }
        }
    }

    Component{
        id:dlgForceOta

        TipDialog{
            parent: main
            x:(parent.width - width) / 2
            y:(parent.height - height) / 2
            z:1000
            property var okCall: null
            property var cancelCall: null
            onOkClicked: {
                if(UILogic.isValid(okCall)){
                    okCall();
                }
                destroy();  //关闭后销毁
            }

            onCancelClicked: {
                if(UILogic.isValid(cancelCall)){
                    cancelCall();
                }
                destroy();  //关闭后销毁
            }
        }
    }

    Component{
        id:tipPageComponent
        TipWebPView{
            parent: main
            z:101
            width: Style.gWidth
            height: Style.gHeight
        }
    }

    Component{
        id:lockTip
        LockedTipDlg{
            parent: main
            z:101
        }
    }

    function openMsgDlg( message, leftText,rightText,acceptedCall, rejectedCall,closeBtVisible,cancelVisibel) {
        mydlg = dlgtest.createObject(dlgutils,{strTip:message,leftBtnText:leftText,rightBtnText:rightText,okCall:acceptedCall,cancelCall:rejectedCall,closeBtnVisible:closeBtVisible,isOneBtn:cancelVisibel});
        mydlg.open();
        return mydlg;
    }

    function openTipPage(state){
        console.log("openTipPage")
        mydlg = tipPageComponent.createObject(dlgutils,{pageState:state})
        return mydlg;
    }

    function openLockTipDlg(){
        if(mylockdlg === null){
            mylockdlg = lockTip.createObject(dlgutils);
            mylockdlg.open();
            return mylockdlg;
        }

    }

    function openForceOtaDlg( message, leftText,rightText,acceptedCall, rejectedCall,closeBtVisible,cancelVisibel) {
        myforceOtadlg = dlgForceOta.createObject(dlgutils,{strTip:message,leftBtnText:leftText,rightBtnText:rightText,okCall:acceptedCall,cancelCall:rejectedCall,closeBtnVisible:closeBtVisible,isOneBtn:cancelVisibel});
        myforceOtadlg.open();
        return myforceOtadlg;
    }

    function close(){
        if(dlgutils.mydlg !== null){
            dlgutils.mydlg.destroy();
            dlgutils.mydlg = null;
        }
    }

    function closeLockDlg(){
        if(mylockdlg !== null){
            mylockdlg.destroy();
            mylockdlg = null;
        }
    }

    function closeForceOtaDlg(){
        if(myforceOtadlg !== null){
            myforceOtadlg.destroy();
            myforceOtadlg = null;
        }
    }
}
