import QtQuick 2.0

import QtQuick.Controls 2.2


CheckBox {
    id: control

    property alias sourceSize: indicatorIcon.sourceSize

    indicator: Image {
        id: indicatorIcon
        source: "qrc:/images/unchecked.png"
        //sourceSize: AppTheme.currentTheme.size_icon_checkbox

        Image {
            visible: control.checked
            source: "qrc:/images/checked.png"
            //sourceSize: indicatorIcon.sourceSize
        }
    }
}
