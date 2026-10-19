import QtQuick 2.0
import "../Style"

Rectangle {
    id:followupView
    color: Style.mainbgColor
    anchors.fill: parent
    property var pageState: 0
    property var worddata: ""

    MouseArea{
        anchors.fill: parent
        onPressed: {
        }
        onReleased: {
        }
        onClicked: {
        }
    }

    Timer{
            id:backTimer
            interval: 100
            running: false
            triggeredOnStart: false
            repeat: false
            onTriggered: {
                followupView.destroy();
            }
        }

    FollowUpStartPage{
        id:followStartPage
        anchors.fill: parent
        visible: (followupView.pageState === 0)
        onBack: {
            QueryWordManager.playStop();
            backTimer.running = true;
        }
        onGotoResultPage: {
            followResultPage.setData(resObj);
            pageState = 1;
            QueryWordManager.playStop();
        }
    }

    FollowUpResultPage{
        id:followResultPage
        anchors.fill: parent
        visible: (followupView.pageState === 1)
        onBack: {
            followupView.destroy();
            QueryWordManager.playStop();
        }
        onBackToFollowStart: {
            followupView.pageState = 0;
            QueryWordManager.playStop();
        }
    }

    Component.onCompleted: {
        console.log("++++++++++++++width:",width,"height:",height);
        pageState = 0;
        followStartPage.setData(worddata);
    }

    Connections {
        target: scanManager;

        onSig_scanDown:{
            //followupView.destroy();
            backTimer.running = true;
        }
    }
}
