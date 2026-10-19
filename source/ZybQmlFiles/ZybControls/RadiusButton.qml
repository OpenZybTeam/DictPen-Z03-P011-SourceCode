import QtQuick 2.0

Rectangle {
    id: root
    height:100
    width:200

    property color checkedBgColor : "#12CFA7"
    property color uncheckedBgColor : "#3C3D42"
    property color checkedTextColor : "#FFFFFF"
    property color uncheckedTextColor : "#999999"
    property string title : ""
    property int textSize : 26
    property color textColor : checked?checkedTextColor:uncheckedTextColor
    property bool checked: false
    color: checked?checkedBgColor:uncheckedBgColor

    property int radiusCorners: Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop | Qt.AlignBottom /* Default: */
    /*
                            Qt.AlignLeft |      Qt.AlignLeft |      Qt.AlignRight |     Qt.AlignLeft |      Qt.AlignLeft |
                            Qt.AlignRight |     Qt.AlignTop |       Qt.AlignTop |       Qt.AlignRight |     Qt.AlignRight |
              None:0        Qt.AlignTop |       Qt.AlignBottom      Qt.AlignBottom      Qt.AlignTop         Qt.AlignBottom
                            Qt.AlignBottom
        *****************     *************       ***************   ***************       *************     *****************
        *               *    *             *     *              *   *              *     *             *    *               *
        *               *   *               *   *               *   *               *   *               *   *               *
        *               *   *               *   *               *   *               *   *               *   *               *
        *               *   *               *   *               *   *               *   *               *   *               *
        *               *   *               *   *               *   *               *   *               *   *               *
        *               *   *               *   *               *   *               *   *               *   *               *
        *               *    *             *     *              *   *              *    *               *    *             *
        *****************     *************       ***************   ***************     *****************     *************
    */

    Repeater {
        model: [ {
                x: 0,
                y: 0,
                visible: internal.aligns(Qt.AlignLeft | Qt.AlignTop),
                radius: root.radius
            },
            {
                x: root.width - root.radius,
                y: 0,
                visible: internal.aligns(Qt.AlignRight | Qt.AlignTop),
                radius: root.radius
            },
            {
                x: 0,
                y: root.height - root.radius,
                visible: internal.aligns(Qt.AlignLeft | Qt.AlignBottom),
                radius: root.radius
            },
            {
                x: root.width - root.radius,
                y: root.height - root.radius,
                visible: internal.aligns(Qt.AlignRight | Qt.AlignBottom),
                radius: root.radius
            } ]

        Rectangle {
            x: modelData.x; y: modelData.y
            width: modelData.radius; height: width
            visible: !modelData.visible
            color: parent.color
        }
    }
    QtObject {
        id: internal

        function aligns(direction) {
            return (root.radiusCorners & direction) === direction
        }
    }

    ZybText
    {
        id:content
        text: title
        font.pixelSize: textSize
        font.styleName: "Bold"
        color: textColor
        anchors.centerIn: parent
    }
}
