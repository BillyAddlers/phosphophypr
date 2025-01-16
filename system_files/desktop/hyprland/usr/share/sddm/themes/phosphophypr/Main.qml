import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0 as SDDM

import "components"
import "components/common"

Pane {
  id: root
  SDDM.TextConstants {id: text_const}

  palette {
    accent: config.accentColour
    highlight: config.accentColour
    text: config.primaryColour
    placeholderText: Qt.lighter(config.primaryColour, 0.6)
    buttonText: config.popupsForegroundColour
    button: config.popupsBackgroundColour
  }

  height: config.height || Screen.height
  width: config.width || Screen.width
  padding: 0

  readonly property int verticalThird: height * 0.33
  readonly property int horizontalThird: width * 0.33

  LayoutMirroring.enabled: config.mirrorLayout == "auto" ? Qt.locale().textDirection == Qt.RightToLeft : config.boolValue("mirrorLayout")
  LayoutMirroring.childrenInherit: true

  property bool activateVirtualKeyboard: config.boolValue("virtualKeyboardStartActive")
  property bool animationsEnabled: config.boolValue("enableAnimations")

  font.family: config.fontFamily
  font.pointSize: config.fontSize || (Math.min(width, height) / 80)
  property string iconFont: config.iconFont || config.fontFamily

  property string backgroundType: config.type || "color"

  background: Rectangle {
    height: root.height
    width: root.width
    color: config.backgroundColour

    Image {
      id: wallpaper

      height: root.height
      width: root.width

      source: root.backgroundType === "image" ? config.background : config.wallpaper
      fillMode: config.boolValue("fitWallpaper") ? Image.PreserveAspectFit : Image.PreserveAspectCrop

      asynchronous: true
      cache: true
      clip: true

      RecursiveBlur {
        visible: false
        id: blur_wallpaper
        anchors.fill: wallpaper
        source: wallpaper
        radius: config.blurRadius
        loops: config.blurRecursiveLoops
      }
    }

    Rectangle {
      id: darken_wallpaper
      anchors.fill: parent
      color: "black"
      opacity: 0
    }
  }

  Pane {
    id: greeter
    visible: true
    x: 0; y: 0
    width: root.width
    height: root.height

    clip: true
    background: null

    padding: config.dateTimePadding

    Clock {
      id: datetime
    }

    Label {
      anchors {
        horizontalCenter: parent.horizontalCenter

        verticalCenter: datetime.is_center_center ? undefined : parent.verticalCenter
        bottom: datetime.is_center_center ? datetime.top : undefined
      }

      color: root.palette.text
      font.pointSize: datetime.fontSize

      renderType: Text.QtRendering
      text: config.greeting
      textFormat: Text.MarkdownText
      horizontalAlignment: Text.AlignHCenter
    }

    TapHandler {
      id: tap_handler
      enabled: parent.visible
      onTapped: gotoLogin()
    }
  }

  Pane {
    id: login_page
    visible: false
    background: null

    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      bottom: vkbd_container.top
    }

    padding: root.font.pointSize

    ColumnLayout {
      anchors.fill: parent
      spacing: 0

      Item {
        id: login_container
        Layout.fillHeight: true
        Layout.fillWidth: false
        Layout.preferredWidth: Math.min(login_form.fontSize * 60, login_page.width)
        Layout.alignment: Qt.AlignHCenter

        LoginForm {
          id: login_form

          anchors.centerIn: parent

          onLoginRequest: login_form.login(session.currentIndex);
          KeyNavigation.down: session
        }
      }

      RowLayout {
        id: footer

        Layout.fillHeight: false
        Layout.preferredHeight: 36
        Layout.preferredWidth: root.width

        spacing: root.font.pointSize * 0.5

        SessionSelection {
          id: session
          Layout.preferredHeight: parent.Layout.preferredHeight
          Layout.preferredWidth: Layout.preferredHeight

          KeyNavigation.right: layout
          KeyNavigation.tab: KeyNavigation.right
        }

        Rectangle { // spacer
          Layout.fillWidth: true
        }

        LayoutSelection {
          id: layout
          Layout.preferredHeight: parent.Layout.preferredHeight
          Layout.preferredWidth: Layout.preferredHeight

          KeyNavigation.left: session
          KeyNavigation.right: accessibility
          KeyNavigation.tab: KeyNavigation.right
        }

        AccessibilityMenu {
          id: accessibility
          Layout.preferredHeight: parent.Layout.preferredHeight
          Layout.preferredWidth: Layout.preferredHeight

          KeyNavigation.left: layout
          KeyNavigation.right: power
          KeyNavigation.tab: KeyNavigation.right
        }

        PowerMenu {
          id: power
          Layout.preferredHeight: parent.Layout.preferredHeight
          Layout.preferredWidth: Layout.preferredHeight

          KeyNavigation.left: accessibility
        }
      }

    }
  }

  Rectangle {
    id: vkbd_container
    visible: false

    width: parent.width
    implicitHeight: virtual_keyboard.implicitHeight
    anchors.bottom: parent.bottom
    color: "transparent"

    Loader {
      id: virtual_keyboard

      width: parent.width
      z: 1

      source: "components/VirtualKeyboard.qml"
      asynchronous: true

      onStatusChanged: {
        var rect = Qt.inputMethod.keyboardRectangle;
        if (status == Loader.Ready) accessibility.keyboardStatusChanged(rect.width > 0 || rect.height > 0);
      }
    }
  }

  focus: true
  Keys.onReleased: {
    if (state == "") gotoLogin()
  }
  function gotoLogin() {
    root.state = "loginForm"
  }

  states: State {
    name: "loginForm"
    when: config.boolValue("skipToLogin")
    PropertyChanges {
      target: darken_wallpaper
      opacity: config.darkenWallpaper
    }
    PropertyChanges {
      target: blur_wallpaper
      visible: true
    }
  }

  transitions: Transition {
    to: "loginForm"
    SequentialAnimation {
      ParallelAnimation {
        NumberAnimation {
          target: greeter
          property: "opacity"
          from: 1; to: 0
          duration: 150 * root.animationsEnabled
        }
        NumberAnimation {
          target: greeter
          property: config.transitionDirection[config.transitionDirection.length-1] == "y" ? "y" : "x"
          from: 0; to: (property == "y" ? root.verticalThird : root.horizontalThird) * (2 * (config.transitionDirection[0] != "-") - 1)
          duration: 150 * root.animationsEnabled
        }
      }

      ScriptAction {
        script: {
          greeter.visible = false;
          login_page.visible = true;
          vkbd_container.visible = true;
        }
      }
      NumberAnimation {
        target: login_page
        property: "opacity"
        from: 0; to: 1
        duration: 50 * root.animationsEnabled
      }
    }
  }

  Connections {
    target: sddm
    function onLoginSucceeded() {}
    function onLoginFailed() { login_form.loginFailed(); }
  }
}
