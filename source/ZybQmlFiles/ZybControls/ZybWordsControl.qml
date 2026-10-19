import QtQuick 2.0
import QtQuick.Controls 2.3
import com.zyb.PingDefine 1.0

Item {
    id:root
    height: 56
    property int dictionaryType: 0 //0:汉语，1:英汉,2:汉英
    property int wordType: 0 //0:句子,1:词组,2:单词
    property var wordData: new Object

    signal signalQuery(var strData);

    ZybWordTransButton{
        id:parseBtn
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 100
        visible: !wordList.isSingleWord
        textItem.text: qsTr("整句")
        //focus: !wordList.isAllSent
        isAllsent: true//wordList.isAllSent
//        checked: true
        onClicked: {
            if(!isAllsent){
                isAllsent = true;
                wordList.isAllSent = true;
                wordList.initModel();
            }
        }
    }

    ZybWordsList{
        id:wordList
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: isSingleWord ? parent.left : parseBtn.right
        anchors.right: parent.right
//        anchors.rightMargin: 30
        anchors.leftMargin: 16

        onSignalSearch: {
            if(!isInit){
                parseBtn.isAllsent = false;
            }

            emit: signalQuery(strData);
        }

//        onSignalCClicked: {
//            console.log("onSignalClicked parseBtn.focus = false")
//            parseBtn.focus = false;
//        }
    }
    function setData(scanData){
        parseBtn.isAllsent = true;
        wordList.isAllSent = true;
        wordList.setData(scanData);
    }

}
