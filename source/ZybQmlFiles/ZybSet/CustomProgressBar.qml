import QtQuick 2.0
import QtQuick.Controls 2.3

ProgressBar {
    id:control
    from:0
    to:100
    background: Rectangle {
      implicitWidth: 800
      implicitHeight: 8
      color: "#993C3D42"
      radius: 4
  }

  contentItem: Item {
      implicitWidth: 800
      implicitHeight: 8
      clip: true

      Rectangle {
          width: control.visualPosition * parent.width
          height: parent.height
          radius: 4
          visible: !control.indeterminate
          color: "#FF12CFA7"
      }
      Rectangle{
          id:indeterminRect
          width: 100
          height: parent.height
          color: "#FF12CFA7"
          visible: control.indeterminate
          SequentialAnimation on x{
                      id:logAnimation
                      loops: Animation.Infinite
                      running:control.indeterminate
                      PropertyAnimation {
                          from:-indeterminRect.width
                          to: control.width
                          duration: 2500
                      }
                  }
      }
  }
}
