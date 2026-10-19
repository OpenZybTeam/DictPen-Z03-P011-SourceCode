import QtQuick 2.10
import QtQuick.Controls 2.3
Item {
    id: root
    property alias containsMouse: mouseArea.containsMouse
    signal posChange(int xOffset, int yOffset)
    implicitWidth: 24
    implicitHeight: 24
    property int posType: Qt.ArrowCursor
    readonly property int posLeftTop: Qt.SizeFDiagCursor
    readonly property int posLeft: Qt.SizeHorCursor
    readonly property int posLeftBottom: Qt.SizeBDiagCursor
    readonly property int posTop: Qt.SizeVerCursor
    readonly property int posBottom: Qt.SizeVerCursor
    readonly property int posRightTop: Qt.SizeBDiagCursor
    readonly property int posRight: Qt.SizeHorCursor
    readonly property int posRightBottom: Qt.SizeFDiagCursor

    property alias mouseAreaObject: mouseArea
    signal clicked(real x, real y)
    signal doubleClicked(real x, real y)
    MouseArea {
        id: mouseArea
        //anchors.fill: parent
//        anchors.left: parent.left-6
//        anchors.right: parent.right+6
//        anchors.top: parent.top-6
//        anchors.bottom: parent.bottom+6
        anchors.centerIn: parent
        width: parent.width + 16
        height: parent.height + 16

        hoverEnabled: true
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            if (containsMouse) {
                cursorShape = posType;
            } else {
                cursorShape = Qt.ArrowCursor;
            }
        }
        onPressedChanged: {
            if (containsPress) {
                lastX = mouseX;
                lastY = mouseY;
            }
        }
        onPositionChanged: {
            if (pressed) {
                posChange(mouseX - lastX, mouseY - lastY)
            }
        }
        onClicked: {
            root.clicked(mouseX, mouseY)
        }
        onDoubleClicked: {
            root.doubleClicked(mouseX, mouseY)
        }
    }
}
