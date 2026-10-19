import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../Funcs/UILogics.js" as UILogic
import "../ZybControls/"
import "./"
import "../Style"
import "../Global"
Pane {

    background: Rectangle{
        anchors.fill: parent
        color: "#0F0F0F"
    }

    function addOneRecordToTop(time,isout)
    {
        console.log("addOneRecordToTop",isout);
        addOneRecord(time,isout)
    }

    function addOneRecord(time,isout,istimeout)
    {
        //var mstate = istimeout?"timeout":"other";
        var outOrin = isout?"out":"in";

        //console.log("addOneRecord",isout,istimeout);
        recordmodel.append({state:outOrin,"time":time,status:istimeout});
    }

    function clearRecords()
    {
        recordmodel.clear();
    }

    function getRecordCount()
    {
        return recordmodel.count;
    }

    ZybText {
        text: qsTr("无最近通话")
        anchors.centerIn: parent
        visible: recordmodel.count === 0
    }

    ListModel {
        id:recordmodel
    }

    ListView {
        id:view
        focus: true
        anchors.fill: parent
        clip: true
        spacing: 10
        anchors.left: parent.left
        anchors.right: parent.right

        model: recordmodel
        delegate: Rectangle {
            id:control
            width: parent.width
            height: 122
            radius: 6
            color: "#993C3D42"
            ZybText {
                id: other
                font.styleName: "Bold"
                font.pixelSize: 38
                text: qsTr("家长")
                color: model.status? "#FF7256":"#FFFFFF"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 24
            }

            Image {
                id: imgStatus
                fillMode: Image.PreserveAspectFit
                clip: true
                source: "qrc:/images/phoneToOther.png"
                visible: model.state === "out"
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 30
            }

            ZybText {
                id: recordTime
                text: model.time
                color: "#FFFFFF"
                anchors.left: other.left
                anchors.top:other.bottom
                anchors.topMargin: 16
            }


        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
