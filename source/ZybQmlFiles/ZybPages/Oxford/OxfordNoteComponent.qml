import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../Style"

Item {
    id:root
    height: enText.height
    property var controlData: null

    Text {
        id: enText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 52
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        font.family: Style.engFontFamily
        font.pixelSize: 28
    }




    Component.onCompleted: {
        var strHead = "<html>
                <head>
                    <style>
                        @font-face {
                            font-family: 'myfont1';
                            src: url('/usr/share/fonts/ttf/SourceHanSansSC-Bold.OTF'),
                            format('opentype');
                        }
                        @font-face {
                            font-family: 'myfont2';
                            src: url('/usr/share/fonts/ttf/SourceHanSansSC-Normal.OTF'),
                            format('opentype');
                        }
                    </style>
                </head>
                <body>"
        var strTaile = "</body>
                </html>"

        var strNormalFront = "<span style= 'font-family:myfont2;font-weight:200;color:#FFFFFF'>";
        var strLast = "</span>";
        var strColorFront = "<span style= 'font-family:myfont1;font-weight:200;color:#00D3A5'>";
        var strColorLast = "</span>";
        var strText = "";
        var cfText = "";

        if(controlData["mark"] !== "null"){
            strText += strNormalFront + controlData["mark"] + " " + strLast;
        }

        if(controlData["text"] !== "undefined"){
            strText += strColorFront + controlData["text"] + " " + strColorFront;
        }

        strText = strHead + strText + strTaile;
        enText.text = strText;
    }

}
