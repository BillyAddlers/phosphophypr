import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "common"

ComboBox {
  id: container
  property int fontSize: root.font.pointSize
  background: null

  indicator: Button {
    anchors.fill: parent
    Text {
      anchors.centerIn: parent
      renderType: Text.QtRendering
      text: "󰍹"
      font.family: iconFont
      color: container.focus ? root.palette.accent : root.palette.text
      font.pointSize: fontSize * 1.5

      Text {
        visible: config.boolValue("displaySession")
        anchors {
          leftMargin: fontSize
          left: parent.right
          verticalCenter: parent.verticalCenter
        }
        renderType: Text.QtRendering
        text: container.currentText
        font.family: root.font.family
        color: root.palette.text
        font.pointSize: fontSize
      }
    }

    background: Rectangle {
      color: "transparent"
    }

    onPressed: {
      container.popup.open()
    }

  }

  model: sessionModel
  currentIndex: model.lastIndex
  textRole: "name"
  onActivated: currentIndex = highlightedIndex

  delegate: ItemDelegate {
    id: session_item
    highlighted: container.currentIndex === index

    implicitHeight: fontSize * 3
    implicitWidth: label.width
    Layout.fillWidth: true

    Text {
      id: label
      padding: 10
      anchors.verticalCenter: session_item.verticalCenter

      renderType: Text.QtRendering
      text: name
      font.family: root.font.family
      font.pointSize: fontSize
      color: root.palette.buttonText
    }

    background: Rectangle {
      color: "transparent"
    }

    states: [
      State {
        name: "selected"
        when: session_item.highlighted
        PropertyChanges {
          target: session_item.background
          color: root.palette.accent
        }
      },
      State {
        name: "highlighted"
        when: container.highlightedIndex === index
        PropertyChanges {
          target: session_item.background
          color: "#777777"
          opacity: 0.4
        }
      }
    ]

  }

  popup: PopupPanel {
    x: (parent.width - width) * root.LayoutMirroring.enabled

    model: container.delegateModel
  }
}
