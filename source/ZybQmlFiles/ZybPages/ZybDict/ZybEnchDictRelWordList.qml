import QtQuick 2.0
import "../../Global"
import "../../Style"
import "../../ZybControls"
import com.zyb.PingDefine 1.0

Item {
    id:root
    height: 56
    property var controlData: null
    property int curIndex: 0
    signal currentIndex_Changed(var subentryData)
    ListView{
        id:list
        anchors.fill: parent
        clip: true
        orientation: ListView.Horizontal
        delegate: phoneticComponent
        spacing:30
        model:ListModel{}
        onCurrentIndexChanged: {
            if(currentIndex >= 0){
                curIndex = currentIndex;
                currentIndex_Changed(controlData[currentIndex]);
            }
        }
    }

    Component{
        id:phoneticComponent
        Rectangle {
            id: control
            width: content.width + 20//235
            height: 42
            radius: 6
            color: Style.mainbgColor
            border.width: 2
            border.color: (parentView.currentIndex === index) ? "#FF12CFA7" : "#FFFFFFFF"
            property var parentView: list
            property var soundFilePath: ""
            property var soundIndex: -1
            property var text: itemText
            property var textColor: (parentView.currentIndex === index) ? "#FF12CFA7" : "#FFFFFFFF"
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
                    var res = new Object;
                    res["type"] = control.text;

                    pingManager.addPingData(PingDefine.PING_EVENT_ZYBDICT_RELATIONWORD_CLICKE,res);
                    parentView.currentIndex = index;
                }
            }
        }

    }

    function setData(data){
//        console.log(JSON.stringify(data));
        controlData = data;
        list.model.clear();
        for(var i = 0;i < controlData.length;i++){
            var subentryItem = controlData[i];
            list.model.append({"itemText":subentryItem["type"]});
        }
        list.currentIndex = 0;
        currentIndex_Changed(controlData[0]);

    }

    function setCurrentIndex(index){
        list.currentIndex = index;
    }
}
