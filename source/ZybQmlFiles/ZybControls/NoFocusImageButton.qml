import QtQuick 2.0
import QtQuick.Controls 2.3
import "../Style"
Button
{
    id:root
    property  alias source: img.source
    property color backgroundTheme: Style.digbgColor
    checkable: true
    property int radius: 6
    implicitWidth: 111
    implicitHeight: 56

    background: Rectangle {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight
        color: backgroundTheme//root.checked ? "#1DC09E" : Qt.rgba(255, 255, 255, 0.8)
        //opacity: enabled ? 1 : 0.3
        //border.color: wifibtn.down ? "#17a81a" : "#21be2b"
        //border.width: 1
        radius: root.radius
    }
    contentItem: Image {
        id:img
        anchors.centerIn: parent
        fillMode: Image.Pad //图像的填充方式-保持图片原样
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(checkable)
            {
                if(root.checked)
                    return;
                root.checked = !root.checked
                root.clicked()
            }
            else
            {
                root.clicked()
            }

        }
    }

}

