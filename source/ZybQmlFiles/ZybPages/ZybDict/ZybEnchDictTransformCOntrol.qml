import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../ZybControls/"
import "../../Funcs/UILogics.js" as UILogic
import "../../Style"
import "../../Global"
import "../"
import com.zyb.PingDefine 1.0
import DevStateMonitor.DevStateDefine 1.0

Item {
    id:root
    height: column.height
    property var controlData: new Array

    Column{
        id:column
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        width: parent.width

        Text{
            id:exampleTitle
            color: "#FF12CFA7"
            font.family: Style.chFontFamily
            font.styleName: "Normal"
            font.pixelSize: Style.scanresult_explain_fontSize
            text: qsTr("词形变化")
        }

        Item{
            height: 16
            visible: exampleTitle.visible
            width: root.width
        }

        Text {
            id: briefExplain
            width: root.width
            wrapMode: Text.WordWrap
            font.pixelSize: 28
            font.family: Style.chFontFamily
            color: "#FFFFFFFF"
            textFormat: Text.RichText
            text: ""
        }
    }



    Component.onCompleted: {
        var data = controlData;
        var transText = "";
        for(var i = 0;i < data.length;i++){
            var transItem = data[i];
            if(i === data.length-1){
               transText +=  transItem["comment"] + " " + transItem["words"];
            }
            else{
                transText +=  transItem["comment"] + " " + transItem["words"] + "  ";
            }
        }
        briefExplain.text = transText;
    }

}
