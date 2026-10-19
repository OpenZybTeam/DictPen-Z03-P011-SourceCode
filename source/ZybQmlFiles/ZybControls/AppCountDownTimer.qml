import QtQuick 2.0

Timer {
    id: timer
    interval: 1000
    repeat: true

    property int currentTime: 0
    signal stoped

    onTriggered: {
        currentTime--
        if (currentTime <= 0) {
            currentTime = 0
            timer.stop()
            stoped()
        }
    }
}
