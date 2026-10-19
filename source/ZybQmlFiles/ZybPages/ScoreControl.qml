import QtQuick 2.0

Item {
    id:root
    width: 232
    height: 40
    property var score: 0
    Image {
        id: image1
        anchors.top: parent.top
        anchors.left: parent.left
        source: "qrc:/images/score_empty.png"
    }

    Image {
        id: image2
        anchors.top: parent.top
        anchors.left: image1.right
        anchors.leftMargin: 8
        source: "qrc:/images/score_empty.png"
    }

    Image {
        id: image3
        anchors.top: parent.top
        anchors.left: image2.right
        anchors.leftMargin: 8
        source: "qrc:/images/score_empty.png"
    }

    Image {
        id: image4
        anchors.top: parent.top
        anchors.left: image3.right
        anchors.leftMargin: 8
        source: "qrc:/images/score_empty.png"
    }

    Image {
        id: image5
        anchors.top: parent.top
        anchors.left: image4.right
        anchors.leftMargin: 8
        source: "qrc:/images/score_empty.png"
    }

    function setScore(ascore){
        root.score = ascore;
        image1.source = getIcon(1,ascore);
        image2.source = getIcon(2,ascore);
        image3.source = getIcon(3,ascore);
        image4.source = getIcon(4,ascore);
        image5.source = getIcon(5,ascore);
    }

    function getIcon(num,ascore){
        var scoreStart = num*20 - 20;
        var scoreMid = num*20 - 10;
        var scoreEnd = num*20;
        if(ascore < scoreMid){
            return "qrc:/images/score_empty.png";
        }

        if(ascore >= scoreMid && ascore < scoreEnd){
            return "qrc:/images/score_half.png";
        }

        if(ascore >= scoreEnd){
            return "qrc:/images/score_full.png";
        }
    }
}
