import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "common"

Column {
  id: container
  property int fontSize: root.font.pointSize

  signal loginRequest()
  function login(session: int) {
    sddm.login(username.text, password.text, session);
  }

  function loginFailed() {
    notification.opacity = 1;
    password.text = ""
    if (notification_timeout.running) notification_timeout.stop();
    notification_timeout.start();
  }

  width: parent.width

  TextField {
    id: username
    width: parent.width * 0.5
    anchors.horizontalCenter: parent.horizontalCenter

    UserList {
      id: user_list
      height: parent.height
      width: height

      onUserSelected: {
        username.text = currentText;
        password.forceActiveFocus();
      }
    }

    onVisibleChanged: { if (visible && text.length == 0) forceActiveFocus(); }

    text: user_list.currentText

    placeholderText: config.username || text_const.userName
    horizontalAlignment: Text.AlignHCenter
    selectByMouse: true

    renderType: Text.QtRendering
    font.pointSize: fontSize * 1.2
    font.bold: true
    font.capitalization: config.boolValue("capitaliseUsername") ? Font.Capitalize : Font.MixedCase
    color: root.palette.text

    onAccepted: password.forceActiveFocus()
    KeyNavigation.down: password
    KeyNavigation.left: user_list
    KeyNavigation.backtab: user_list
    KeyNavigation.tab: password

    background: null
  }

  RowLayout {
    anchors.horizontalCenter: username.horizontalCenter
    width: username.width

    TextField {
      id: password
      Layout.fillWidth: true

      onVisibleChanged: { if (visible && username.text.length > 0) forceActiveFocus(); }

      placeholderText: config.password || text_const.password
      horizontalAlignment: Text.AlignHCenter
      selectByMouse: true
      echoMode: reveal_passwd.checked ? TextInput.Normal : (config.passwordEchoStyle == "off" ? TextInput.NoEcho : TextInput.Password)

      renderType: Text.QtRendering
      font.pointSize: fontSize
      color: root.palette.text
      passwordCharacter: "•"

      onAccepted: {focus = false; loginRequest()}
      KeyNavigation.right: login_button

      background: Rectangle {
        color: "transparent"
        radius: 8
        border.color: parent.focus ? root.palette.accent : root.palette.text
        border.width: 1
      }

      Label {
        anchors.left: parent.left
        height: parent.height
        width: height

        opacity: keyboard.capsLock

        Text {
          horizontalAlignment: Text.AlignRight
          verticalAlignment: Text.AlignVCenter

          renderType: Text.QtRendering
          text: "󰪛"
          font.family: iconFont
          color: root.palette.text
          font.pointSize: fontSize * 1.3
        }

        Behavior on opacity {
          NumberAnimation { duration: 75 * root.animationsEnabled }
        }
      }

      CheckBox {
        id: reveal_passwd

        anchors.right: parent.right
        height: parent.height
        width: height

        indicator: Text {
          height: parent.height
          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter

          renderType: Text.QtRendering
          text: parent.checked ? "󰈉": "󰈈"
          font.family: iconFont
          color: root.palette.text
          opacity: parent.hovered ? 1 : 0.66
          font.pointSize: fontSize * 1.2

          Behavior on opacity {
            NumberAnimation { duration: 75 * root.animationsEnabled }
          }
        }

        onPressed: password.forceActiveFocus()
      }
    }

    Button {
      id: login_button
      visible: username.text.length > 0 && (config.boolValue("allowEmptyPassword") || (password.text.length > 0))
      implicitHeight: password.height
      Layout.fillWidth: false
      Layout.preferredWidth: implicitHeight

      Text {
        id: icon
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        renderType: Text.QtRendering
        font.pointSize: fontSize * 1.4
        font.family: iconFont
        color: login_button.focus ? root.palette.accent : root.palette.text
        text: LayoutMirroring.enabled ? "" : ""
      }

      onClicked: loginRequest()
      KeyNavigation.left: password

      background: Rectangle {
        color: "transparent"
        radius: 8
        border.color: parent.focus? root.palette.accent : root.palette.text
        border.width: 1
      }

      states: [
        State {
          name: "selected"
          when: login_button.pressed
          PropertyChanges {
            target: login_button.background
            color: root.palette.accent
            border.color: root.palette.text
          }
          PropertyChanges {
            target: icon
            color: root.palette.text
          }
        }
      ]

    }

  }

  Text {
    id: notification
    text: config.loginFailed || text_const.loginFailed
    opacity: 0

    renderType: Text.QtRendering
    color: root.palette.accent
    font.pointSize: fontSize * 0.825
    height: fontSize * 3
    verticalAlignment: Qt.AlignVCenter

    anchors.horizontalCenter: parent.horizontalCenter

    Behavior on opacity {
      NumberAnimation { duration: 100 * root.animationsEnabled }
    }

    Timer {
      id: notification_timeout
      running: false
      interval: 2500
      onTriggered: notification.opacity = 0
    }
  }
}
