import QtQuick 2.0
import com.zyb.PingDefine 1.0

Item {
    id:root
    property var pageType: "historypage"
    state: "word"

    states: [
        State {
            name: "question"
            StateChangeScript {
                script: {
                    console.log("question state")
                }
            }
        },
        State {
            name: "word"
            StateChangeScript {
                script: {
                    console.log("word state")
                }
            }
        }
    ]

    HistoryPage{
        id:questionPage
        anchors.fill: parent
        visible: root.state === "question"
        onGotoWordPage: {
            root.state = "word"
            pingManager.addPingData(PingDefine.PING_EVENT_HISTORY_DICT);
        }
    }

    WordHistoryPage{
        id:wordPage
        anchors.fill: parent
        visible: root.state === "word"
        onGotoQuestionPage: {
            root.state = "question"
            pingManager.addPingData(PingDefine.PING_EVENT_HISTORY_TID);
        }
    }

    function initQuestionPage(imgM,editVisble){

    }

    function initWordPage(wordModel,editVisible){
    }

    Component.onCompleted:
    {
        pingManager.addPingData(PingDefine.PING_EVENT_HISTORY_NUM);
    }

}
