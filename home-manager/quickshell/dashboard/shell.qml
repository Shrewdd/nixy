import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

ShellRoot {
  id: root

  // Everforest Professional Color Palette
  readonly property string primaryColor: "#2d353b"    // base
  readonly property string surfaceColor: "#343f44"    // mantle  
  readonly property string cardColor: "#3d484d"       // crust
  readonly property string borderColor: "#4f585e"     // overlay1
  readonly property string accentColor: "#a7c080"     // green
  readonly property string textColor: "#d3c6aa"       // text
  readonly property string subTextColor: "#9da9a0"    // subtext1
  readonly property string tealColor: "#83c092"       // teal
  readonly property string yellowColor: "#dbbc7f"     // yellow

  property string gpuTemp: "-- °C"
  property string gpuTempRaw: "--"
  property string cpuTemp: "-- °C"
  property string cpuTempRaw: "--"

  readonly property string hourText: Qt.formatDateTime(clock.date, "hh")
  readonly property string minuteText: Qt.formatDateTime(clock.date, "mm")
  readonly property string dayText: Qt.formatDateTime(clock.date, "MMMM d, yyyy")

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  IpcHandler {
    target: "dashboard"
    function toggle(): void { dashboardWindow.toggleVisibility() }
    function show(): void { dashboardWindow.show() }
    function hide(): void { dashboardWindow.hide() }
  }

  // GPU Temperature monitoring via sysfs
  FileView {
    id: gpuTempFile
    path: "/sys/class/drm/card0/device/hwmon/hwmon0/temp1_input"
    watchChanges: true
    onTextChanged: {
      const tempText = text().trim()
      if (tempText && tempText !== "") {
        const tempValue = parseInt(tempText) / 1000
        root.gpuTemp = tempValue + "°C"
        root.gpuTempRaw = tempValue.toString()
      } else {
        root.gpuTemp = "-- °C"
        root.gpuTempRaw = "--"
      }
    }
    onLoadFailed: { root.gpuTemp = "-- °C"; root.gpuTempRaw = "--" }
  }

  // CPU Temperature monitoring via thermal zone
  FileView {
    id: cpuTempFile
    path: "/sys/class/thermal/thermal_zone0/temp"
    watchChanges: true
    onTextChanged: {
      const tempText = text().trim()
      if (tempText && tempText !== "") {
        const tempValue = parseInt(tempText) / 1000
        root.cpuTemp = tempValue + "°C"
        root.cpuTempRaw = tempValue.toString()
      } else {
        root.cpuTemp = "-- °C"
        root.cpuTempRaw = "--"
      }
    }
    onLoadFailed: { root.cpuTemp = "-- °C"; root.cpuTempRaw = "--" }
  }

  PanelWindow {
    id: dashboardWindow
    property int cardSpacing: 20
    readonly property int cardPadding: 32
    color: "transparent"
    visible: false
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: mainRow.implicitWidth
    implicitHeight: mainRow.implicitHeight
    Component.onCompleted: {
      const targetScreen = Quickshell.primaryScreen
      if (targetScreen && targetScreen.geometry) {
        x = (targetScreen.geometry.width - implicitWidth) / 2
        y = (targetScreen.geometry.height - implicitHeight) / 2
      }
    }
    function toggleVisibility() { visible = !visible }
    function show() { visible = true }
    function hide() { visible = false }

    RowLayout {
      id: mainRow
      anchors.centerIn: parent
      spacing: dashboardWindow.cardSpacing

      Rectangle { // Time Card
        id: timeCard
        Layout.preferredWidth: 280
        Layout.preferredHeight: 160
        radius: 24
        color: root.surfaceColor
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.1)
        Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) } GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.02) } } }
        ColumnLayout {
          anchors.centerIn: parent; spacing: 8
          RowLayout {
            Layout.alignment: Qt.AlignHCenter; spacing: 4
            Label { text: root.hourText; font.pixelSize: 52; font.weight: Font.Black; font.family: "SF Pro Display, Inter, system-ui"; color: root.textColor }
            Label { text: ":"; font.pixelSize: 52; font.weight: Font.Black; color: root.accentColor; SequentialAnimation on opacity { running: true; loops: Animation.Infinite; NumberAnimation { to: 0.3; duration: 1000 } NumberAnimation { to: 1.0; duration: 1000 } } }
            Label { text: root.minuteText; font.pixelSize: 52; font.weight: Font.Black; font.family: "SF Pro Display, Inter, system-ui"; color: root.textColor }
          }
          Label { text: root.dayText; font.pixelSize: 16; font.weight: Font.Medium; font.family: "SF Pro Display, Inter, system-ui"; color: root.subTextColor; Layout.alignment: Qt.AlignHCenter }
        }
        Rectangle { width: parent.width * 0.3; height: 2; radius: 1; color: root.accentColor; anchors.bottom: parent.bottom; anchors.bottomMargin: 16; anchors.horizontalCenter: parent.horizontalCenter; opacity: 0.6 }
      }

      Rectangle { // CPU Card
        id: cpuCard
        Layout.preferredWidth: 180
        Layout.preferredHeight: 160
        radius: 24
        color: root.surfaceColor
        border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.1)
        Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) } GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.02) } } }
        ColumnLayout {
          anchors.centerIn: parent; spacing: 12
          Rectangle { width: 64; height: 64; radius: 32; color: root.cardColor; Layout.alignment: Qt.AlignHCenter
            Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: root.yellowColor } GradientStop { position: 1.0; color: "#e69875" } }; opacity: 0.15 }
            Label { anchors.centerIn: parent; text: ""; font.pixelSize: 28; font.family: "JetBrainsMono Nerd Font, Noto Color Emoji"; color: root.yellowColor }
          }
          Label {
            text: root.cpuTemp; font.pixelSize: 28; font.weight: Font.Bold; font.family: "SF Pro Display, Inter, system-ui";
            color: { if (root.cpuTempRaw === "--") return root.subTextColor; const temp = parseInt(root.cpuTempRaw); if (temp > 85) return "#e67e80"; if (temp > 75) return root.yellowColor; return root.yellowColor }
            Layout.alignment: Qt.AlignHCenter
          }
          Label { text: "CPU"; font.pixelSize: 12; font.weight: Font.Medium; font.family: "SF Pro Display, Inter, system-ui"; color: root.subTextColor; Layout.alignment: Qt.AlignHCenter }
        }
        Rectangle { width: parent.width * 0.6; height: 2; radius: 1; color: { if (root.cpuTempRaw === "--") return root.subTextColor; const temp = parseInt(root.cpuTempRaw); if (temp > 85) return "#e67e80"; if (temp > 75) return root.yellowColor; return root.yellowColor }; anchors.bottom: parent.bottom; anchors.bottomMargin: 16; anchors.horizontalCenter: parent.horizontalCenter; opacity: 0.6 }
      }

      Rectangle { // GPU Card
        id: gpuCard
        Layout.preferredWidth: 180
        Layout.preferredHeight: 160
        radius: 24
        color: root.surfaceColor
        border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.1)
        Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) } GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.02) } } }
        ColumnLayout { anchors.centerIn: parent; spacing: 12
          Rectangle { width: 64; height: 64; radius: 32; color: root.cardColor; Layout.alignment: Qt.AlignHCenter
            Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: root.accentColor } GradientStop { position: 1.0; color: root.tealColor } }; opacity: 0.15 }
            Label { anchors.centerIn: parent; text: "󰢮"; font.pixelSize: 28; font.family: "JetBrainsMono Nerd Font, Noto Color Emoji"; color: root.accentColor }
          }
          Label { text: root.gpuTemp; font.pixelSize: 28; font.weight: Font.Bold; font.family: "SF Pro Display, Inter, system-ui"; color: { if (root.gpuTempRaw === "--") return root.subTextColor; const temp = parseInt(root.gpuTempRaw); if (temp > 80) return "#e67e80"; if (temp > 70) return root.yellowColor; return root.accentColor }; Layout.alignment: Qt.AlignHCenter }
          Label { text: "GPU"; font.pixelSize: 12; font.weight: Font.Medium; font.family: "SF Pro Display, Inter, system-ui"; color: root.subTextColor; Layout.alignment: Qt.AlignHCenter }
        }
        Rectangle { width: parent.width * 0.6; height: 2; radius: 1; color: { if (root.gpuTempRaw === "--") return root.subTextColor; const temp = parseInt(root.gpuTempRaw); if (temp > 80) return "#e67e80"; if (temp > 70) return root.yellowColor; return root.accentColor }; anchors.bottom: parent.bottom; anchors.bottomMargin: 16; anchors.horizontalCenter: parent.horizontalCenter; opacity: 0.6 }
      }
    }
  }
}
