import QtQuick 2.0
import "../Global"
import "../Style"
import com.zyb.PingDefine 1.0

Item {
    id:root
    height: 56
    property var controlData: null
    property string word: ""
    property int curIndex: 0
    signal currentIndex_Changed(var wordData)
    ListView{
        id:list
        anchors.fill: parent
        clip: true
        orientation: ListView.Horizontal
        delegate: phoneticComponent
        spacing:22
        model:ListModel{}
        onCurrentIndexChanged: {
            if(currentIndex >= 0){
                curIndex = currentIndex;
                currentIndex_Changed(root.controlData[currentIndex]);
            }

        }
    }

    Component{
        id:phoneticComponent
        Rectangle {
            id: control
            width: content.width + 40//235
            height: 56
            radius: 6
            color: (parentView.currentIndex === index) ? "#12CFA7" : "#1A12CFA7"
            property var parentView: list
            property var soundFilePath: ""
            property var soundIndex: -1
            property var text: itemText
            property var textColor: (parentView.currentIndex === index) ? "#FFFFFFFF" : "#FF12CFA7"
            property var isHaveSound: true
            signal clicked();

            Item {
                id:content
                height: parent.height
                width: contentText.width + 8
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id:contentText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: control.textColor
                    font.pixelSize: Style.scanresult_explain_fontSize
                    font.family: Style.engFontFamily
                    font.styleName: "Normal"
                    text: control.text
                }

            }

            MouseArea{
                width: parent.width
                height: parent.height + 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter:parent.verticalCenter
                onClicked: {
                    pingManager.addPingData(PingDefine.PING_EVENT_OXFORD_WORDLIST_CLICK);
                    parentView.currentIndex = index;
                }
            }
        }
    }

    property var indexArray: ["₁","₂","₃","₄","₅"]
    function setData(data){
        controlData = data["result"];
        word = data["word"];
//        console.log(JSON.stringify(controlData));
        list.model.clear();
        if(controlData.length > 1){
            root.visible = true;
            for(var i = 0;i < controlData.length;i++){
                var wordItem = controlData[i];
                if(wordItem["top"] !== undefined){
                    var top = wordItem["top"];
                    var topWord = word + indexArray[i];
                    list.model.append({"itemText":topWord});
                }
            }
            list.currentIndex = 0;
        }
        else{
            root.visible = false;
            currentIndex_Changed(root.controlData[0]);
        }

    }

    function setCurrentIndex(index){
        list.currentIndex = index;
    }
}
