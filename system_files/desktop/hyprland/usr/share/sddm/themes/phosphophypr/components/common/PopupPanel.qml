import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
  id: menu
  y: -(height + root.font.pointSize / 2)

  property var model
  property Component delegate
  property alias interactive: flickable.interactive
  property real delegateHeight: fontSize * 3

  // maximum number of options to show at once, scroll/flick to see the rest
  // adding .5 works as a visual hint there's more options by displaying half of the next button
  property real max_size: 5.5

  padding: 0
  topPadding: background.radius
  bottomPadding: background.radius

  background: Rectangle {
    color: root.palette.button
    radius: 8
  }

  contentItem: Flickable {
    id: flickable
    clip: true
    implicitWidth: contentWidth
    implicitHeight: interactive ? Math.min(contentHeight, menu.max_size * (menu.delegateHeight + delegate_container.spacing)) : contentHeight
    contentWidth: delegate_container.width
    contentHeight: delegate_container.height

    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: ScrollBar { }

    ColumnLayout {
      id: delegate_container
      spacing: 4
      Repeater {
        model: menu.model
        delegate: menu.delegate
      }
    }
  }

  enter: Transition {
    NumberAnimation { property: "height"; from: 0.0; to: implicitHeight; duration: 50 * root.animationsEnabled }
  }
  exit: Transition {
    NumberAnimation { property: "height"; from: implicitHeight; to: 0.0; duration: 50 * root.animationsEnabled }
  }

}
