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
  readonly property string redColor: "#e67e80"        // red (CPU accent)
  readonly property string blueColor: "#7fbbb3"       // blue (weather accent)
  readonly property string purpleColor: "#d699b6"     // purple (GPU accent)

  // Helper functions for temperature-based colors
  function cpuColor(tempRaw) {
    if (tempRaw === "--") return subTextColor
    var t = parseInt(tempRaw)
    if (t > 85) return "#e67e80"
    if (t > 75) return yellowColor
    return redColor
  }
  function gpuColor(tempRaw) {
    if (tempRaw === "--") return subTextColor
    var t = parseInt(tempRaw)
    if (t > 80) return "#e67e80"
    if (t > 70) return yellowColor
    return purpleColor
  }

  property string gpuTemp: "-- °C"
  property string gpuTempRaw: "--"
  property string cpuTemp: "-- °C"
  property string cpuTempRaw: "--"

  // Weather (Opole coordinates ~50.6751N, 17.9213E)
  property string weatherTemp: "--°C"
  property int weatherCode: -1
  property string weatherDescription: "Loading…"
  property string weatherIcon: "" // Nerd Font / Emoji placeholder

  function mapWeather(code) {
    switch(code) {
      case 0: return { d: "Clear sky", i: "" }
      case 1: case 2: return { d: "Partly cloudy", i: "󰖕" }
      case 3: return { d: "Overcast", i: "" }
      case 45: case 48: return { d: "Fog", i: "󰖑" }
      case 51: case 53: case 55: return { d: "Drizzle", i: "󰖗" }
      case 61: case 63: case 65: return { d: "Rain", i: "󰖖" }
      case 71: case 73: case 75: return { d: "Snow", i: "󰼶" }
      case 80: case 81: case 82: return { d: "Showers", i: "󰙿" }
      case 95: return { d: "Thunder", i: "" }
      case 96: case 99: return { d: "Storm", i: "" }
      default: return { d: "--", i: "󰔗" }
    }
  }

  function fetchWeather() {
    try {
      if (typeof XMLHttpRequest === 'undefined') {
        console.log('[weather] XMLHttpRequest unavailable')
        weatherDescription = 'No network'
        weatherIcon = "󰌑"
        return
      }
      var xhr = new XMLHttpRequest()
      var url = "https://api.open-meteo.com/v1/forecast?latitude=50.6751&longitude=17.9213&current=temperature_2m,weather_code&timezone=auto"
      xhr.open("GET", url)
      xhr.timeout = 10000 // 10 second timeout
      xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
          if (xhr.status === 200) {
            try {
              var data = JSON.parse(xhr.responseText)
              if (data && data.current && typeof data.current.temperature_2m === 'number') {
                var temp = Math.round(data.current.temperature_2m)
                var code = data.current.weather_code || -1
                weatherTemp = temp + "°C"
                weatherCode = code
                var mapped = mapWeather(code)
                weatherDescription = mapped.d
                weatherIcon = mapped.i
                console.log("[weather] updated: " + weatherTemp + ", " + weatherDescription)
              } else {
                weatherDescription = 'Invalid data'
                weatherIcon = "󰔗"
                console.log('[weather] invalid response structure')
              }
            } catch(e) {
              weatherDescription = "Parse error"
              weatherIcon = "󰌑"
              console.log('[weather] JSON parse error:', e.toString())
            }
          } else {
            weatherDescription = "HTTP " + xhr.status
            weatherIcon = "󰌑"
            console.log("[weather] HTTP error: " + xhr.status)
          }
        }
      }
      xhr.onerror = function() { console.log('[weather] xhr onerror') }
      xhr.send()
    } catch(e) {
      weatherDescription = "Error"
      console.log('[weather] exception', e)
    }
  }

  readonly property string hourText: Qt.formatDateTime(clock.date, "hh")
  readonly property string minuteText: Qt.formatDateTime(clock.date, "mm")
  readonly property string dayText: Qt.formatDateTime(clock.date, "MMMM d, yyyy")

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  // Refresh weather periodically
  Timer {
    id: weatherTimer
    interval: 10 * 60 * 1000 // 10 minutes
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: fetchWeather()
  }

  IpcHandler {
    target: "dashboard"
    function toggle() {
      console.log("[dashboard IPC] toggle request")
      dashboardWindow.toggleVisibility()
    }
    function show() {
      console.log("[dashboard IPC] show request")
      dashboardWindow.show()
    }
    function hide() {
      console.log("[dashboard IPC] hide request")
      dashboardWindow.hide()
    }
  }

  // GPU Temperature monitoring - nvidia-smi with proper structure
  StdioCollector {
    id: gpuStdoutCollector
    onStreamFinished: {
      var tempText = text.trim()
      if (tempText && tempText !== "" && !isNaN(parseInt(tempText))) {
        var tempValue = parseInt(tempText)
        root.gpuTemp = tempValue + "°C"
        root.gpuTempRaw = tempValue.toString()
        console.log("[GPU] nvidia-smi: " + tempValue + "°C")
      }
    }
  }
  
  Process {
    id: gpuTempProcess
    command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
    stdout: gpuStdoutCollector
    
    onExited: function(exitCode, exitStatus) {
      if (exitCode !== 0) {
        console.log("[GPU] nvidia-smi failed (" + exitCode + "), falling back to sysfs")
        // Start fallback sysfs monitoring
        gpuSysfsFile.running = true
        gpuTempTimer.running = false // Stop trying nvidia-smi
      }
    }
  }
  
  // Timer for GPU temperature updates
  Timer {
    id: gpuTempTimer
    interval: 3000 // Update every 3 seconds
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: {
      if (!gpuTempProcess.running) {
        gpuTempProcess.running = true
      }
    }
  }
  
  // Fallback: GPU Temperature monitoring via sysfs
  FileView {
    id: gpuSysfsFile
    path: "/sys/class/drm/card0/device/hwmon/hwmon0/temp1_input"
    watchChanges: true
    property bool running: false
    
    onTextChanged: {
      if (!running) return
      var tempText = text().trim()
      if (tempText && tempText !== "") {
        var tempValue = parseInt(tempText) / 1000
        root.gpuTemp = tempValue + "°C"
        root.gpuTempRaw = tempValue.toString()
        console.log("[GPU] sysfs: " + tempValue + "°C")
      } else {
        root.gpuTemp = "-- °C"
        root.gpuTempRaw = "--"
      }
    }
    
    onLoadFailed: { 
      root.gpuTemp = "-- °C"
      root.gpuTempRaw = "--"
      console.log("[GPU] sysfs monitoring failed")
    }
    
    // Start sysfs immediately if nvidia-smi isn't available
    Component.onCompleted: {
      // Give nvidia-smi a chance to start first
      Qt.callLater(() => {
        if (root.gpuTempRaw === "--") {
          running = true
          console.log("[GPU] Starting sysfs monitoring as primary method")
        }
      })
    }
  }

  // CPU Temperature monitoring via thermal zone - robust implementation
  FileView {
    id: cpuTempFile
    path: "/sys/class/thermal/thermal_zone0/temp"
    watchChanges: true
    
    onTextChanged: {
      var tempText = text().trim()
      if (tempText && tempText !== "" && !isNaN(parseInt(tempText))) {
        var tempMilliC = parseInt(tempText)
        var tempValue = Math.round(tempMilliC / 1000)
        if (tempValue > 0 && tempValue < 150) { // Sanity check
          root.cpuTemp = tempValue + "°C"
          root.cpuTempRaw = tempValue.toString()
          console.log("[CPU] temperature: " + tempValue + "°C")
        } else {
          console.log("[CPU] invalid temperature reading: " + tempValue + "°C")
        }
      } else {
        root.cpuTemp = "-- °C"
        root.cpuTempRaw = "--"
        console.log('[CPU] invalid temperature data')
      }
    }
    
    onLoadFailed: { 
      root.cpuTemp = "-- °C"
      root.cpuTempRaw = "--"
      console.log('[CPU] failed to load temperature file')
    }
  }

  PanelWindow {
    id: dashboardWindow
    property int cardSpacing: 12
    readonly property int cardPadding: 24
    color: "transparent"
    visible: false
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: mainRow.implicitWidth
    implicitHeight: mainRow.implicitHeight
    Component.onCompleted: {
      try {
        var targetScreen = Quickshell.primaryScreen
        if (targetScreen && targetScreen.geometry) {
          var screenWidth = targetScreen.geometry.width
          var screenHeight = targetScreen.geometry.height
          if (screenWidth > 0 && screenHeight > 0) {
            x = Math.max(0, (screenWidth - implicitWidth) / 2)
            y = Math.max(0, (screenHeight - implicitHeight) / 2)
            console.log("[dashboard] positioned at (" + x + ", " + y + ") on " + screenWidth + "x" + screenHeight + " screen")
          }
        } else {
          console.log('[dashboard] no primary screen found, using default positioning')
        }
      } catch(e) {
        console.log('[dashboard] positioning error:', e.toString())
      }
    }
    function toggleVisibility() {
      visible = !visible
      console.log("[dashboardWindow] toggled ->", visible)
    }
    function show() {
      if (!visible) {
        visible = true
        console.log("[dashboardWindow] show()")
      }
    }
    function hide() {
      if (visible) {
        visible = false
        console.log("[dashboardWindow] hide()")
      }
    }

    RowLayout {
      id: mainRow
      anchors.centerIn: parent
      spacing: dashboardWindow.cardSpacing

      // Left: Vertical Weather Widget
      Rectangle { // Weather Card
        id: weatherCard
        Layout.preferredWidth: 120
        Layout.preferredHeight: timeCard.height + dashboardWindow.cardSpacing + cpuGpuRow.height
        radius: 12
        color: root.surfaceColor
        border.width: 1
        border.color: Qt.rgba(0.498, 0.733, 0.702, 0.2) // blueColor with transparency
        Rectangle { 
          anchors.fill: parent
          radius: parent.radius
          gradient: Gradient { 
            GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.05) } 
            GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.01) } 
          } 
        }
        
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 20
          spacing: 16
          
          // Weather icon
          Label {
            text: root.weatherIcon
            font.pixelSize: 48
            font.family: "JetBrainsMono Nerd Font, Noto Color Emoji"
            color: root.blueColor
            opacity: weatherDescription === "Loading…" ? 0.6 : 1
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Temperature
          Label {
            text: root.weatherTemp
            font.pixelSize: 28
            font.weight: Font.Bold
            font.family: "SF Pro Display, Inter, system-ui"
            color: root.textColor
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Separator line
          Rectangle {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 1
            color: root.borderColor
            opacity: 0.3
            Layout.alignment: Qt.AlignHCenter
          }
          
          Item { Layout.fillHeight: true }
          
          // City name (vertical)
          Label {
            text: "Opole"
            font.pixelSize: 16
            font.weight: Font.Medium
            font.family: "SF Pro Display, Inter, system-ui"
            color: root.subTextColor
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Weather description (vertical, rotated or wrapped)
          Label {
            text: root.weatherDescription
            font.pixelSize: 13
            font.family: "SF Pro Display, Inter, system-ui"
            color: root.subTextColor
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.preferredWidth: 80
          }
        }
      }

      // Right: Main content column
      ColumnLayout {
        spacing: dashboardWindow.cardSpacing
        
      // Top wide time card
      Rectangle { // Time Card
        id: timeCard
        Layout.preferredWidth: Math.max(cpuGpuRow.implicitWidth, 800)
        Layout.preferredHeight: 180
        radius: 12
        color: root.surfaceColor
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.06)
        Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) } GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.01) } } }
        RowLayout {
          anchors.fill: parent
          anchors.margins: 28
          spacing: 48
          RowLayout { // Left: time
            Layout.alignment: Qt.AlignVCenter
            spacing: 8
            Label {
              text: root.hourText
              font.pixelSize: 84
              font.weight: Font.Black
              font.family: "SF Pro Display, Inter, system-ui"
              color: root.textColor
            }
            Label {
              text: ":"
              font.pixelSize: 84
              font.weight: Font.Black
              color: root.accentColor
              SequentialAnimation on opacity {
                running: true
                loops: Animation.Infinite
                NumberAnimation { to: 0.3; duration: 900 }
                NumberAnimation { to: 1.0; duration: 900 }
              }
            }
            Label {
              text: root.minuteText
              font.pixelSize: 84
              font.weight: Font.Black
              font.family: "SF Pro Display, Inter, system-ui"
              color: root.textColor
            }
          }
          Item { Layout.fillWidth: true } // spacer
          ColumnLayout { // Right: date only
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            spacing: 8
            Label {
              text: root.dayText
              font.pixelSize: 22
              font.weight: Font.DemiBold
              font.family: "SF Pro Display, Inter, system-ui"
              color: root.subTextColor
              horizontalAlignment: Text.AlignRight
            }
          }
        }
      }

      RowLayout {
        id: cpuGpuRow
        spacing: dashboardWindow.cardSpacing

        Rectangle { // CPU Card
        id: cpuCard
        Layout.preferredWidth: 260
        Layout.preferredHeight: 220
        radius: 12
        color: root.surfaceColor
        border.width: 1
        border.color: Qt.rgba(0.902, 0.494, 0.502, 0.2) // redColor with transparency
        // Fallback shadow (DropShadow effect not available in current Qt build)
        Rectangle {
          anchors.fill: parent
          radius: parent.radius + 2
          color: "black"
          opacity: 0.15
          y: 3
          scale: 1.01
          z: -1
        }
        Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) } GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.01) } } }
        ColumnLayout {
          anchors.centerIn: parent; spacing: 16
          Rectangle {
            width: 80
            height: 80
            radius: 40
            color: root.cardColor
            Layout.alignment: Qt.AlignHCenter
            Rectangle {
              anchors.fill: parent
              radius: parent.radius
              gradient: Gradient {
                GradientStop { position: 0.0; color: root.redColor }
                GradientStop { position: 1.0; color: "#e69875" }
              }
              opacity: 0.15
            }
            Label {
              anchors.centerIn: parent
              text: "󰻠"
              font.pixelSize: 38
              font.family: "JetBrainsMono Nerd Font, Noto Color Emoji"
              color: root.redColor
            }
          }
          Label {
            text: root.cpuTemp
            font.pixelSize: 42
            font.weight: Font.Bold
            font.family: "SF Pro Display, Inter, system-ui"
            color: root.cpuColor(root.cpuTempRaw)
            Layout.alignment: Qt.AlignHCenter
          }
          Label { text: "CPU"; font.pixelSize: 18; font.weight: Font.Medium; font.family: "SF Pro Display, Inter, system-ui"; color: root.subTextColor; Layout.alignment: Qt.AlignHCenter }
        }
        }

        Rectangle { // GPU Card
        id: gpuCard
        Layout.preferredWidth: 260
        Layout.preferredHeight: 220
        radius: 12
        color: root.surfaceColor
        border.width: 1
        border.color: Qt.rgba(0.843, 0.6, 0.714, 0.2) // purpleColor with transparency
        // Fallback shadow (DropShadow effect not available in current Qt build)
        Rectangle {
          anchors.fill: parent
          radius: parent.radius + 2
          color: "black"
          opacity: 0.15
          y: 3
          scale: 1.01
          z: -1
        }
        Rectangle { anchors.fill: parent; radius: parent.radius; gradient: Gradient { GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) } GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.01) } } }
        ColumnLayout { anchors.centerIn: parent; spacing: 16
          Rectangle {
            width: 80
            height: 80
            radius: 40
            color: root.cardColor
            Layout.alignment: Qt.AlignHCenter
            Rectangle {
              anchors.fill: parent
              radius: parent.radius
              gradient: Gradient {
                GradientStop { position: 0.0; color: root.purpleColor }
                GradientStop { position: 1.0; color: root.tealColor }
              }
              opacity: 0.15
            }
            Label {
              anchors.centerIn: parent
              text: "󰢮"
              font.pixelSize: 38
              font.family: "JetBrainsMono Nerd Font, Noto Color Emoji"
              color: root.purpleColor
            }
          }
          Label {
            text: root.gpuTemp
            font.pixelSize: 42
            font.weight: Font.Bold
            font.family: "SF Pro Display, Inter, system-ui"
            color: root.gpuColor(root.gpuTempRaw)
            Layout.alignment: Qt.AlignHCenter
          }
          Label { text: "GPU"; font.pixelSize: 18; font.weight: Font.Medium; font.family: "SF Pro Display, Inter, system-ui"; color: root.subTextColor; Layout.alignment: Qt.AlignHCenter }
        }
        }
      }
      } // end of right content column
    } // end of main row
  }
}
