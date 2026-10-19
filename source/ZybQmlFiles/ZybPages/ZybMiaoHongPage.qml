import QtQuick 2.0
import "../ZybControls/"
import "../Style"
import "../Funcs/UILogics.js" as UILogic

Rectangle {
    id:root
    anchors.fill: parent
    color: Style.mainbgColor
    property var controlData: new Object

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    ZybBackButton{
        id:backButton
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        onBackClicked: {
            root.destroy();
        }

    }

    Image {
        id: mhBack
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/images/mh_back.png"
        scale: 1.4
    }

    Rectangle{
        width:128
        height: 128
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        scale: 1.4


        Canvas{
            id:imageCanvas
            width:128
            height: 128
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            contextType: "2d"
            property var imageData: null
            antialiasing: true

            onPaint: {

                if(imageData !== null ){
//                    console.log("imageCanvas onPaint")
                    context.clearRect(0,0,128,128);
                    context.drawImage(imageData , 0 , 0 ,128,128);
                }
            }
        }
    }



    Timer{
        id:timer
        interval: 150
        running: false
        triggeredOnStart: true
        repeat: true

        property var tmpStepNum: 0


        onTriggered: {

            if(imageCanvas.imageData === null){
                imageCanvas.imageData = imageCanvas.context.createImageData(128 , 128);
                var indexArray = QueryWordManager.getImageData(QueryWordManager.getImageCount() - 2);
//                console.log("onTriggered3 :",indexArray.length,"ImageCount=",QueryWordManager.getImageCount())
                for(var i = 0;i < indexArray.length;i++){
                    var index = indexArray[i];
                    imageCanvas.imageData.data[index*4] = 145;
                    imageCanvas.imageData.data[index*4 +1] = 146;
                    imageCanvas.imageData.data[index*4 +2] = 148;
                    imageCanvas.imageData.data[index*4 +3] = 255;
                }
            }
            if(tmpStepNum < QueryWordManager.getImageCount()){
                indexArray = QueryWordManager.getImageData(tmpStepNum);
                for(i = 0;i < indexArray.length;i++){
                    index = indexArray[i];
                    imageCanvas.imageData.data[index*4] = 255;
                    imageCanvas.imageData.data[index*4 +1] = 114;
                    imageCanvas.imageData.data[index*4 +2] = 86;
                    imageCanvas.imageData.data[index*4 +3] = 255;
                }
                tmpStepNum = tmpStepNum +1;
                imageCanvas.requestPaint();
            }
            else{
                imageCanvas.imageData = imageCanvas.context.createImageData(128 , 128);
                indexArray = QueryWordManager.getImageData(QueryWordManager.getImageCount() - 2);
//                console.log("onTriggered3 :",indexArray.length)
                for(i = 0;i < indexArray.length;i++){
                    index = indexArray[i];
                    imageCanvas.imageData.data[index*4] = 145;
                    imageCanvas.imageData.data[index*4 +1] = 146;
                    imageCanvas.imageData.data[index*4 +2] = 148;
                    imageCanvas.imageData.data[index*4 +3] = 255;
                }
                tmpStepNum = 0
            }


        }
    }

    Component.onCompleted: {
        imageCanvas.imageData = null;
        timer.tmpStepNum = 0;
        timer.running = true;
    }

    Connections {
        target: scanManager;
        onSig_scanDown:{
            root.destroy();
        }
    }


    function setData(data){
        controlData = data;
    }
}
