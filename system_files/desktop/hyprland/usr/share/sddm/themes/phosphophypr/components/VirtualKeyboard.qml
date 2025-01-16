import QtQuick 2.15
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Settings 2.15

Item {
  id: keyboard_container
  height: input_panel.active ? input_panel.height : 0

  InputPanel {
    id: input_panel
    active: root.activateVirtualKeyboard && (Qt.inputMethod.visible || config.boolValue("forceKeyboardVisible"))
    visible: active

    z: 1
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    Binding {
      target: VirtualKeyboardSettings
      property: "wordCandidateList.autoHideDelay"
      value: 1000
    }
  }

}
