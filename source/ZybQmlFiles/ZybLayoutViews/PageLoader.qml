import QtQuick 2.0
import QtQuick.Controls 2.3

Loader{
    asynchronous: true
    active: false
    visible: true
    property string name:""
    StackView.onActivated: {
        visible = true
        active = true
    }
}
