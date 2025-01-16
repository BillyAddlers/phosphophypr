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
      text: "󰐥"
      font.family: iconFont
      color: container.focus ? root.palette.accent : root.palette.text
      font.pointSize: fontSize * 1.5
    }

    background: Rectangle {
      color: "transparent"
    }

    onPressed: {
      container.popup.open()
    }

  }

  function actionPressed() {
    if (currentIndex == 0) sddm.suspend();
    else if (currentIndex == 1) sddm.hibernate();
    else if (currentIndex == 2) sddm.reboot();
    else if (currentIndex == 3) sddm.powerOff();
  }

  property bool forcePowerOptions: false

  model: [
    {'icon': "", 'label': config.suspend   || text_const.suspend  , 'enabled': sddm.canSuspend  },
    {'icon': "󰍷", 'label': config.hibernate || text_const.hibernate, 'enabled': sddm.canHibernate},
    {'icon': "", 'label': config.reboot    || text_const.reboot   , 'enabled': sddm.canReboot   },
    {'icon': "", 'label': config.poweroff  || text_const.shutdown , 'enabled': sddm.canPowerOff },
  ]
  onActivated: {
    currentIndex = highlightedIndex;
    actionPressed();
  }

  delegate: ItemDelegate {
    id: power_option
    visible: forcePowerOptions || modelData['enabled']

    implicitHeight: fontSize * 3
    implicitWidth: content_item.width
    Layout.fillWidth: true

    Row {
      id: content_item
      spacing: fontSize
      anchors.verticalCenter: power_option.verticalCenter
      leftPadding: 10
      rightPadding: 10
      Text {
        visible: config.boolValue("iconsInMenus")
        renderType: Text.QtRendering
        text: modelData['icon']
        font.family: iconFont
        font.pointSize: fontSize
        color: root.palette.buttonText
      }
      Text {
        id: label
        renderType: Text.QtRendering
        text: modelData['label']
        font.family: root.font.family
        font.pointSize: fontSize
        color: root.palette.buttonText
      }
    }
    onClicked: {
      currentIndex = index;
    }

    background: Rectangle {
      color: "transparent"
    }

    states: [
      State {
        name: "selected"
        when: power_option.activeFocus
        PropertyChanges {
          target: power_option.background
          color: root.palette.accent
        }
      },
      State {
        name: "highlighted"
        when: container.highlightedIndex === index
        PropertyChanges {
          target: power_option.background
          color: "#777777"
          opacity: 0.4
        }
      }
    ]

  }

  popup: PopupPanel {
    x: (parent.width - width) * !(root.LayoutMirroring.enabled)
    interactive: false

    model: container.delegateModel
  }

}
