import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Funcs/UILogics.js" as UILogic
import "../Style"
import "../ZybControls"

Page {
    id: page

    property int num:0
    property bool btimeout:false
    property string tip: "<b>请<font color=black>扫描</font>内容</b>"
    property string imgsource : ""
    property int imgHeight : 180

    signal backToParent();

    background: Rectangle{
        anchors.fill: parent
        color: Style.mainbgColor
    }


    state: "tip"
    states: [
        State {
            name: "tip"
        },

        State {
            name: "scaning"
            StateChangeScript {
                script: {
                }
            }
        },

        State {
            name: "scanEnd"
            StateChangeScript {
                script: {
                }
            }

        }
    ]

    function clearPic()
    {
        img.source = "";
    }

    function clearPreImage()
    {
        imgPre.source = "";
        console.log("clear Pre Image");
    }

    function isHavePic()
    {
        console.log("ishavepic",img.paintedHeight,img.paintedWidthm,img.status)
        if(img.status === Image.Null)
        {
            return false;
        }

        return true;
    }

    function setImagePre()
    {
        imgPre.source = "";
        imgPre.source = "file:///"+ocrManager.getPreImagePath();
    }

    Image{
        id:imgPre
        cache:false
        asynchronous: false
        //fillMode: Image.PreserveAspectFit
        anchors.left: parent.left
        anchors.top: parent.top
        height: source.toString().length>0? 114:0
    }

    Image{
        id:img
        source: imgsource
        cache:false
        asynchronous: false
        //fillMode: Image.PreserveAspectCrop
        anchors.left: parent.left
        anchors.top: imgPre.bottom
        height:114
        property bool counter: false
        function reload() {
            ocrManager.lockMatux();
            counter = !counter
            source = "image://OcrImage?id=" + counter
            ocrManager.unlockMatux();
        }

        Connections{
            target: ocrManager
            onCallQmlRefreshImage:{
                img.reload()
            }
        }
    }


}





//import QtQuick 2.0
//import QtQuick.Controls 2.3
//import "../Funcs/UILogics.js" as UILogic
//import "../Style"
//import "../ZybControls"

//Page {
//    id: page

//    property int num:0
//    property bool btimeout:false
//    property string tip: "<b>请<font color=black>扫描</font>内容</b>"
//    property var  curImgObj:null
//    property var imgGroup : []
//    property int imgHeight : 180

//    background: Rectangle{
//        anchors.fill: parent
//        color: Style.mainbgColor
//    }


//    state: "tip"
//    states: [
//        State {
//            name: "tip"
//        },

//        State {
//            name: "scaning"
//            StateChangeScript {
//                script: {
//                    mtimer.running = true;
//                }
//            }
//        },

//        State {
//            name: "scanEnd"
//            StateChangeScript {
//                script: {
//                    mtimer.running = false;
//                }
//            }

//        }
//    ]

//    property int count : 0
//    property bool counter: false
//    function reload() {
//        counter = !counter
//        //console.log(curImgObj.width);
//        curImgObj.source = "image://OcrImage?id=" + counter
//    }

//    function createItem()
//    {
//        console.log("createItem")
//        count++;
//        console.log("createItem count =",count);
//        // 创建一个组件
//        var obj = imgComponent.createObject(imgColumn)
//        //                    var obj = Qt.createQmlObject('import QtQuick 2.0; Image {cache:false;asynchronous: false;fillMode: Image.PreserveAspectFit}',
//        //                                                         imgColumn,
//        //                                                         "dynamicSnippet1");

//        curImgObj = obj;
//        imgGroup.push(obj);

//        scrollToBottom();

//    }

//    function clearItems()
//    {
//        var len = imgGroup.length;
//        console.log("clearItems count =",count,imgGroup.length);
//        for(var i = 0; i < len; i++){
//            imgGroup.pop().destroy();
//        }

//        curImgObj = null;
//        console.log("clearItems imgGroup.length =",imgGroup.length);
//        count = 0;
//    }


//    function scrollToBottom()
//    {
//        if(flick.contentHeight > flick.height)
//            flick.contentY = flick.contentHeight-flick.height;
//    }

//    Image{
//        id:imgRes
//        cache:false
//        asynchronous: false
//        fillMode: Image.PreserveAspectFit
//        anchors.left: parent.left
//        anchors.top: parent.top
//        visible: page.state === "scanEnd"
//        property bool counter: false
//        function reload() {
//            counter = !counter
//            source = "image://OcrImage?id=" + counter
//        }

//        Connections{
//            target: ocrManager
//            onSig_getSearchImage:{
//                imgRes.reload()
//            }
//        }
//    }

//    Flickable {
//        id: flick
//        anchors.fill: parent
//        contentWidth: parent.width
//        contentHeight: imgColumn.height
//        clip: true
//        visible: page.state === "tip" || page.state==="scaning"
//        flickableDirection: Flickable.VerticalFlick
//        ScrollBar.vertical: ScrollBar {
//            visible: true
//            policy: ScrollBar.AsNeeded

//        } //创建一个竖向的滚动条

//        Column
//        {
//            id: imgColumn
//            spacing: 1
//            width: parent.width
//        }

//    }


//    Connections{
//        target: ocrManager
//        onCallQmlRefreshImage:{
//            reload()
//        }
//    }


//    Component
//    {
//        id:imgComponent

//        Image{
//            id:img
//            cache:false
//            asynchronous: false
//            fillMode: Image.PreserveAspectFit

//        }

//    }


//    //    Rectangle{
//    //        id:cursorRect
//    //        anchors.left: curImgObj.right
//    //        anchors.leftMargin: 5
//    //        width: 2
//    //        height: 60//imgHeight
//    //        color: (num == 1) ? "#OFOFOF" : "white"
//    //    }

//    Timer{
//        id:mtimer
//        interval: 300;
//        repeat: true;
//        running: true
//        onTriggered: {
//            num = ((num == 1) ? 0 : 1)
//        }
//    }
//}
