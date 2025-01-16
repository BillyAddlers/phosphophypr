import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
  id: item
  Layout.fillWidth: true
  Layout.preferredHeight: fontSize * 3

  spacing: fontSize
  Layout.leftMargin: 10
  Layout.rightMargin: 10

  required property int index;
  property alias text: label.text
  property alias icon: icon.text
  property alias enabled: toggle.enabled
  property alias checked: toggle.checked
  signal toggled(int id)

  Text {
    id: icon
    visible: config.boolValue("iconsInMenus")
    renderType: Text.QtRendering
    font.pointSize: fontSize
    font.family: config.iconFont
    color: root.palette.buttonText
  }

  Text {
    id: label
    renderType: Text.QtRendering
    font.family: root.font.family
    font.pointSize: fontSize
    color: root.palette.buttonText
    Layout.fillWidth: true
  }

  Switch {
    id: toggle

    Layout.preferredHeight: indicator.implicitHeight + 10
    Layout.preferredWidth: indicator.implicitWidth + 10
    Layout.fillWidth: false

    onClicked: item.toggled(index)

    background: Rectangle {
      color: "transparent"
      radius: 8
    }

    indicator: Rectangle {
      anchors.centerIn: parent
      implicitHeight: fontSize * 1.5
      implicitWidth: fontSize * 3
      radius: implicitHeight / 2
      color: parent.checked ? root.palette.accent : Qt.darker(root.palette.button, 1.3)
      border.color: parent.checked ? root.palette.accent : "#cccccc"

      Text {
        visible: true
        height: parent.height
        width: height
        x: checked ? 0 : parent.width - width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        renderType: Text.QtRendering
        text: checked ? "" : ""
        font.family: root.iconFont
        font.pointSize: fontSize * 0.7
        color: root.palette.buttonText
      }

      Rectangle {
        id: knob
        x: checked ? parent.width - width : 0
        height: parent.implicitHeight
        width: height
        radius: height / 2
        color: toggle.down ? "#cccccc" : root.palette.buttonText
        border.color: checked ? root.palette.accent : "#999999"
      }
    }
    states: [
      State {
        when: !enabled
        PropertyChanges {
          target: toggle.indicator
          color: "#555555"
          border.color: "#333333"
          opacity: 0.3
        }
        PropertyChanges {
          target: toggle
          checked: false
        }
        PropertyChanges {
          target: knob
          color: "#cccccc"
          border.color: Qt.lighter(toggle.indicator.color, 1.5)
        }
      }
    ]

  }

}
