import QtQuick 2.0
import com.zyb.PingDefine 1.0

Item {
    id:root
    property var pageType: "storepage"
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
    StorePage{
        id:questionPage
        anchors.fill: parent
        visible: root.state === "question"
        notext:qsTr("还没有收藏的内容哦~")
        onGotoWordPage: {
            console.log("store word clicked");
            root.state = "word"
            pingManager.addPingData(PingDefine.PING_EVENT_STORE_DICT_CLICK);
        }
    }

    WordStorePage{
        id:wordPage
        anchors.fill: parent
        visible: root.state === "word"
        onGotoQuestionPage: {
            console.log("store tid clicked");
            root.state = "question"
            pingManager.addPingData(PingDefine.PING_EVENT_SOTRE_TID_CLICK);
        }
    }

    Component.onCompleted: {
        pingManager.addPingData(PingDefine.PING_EVENT_STORE_ENTER);
    }

    function initQuestionPage(imgM,editVisble){
        questionPage.init(imgM,editVisble);
    }

    function initWordPage(wordModel,editVisible){
    }

}
