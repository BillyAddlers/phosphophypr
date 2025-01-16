import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
  property int fontSize: root.font.pointSize * config.realValue("fontSizeMultiplier")
  property date value: new Date()

  spacing: -fontSize / 2

  readonly property var position_str: config.dateTimePosition.split(" ")
  readonly property bool is_left: position_str[position_str.length-1] == "left"
  readonly property bool is_right: position_str[position_str.length-1] == "right"
  readonly property bool is_top: position_str[0] == "top"
  readonly property bool is_bottom: position_str[0] == "bottom"
  readonly property bool is_center_center: !(is_left || is_right) && !(is_top || is_bottom)

  anchors {
    left: is_left ? parent.left : undefined
    horizontalCenter: !(is_left || is_right) ? parent.horizontalCenter : undefined
    right: is_right ? parent.right : undefined

    top: is_top ? parent.top: undefined
    verticalCenter: !(is_top || is_bottom) ? parent.verticalCenter : undefined
    bottom: is_bottom ? parent.bottom: undefined
  }

  Label {
    id: time_label
    visible: true

    anchors {
      left: is_left ? parent.left : undefined
      horizontalCenter: !(is_left || is_right) ? parent.horizontalCenter : undefined
      right: is_right ? parent.right : undefined
    }

    renderType: Text.QtRendering
    color: config.clockStyle == "outline" ? "transparent" : root.palette.text
    style: config.clockStyle == "outline" ? Text.Outline  : Text.Normal
    styleColor: root.palette.text
    font.pointSize: fontSize * 3

    function update() {
      text = Qt.formatTime(value, config.clockFormat)
    }
  }

  Label {
    id: date_label

    anchors {
      left: is_left ? parent.left : undefined
      horizontalCenter: !(is_left || is_right) ? parent.horizontalCenter : undefined
      right: is_right ? parent.right : undefined
    }

    renderType: Text.QtRendering
    color: root.palette.text
    font.pointSize: Math.min(1.4 * (time_label.width / text.length), fontSize * 2)

    function update() {
      text = value.toLocaleDateString(Qt.locale(config.locale), config.dateFormat)
    }
  }

  Timer {
    interval: 1000
    repeat: true
    running: true
    onTriggered: {
      value = new Date()
      time_label.update()
      date_label.update()
    }
  }

  Component.onCompleted: {
    time_label.update()
    date_label.update()
  }
}
