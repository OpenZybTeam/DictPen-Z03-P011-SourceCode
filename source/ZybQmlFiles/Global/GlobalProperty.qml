import QtQuick 2.0
pragma Singleton

QtObject {
    property bool isUpdatePageVisible: false //升级页面是否可见
    property bool isUpdating: false //是否正在升级
    property bool isOtaDownloadAbord: false
    property int autoSpeekDelay: 300
    property bool isWifiPageVisible: false
    property bool isCameraQuestion: false
}
