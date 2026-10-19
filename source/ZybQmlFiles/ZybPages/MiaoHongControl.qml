import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:root
    height: explainContent.height + 30
    property var controlData: new Object;
    property bool isTitleViseble: true
    signal toMiaoHongPage1();

    Column{
        id:explainContent
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.right: parent.right
        width: parent.width


        Text{
            id:title
            visible: root.isTitleViseble
            color: "#FF12CFA7"
            font.pixelSize: 36
            text: qsTr("描红词典")
        }

//        RoundButton{
//            text: qsTr("描红")
//            font.pixelSize: 28
//            height: 40
//            width: 60
//            background: Rectangle{
//                color: "red"
//            }
//            onClicked: {
//                toMiaoHongPage1();
//            }
//        }
        Image {
            id: mh
            source: "qrc:/images/mhbtn.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    toMiaoHongPage1();
                }
            }
        }

        Item{
            width: Style.scanresult_text_width
            height: example.height
            Text{
                id:example
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                font.pixelSize: 28
                color: "white"
                wrapMode: Text.WrapAnywhere
            }
        }
    }

    function setData(data){
        controlData = data;
        var strEx;
        if(data["strokenum"] !== undefined ){
            strEx = qsTr("笔画:")+ data["strokenum"] + "     "
        }

        if(data["radical"] !== undefined ){
            strEx = strEx + qsTr("部首:")+ data["radical"] + "     "
        }

        if(data["structure"] !== undefined ){
            strEx = strEx + qsTr("结构:")+ data["structure"] + "     "
        }

        if(data["wubi"] !== undefined ){
            strEx = strEx + qsTr("五笔字根:")+ data["wubi"] + "     "
        }

        if(data["similar"] !== undefined ){
            strEx = strEx + qsTr("形近字:")+ data["similar"]
        }
        example.text = strEx;
    }
}
