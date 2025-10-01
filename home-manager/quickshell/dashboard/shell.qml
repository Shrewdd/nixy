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
  
  // Disk usage monitoring
  property string diskUsageRoot: "--"
  property string diskUsageHome: "--"
  property int diskPercentRoot: 0
  property int diskPercentHome: 0
  
  // Network monitoring
  property string networkSSID: "--"
  property string networkSpeed: "-- KB/s"
  property string networkIP: "--"
  
  // Volume monitoring
  property string volumeLevel: "--"
  property bool volumeMuted: false

  // Weather (Opole coordinates ~50.6751N, 17.9213E)
  property string weatherTemp: "--°C"
  property int weatherCode: -1
  property string weatherDescription: "Loading…"
  property string weatherIcon: "" // Nerd Font / Emoji placeholder
  
  // Weather forecast (7 days)
  property var forecastData: []

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
      var url = "https://api.open-meteo.com/v1/forecast?latitude=50.6751&longitude=17.9213&current=temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=auto&forecast_days=7"
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
                
                // Parse forecast
                if (data.daily && data.daily.time && data.daily.time.length > 0) {
                  var forecast = []
                  for (var i = 1; i < Math.min(data.daily.time.length, 7); i++) {
                    var dayData = {
                      date: data.daily.time[i],
                      maxTemp: Math.round(data.daily.temperature_2m_max[i]),
                      minTemp: Math.round(data.daily.temperature_2m_min[i]),
                      code: data.daily.weather_code[i]
                    }
                    forecast.push(dayData)
                  }
                  forecastData = forecast
                  console.log("[weather] forecast updated: " + forecast.length + " days")
                }
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

  // Network monitoring
  Process {
    id: networkProcess
    command: ["sh", "-c", "nmcli -t -f active,ssid,type dev wifi | grep '^yes' | cut -d: -f2,3 && ip -4 addr show | grep inet | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n1"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = text.trim().split('\n')
        if (lines.length >= 1 && lines[0] !== '') {
          var parts = lines[0].split(':')
          if (parts.length >= 2) {
            root.networkSSID = parts[0]
          } else if (lines[0].indexOf('ethernet') > -1 || lines[0].indexOf('wired') > -1) {
            root.networkSSID = "Ethernet"
          } else {
            root.networkSSID = lines[0] || "Connected"
          }
        }
        if (lines.length >= 2 && lines[1] !== '') {
          root.networkIP = lines[1]
        }
      }
    }
  }
  
  Timer {
    interval: 5000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: { if (!networkProcess.running) networkProcess.running = true }
  }
  
  // Volume monitoring
  Process {
    id: volumeProcess
    command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 && pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(yes|no)'"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = text.trim().split('\n')
        if (lines.length >= 1) {
          root.volumeLevel = lines[0] || "--"
        }
        if (lines.length >= 2) {
          root.volumeMuted = lines[1] === 'yes'
        }
      }
    }
  }
  
  Timer {
    interval: 2000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: { if (!volumeProcess.running) volumeProcess.running = true }
  }

  // Disk usage monitoring
  Process {
    id: diskProcess
    command: ["sh", "-c", "df -h / /home 2>/dev/null | tail -n 2 | awk '{print $5, $3, $2}'"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = text.trim().split('\n')
        if (lines.length >= 1) {
          var parts = lines[0].trim().split(/\s+/)
          if (parts.length >= 3) {
            root.diskPercentRoot = parseInt(parts[0]) || 0
            root.diskUsageRoot = parts[1] + " / " + parts[2]
          }
        }
        if (lines.length >= 2) {
          var parts = lines[1].trim().split(/\s+/)
          if (parts.length >= 3) {
            root.diskPercentHome = parseInt(parts[0]) || 0
            root.diskUsageHome = parts[1] + " / " + parts[2]
          }
        }
      }
    }
  }
  
  Timer {
    interval: 5000 // Update every 5 seconds
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: { if (!diskProcess.running) diskProcess.running = true }
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

      // Left: Vertical Weather Widget - Sci-fi design
      Rectangle { // Weather Card
        id: weatherCard
        Layout.preferredWidth: 120
        Layout.preferredHeight: timeCard.height + dashboardWindow.cardSpacing + infoBar.height + dashboardWindow.cardSpacing + cpuGpuRow.height
        radius: 4
        color: root.primaryColor
        border.width: 0
        
        // Sci-fi gradient border effect
        Rectangle {
          anchors.fill: parent
          anchors.margins: -2
          radius: parent.radius
          z: -1
          gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Qt.rgba(0.498, 0.733, 0.702, 0.6) }
            GradientStop { position: 0.5; color: Qt.rgba(0.651, 0.753, 0.575, 0.5) }
            GradientStop { position: 1.0; color: Qt.rgba(0.843, 0.6, 0.714, 0.4) }
          }
        }
        
        // Corner accents - geometric sci-fi detail
        Repeater {
          model: 4
          Rectangle {
            property int corner: index
            x: corner === 0 || corner === 3 ? 0 : parent.width - width
            y: corner < 2 ? 0 : parent.height - height
            width: 12
            height: 2
            color: root.tealColor
            opacity: 0.7
          }
        }
        Repeater {
          model: 4
          Rectangle {
            property int corner: index
            x: corner === 0 || corner === 3 ? 0 : parent.width - width
            y: corner < 2 ? 0 : parent.height - height
            width: 2
            height: 12
            color: root.tealColor
            opacity: 0.7
          }
        }
        
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 18
          spacing: 14
          
          // Label header
          Label {
            text: "WEATHER"
            font.pixelSize: 9
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            font.letterSpacing: 1.2
            color: root.tealColor
            opacity: 0.8
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Weather icon
          Label {
            text: root.weatherIcon
            font.pixelSize: 44
            font.family: "JetBrainsMono Nerd Font"
            color: root.blueColor
            opacity: weatherDescription === "Loading…" ? 0.5 : 1
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Temperature
          Label {
            text: root.weatherTemp
            font.pixelSize: 26
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            color: root.textColor
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Geometric separator
          Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4
            Repeater {
              model: 3
              Rectangle {
                width: 6
                height: 2
                color: root.tealColor
                opacity: 0.4
              }
            }
          }
          
          // City name
          Label {
            text: "OPOLE"
            font.pixelSize: 11
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            font.letterSpacing: 1
            color: root.subTextColor
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Weather description
          Label {
            text: root.weatherDescription.toUpperCase()
            font.pixelSize: 9
            font.family: "JetBrains Mono"
            color: root.subTextColor
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.preferredWidth: 84
          }
          
          // Separator
          Rectangle {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 1
            color: root.tealColor
            opacity: 0.3
            Layout.alignment: Qt.AlignHCenter
          }
          
          // Forecast scroll area
          Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            contentHeight: forecastColumn.height
            clip: true
            
            ColumnLayout {
              id: forecastColumn
              width: parent.width
              spacing: 8
              
              Label {
                text: "FORECAST"
                font.pixelSize: 8
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.tealColor
                opacity: 0.6
                Layout.alignment: Qt.AlignHCenter
              }
              
              Repeater {
                model: root.forecastData
                
                ColumnLayout {
                  spacing: 3
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignHCenter
                  
                  Label {
                    text: {
                      var date = new Date(modelData.date)
                      return Qt.formatDate(date, "ddd")
                    }
                    font.pixelSize: 9
                    font.weight: Font.Bold
                    font.family: "JetBrains Mono"
                    color: root.subTextColor
                    Layout.alignment: Qt.AlignHCenter
                  }
                  
                  Label {
                    text: root.mapWeather(modelData.code).i
                    font.pixelSize: 24
                    font.family: "JetBrainsMono Nerd Font"
                    color: root.blueColor
                    opacity: 0.8
                    Layout.alignment: Qt.AlignHCenter
                  }
                  
                  Label {
                    text: modelData.maxTemp + "°/" + modelData.minTemp + "°"
                    font.pixelSize: 8
                    font.family: "JetBrains Mono"
                    color: root.textColor
                    opacity: 0.8
                    Layout.alignment: Qt.AlignHCenter
                  }
                  
                  Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 1
                    color: root.tealColor
                    opacity: 0.2
                    Layout.alignment: Qt.AlignHCenter
                  }
                }
              }
            }
          }
        }
      }

      // Right: Main content column
      ColumnLayout {
        spacing: dashboardWindow.cardSpacing
        
      // Top wide time card - Sci-fi design
      Rectangle { // Time Card
        id: timeCard
        Layout.preferredWidth: Math.max(cpuGpuRow.implicitWidth, 800)
        Layout.preferredHeight: 180
        radius: 4
        color: root.primaryColor
        border.width: 2
        border.color: Qt.rgba(0.651, 0.753, 0.575, 0.4) // accentColor
        
        // Corner brackets - technical aesthetic
        // Top-left (0): L shape
        Rectangle {
          x: 4
          y: 4
          width: 16
          height: 2
          color: root.accentColor
        }
        Rectangle {
          x: 4
          y: 4
          width: 2
          height: 16
          color: root.accentColor
        }
        
        // Top-right (1): ⌐ shape
        Rectangle {
          x: parent.width - 20
          y: 4
          width: 16
          height: 2
          color: root.accentColor
        }
        Rectangle {
          x: parent.width - 6
          y: 4
          width: 2
          height: 16
          color: root.accentColor
        }
        
        // Bottom-right (2): ┘ shape
        Rectangle {
          x: parent.width - 20
          y: parent.height - 6
          width: 16
          height: 2
          color: root.accentColor
        }
        Rectangle {
          x: parent.width - 6
          y: parent.height - 20
          width: 2
          height: 16
          color: root.accentColor
        }
        
        // Bottom-left (3): └ shape
        Rectangle {
          x: 4
          y: parent.height - 6
          width: 16
          height: 2
          color: root.accentColor
        }
        Rectangle {
          x: 4
          y: parent.height - 20
          width: 2
          height: 16
          color: root.accentColor
        }
        RowLayout {
          anchors.fill: parent
          anchors.margins: 28
          spacing: 48
          RowLayout { // Left: time
            Layout.alignment: Qt.AlignVCenter
            spacing: 10
            Label {
              text: root.hourText
              font.pixelSize: 84
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              color: root.textColor
            }
            Label {
              text: ":"
              font.pixelSize: 84
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              color: root.accentColor
              SequentialAnimation on opacity {
                running: true
                loops: Animation.Infinite
                NumberAnimation { to: 0.4; duration: 800 }
                NumberAnimation { to: 1.0; duration: 800 }
              }
            }
            Label {
              text: root.minuteText
              font.pixelSize: 84
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              color: root.textColor
            }
          }
          Item { Layout.fillWidth: true } // spacer
          ColumnLayout { // Right: date only
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            spacing: 8
            Label {
              text: root.dayText.toUpperCase()
              font.pixelSize: 18
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 0.5
              color: root.subTextColor
              horizontalAlignment: Text.AlignRight
            }
          }
        }
      }
      
      // Info Summary Bar
      Rectangle {
        id: infoBar
        Layout.preferredWidth: timeCard.width
        Layout.preferredHeight: 70
        radius: 4
        color: root.primaryColor
        border.width: 2
        border.color: Qt.rgba(0.651, 0.753, 0.575, 0.3)
        
        // Technical shadow
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "black"
          opacity: 0.2
          y: 2
          z: -1
        }
        
        RowLayout {
          anchors.fill: parent
          anchors.margins: 16
          spacing: 20
          
          // CPU Temp Summary
          RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            
            Rectangle {
              width: 36
              height: 36
              radius: 2
              color: Qt.rgba(0.902, 0.494, 0.502, 0.12)
              border.width: 1
              border.color: Qt.rgba(0.902, 0.494, 0.502, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰻠"
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
                color: root.redColor
              }
            }
            
            ColumnLayout {
              spacing: 0
              Label {
                text: "CPU"
                font.pixelSize: 8
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
                opacity: 0.7
              }
              Label {
                text: root.cpuTemp
                font.pixelSize: 14
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.cpuColor(root.cpuTempRaw)
              }
            }
          }
          
          Rectangle {
            width: 1
            height: 40
            color: root.borderColor
            opacity: 0.3
          }
          
          // GPU Temp Summary
          RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            
            Rectangle {
              width: 36
              height: 36
              radius: 2
              color: Qt.rgba(0.843, 0.6, 0.714, 0.12)
              border.width: 1
              border.color: Qt.rgba(0.843, 0.6, 0.714, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰢮"
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
                color: root.purpleColor
              }
            }
            
            ColumnLayout {
              spacing: 0
              Label {
                text: "GPU"
                font.pixelSize: 8
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
                opacity: 0.7
              }
              Label {
                text: root.gpuTemp
                font.pixelSize: 14
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.textColor
              }
            }
          }
          
          Rectangle {
            width: 1
            height: 40
            color: root.borderColor
            opacity: 0.3
          }
          
          // Network Summary
          RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            
            Rectangle {
              width: 36
              height: 36
              radius: 2
              color: Qt.rgba(0.498, 0.733, 0.702, 0.12)
              border.width: 1
              border.color: Qt.rgba(0.498, 0.733, 0.702, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰖩"
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
                color: root.blueColor
              }
            }
            
            ColumnLayout {
              spacing: 0
              Label {
                text: root.networkSSID
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.textColor
                elide: Text.ElideRight
                Layout.preferredWidth: 100
              }
              Label {
                text: root.networkIP
                font.pixelSize: 8
                font.family: "JetBrains Mono"
                color: root.subTextColor
                opacity: 0.8
              }
            }
          }
          
          Rectangle {
            width: 1
            height: 40
            color: root.borderColor
            opacity: 0.3
          }
          
          // Volume Summary
          RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            
            Rectangle {
              width: 36
              height: 36
              radius: 2
              color: Qt.rgba(0.651, 0.753, 0.575, 0.12)
              border.width: 1
              border.color: Qt.rgba(0.651, 0.753, 0.575, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: root.volumeMuted ? "󰖁" : "󰕾"
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
                color: root.volumeMuted ? root.subTextColor : root.accentColor
              }
            }
            
            ColumnLayout {
              spacing: 0
              Label {
                text: "VOLUME"
                font.pixelSize: 8
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
                opacity: 0.7
              }
              Label {
                text: root.volumeLevel
                font.pixelSize: 14
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.volumeMuted ? root.subTextColor : root.textColor
              }
            }
          }
        }
      }

      RowLayout {
        id: cpuGpuRow
        spacing: dashboardWindow.cardSpacing

        Rectangle { // CPU Card - Sci-fi lab design
        id: cpuCard
        Layout.preferredWidth: 260
        Layout.preferredHeight: 220
        radius: 4
        color: root.primaryColor
        border.width: 2
        border.color: Qt.rgba(0.902, 0.494, 0.502, 0.5) // redColor
        
        // Technical shadow
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "black"
          opacity: 0.3
          y: 3
          z: -1
        }
        
        // Corner indicators
        Repeater {
          model: 4
          Rectangle {
            property int corner: index
            x: corner === 0 || corner === 3 ? 4 : parent.width - 12
            y: corner < 2 ? 4 : parent.height - 12
            width: corner === 0 || corner === 3 ? 8 : 8
            height: corner < 2 ? 8 : 8
            color: "transparent"
            border.width: 2
            border.color: root.redColor
            opacity: 0.6
          }
        }
        ColumnLayout {
          anchors.centerIn: parent; spacing: 16
          ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter
            
            Label {
              text: "CPU"
              font.pixelSize: 10
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 2
              color: root.redColor
              opacity: 0.8
              Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
              width: 72
              height: 72
              radius: 2
              color: Qt.rgba(0.902, 0.494, 0.502, 0.1)
              Layout.alignment: Qt.AlignHCenter
              
              border.width: 2
              border.color: Qt.rgba(0.902, 0.494, 0.502, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: "󰻠"
                font.pixelSize: 36
                font.family: "JetBrainsMono Nerd Font"
                color: root.redColor
              }
            }
          }
          Label {
            text: root.cpuTemp
            font.pixelSize: 38
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            color: root.cpuColor(root.cpuTempRaw)
            Layout.alignment: Qt.AlignHCenter
          }
          Label { 
            text: "TEMPERATURE"
            font.pixelSize: 9
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            font.letterSpacing: 1
            color: root.subTextColor
            opacity: 0.6
            Layout.alignment: Qt.AlignHCenter
          }
        }
        }

        Rectangle { // GPU Card - Sci-fi lab design
        id: gpuCard
        Layout.preferredWidth: 260
        Layout.preferredHeight: 220
        radius: 4
        color: root.primaryColor
        border.width: 2
        border.color: Qt.rgba(0.843, 0.6, 0.714, 0.5) // purpleColor
        
        // Technical shadow
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "black"
          opacity: 0.3
          y: 3
          z: -1
        }
        
        // Corner indicators
        Repeater {
          model: 4
          Rectangle {
            property int corner: index
            x: corner === 0 || corner === 3 ? 4 : parent.width - 12
            y: corner < 2 ? 4 : parent.height - 12
            width: 8
            height: 8
            color: "transparent"
            border.width: 2
            border.color: root.purpleColor
            opacity: 0.6
          }
        }
        ColumnLayout { anchors.centerIn: parent; spacing: 16
          ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter
            
            Label {
              text: "GPU"
              font.pixelSize: 10
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 2
              color: root.purpleColor
              opacity: 0.8
              Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
              width: 72
              height: 72
              radius: 2
              color: Qt.rgba(0.843, 0.6, 0.714, 0.1)
              Layout.alignment: Qt.AlignHCenter
              
              border.width: 2
              border.color: Qt.rgba(0.843, 0.6, 0.714, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: "󰢮"
                font.pixelSize: 36
                font.family: "JetBrainsMono Nerd Font"
                color: root.purpleColor
              }
            }
          }
          Label {
            text: root.gpuTemp
            font.pixelSize: 38
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            color: root.textColor
            Layout.alignment: Qt.AlignHCenter
          }
          Label { 
            text: "TEMPERATURE"
            font.pixelSize: 9
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            font.letterSpacing: 1
            color: root.subTextColor
            opacity: 0.6
            Layout.alignment: Qt.AlignHCenter
          }
        }
        }
        
        Rectangle { // Disk Usage Panel - Sci-fi geometric design
        id: diskCard
        Layout.preferredWidth: 260
        Layout.preferredHeight: 220
        radius: 4
        color: root.primaryColor
        border.width: 2
        border.color: Qt.rgba(0.859, 0.737, 0.498, 0.5) // yellowColor
        
        // Technical shadow
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "black"
          opacity: 0.3
          y: 3
          z: -1
        }
        
        // Corner indicators
        Repeater {
          model: 4
          Rectangle {
            property int corner: index
            x: corner === 0 || corner === 3 ? 4 : parent.width - 12
            y: corner < 2 ? 4 : parent.height - 12
            width: 8
            height: 8
            color: "transparent"
            border.width: 2
            border.color: root.yellowColor
            opacity: 0.6
          }
        }
        
        ColumnLayout { 
          anchors.fill: parent
          anchors.margins: 16
          spacing: 10
          
          // Header
          ColumnLayout {
            spacing: 3
            Layout.alignment: Qt.AlignHCenter
            
            Label {
              text: "STORAGE"
              font.pixelSize: 10
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 2
              color: root.yellowColor
              opacity: 0.8
              Layout.alignment: Qt.AlignHCenter
            }
            
            // Icon with geometric shape
            Rectangle {
              width: 56
              height: 56
              radius: 2
              color: Qt.rgba(0.859, 0.737, 0.498, 0.1)
              Layout.alignment: Qt.AlignHCenter
              
              border.width: 2
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: "󰋊"
                font.pixelSize: 28
                font.family: "JetBrainsMono Nerd Font"
                color: root.yellowColor
              }
            }
          }
          
          // Root disk usage
          ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            
            RowLayout {
              spacing: 8
              Layout.fillWidth: true
              
              Label {
                text: "ROOT"
                font.pixelSize: 9
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
              }
              
              Item { Layout.fillWidth: true }
              
              Label {
                text: root.diskUsageRoot
                font.pixelSize: 9
                font.family: "JetBrains Mono"
                color: root.textColor
                opacity: 0.8
              }
            }
            
            // Progress bar - geometric
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 6
              Layout.alignment: Qt.AlignHCenter
              color: Qt.rgba(0.859, 0.737, 0.498, 0.15)
              border.width: 1
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.3)
              
              Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * (root.diskPercentRoot / 100.0)
                color: root.diskPercentRoot > 90 ? root.redColor : root.diskPercentRoot > 75 ? root.yellowColor : root.accentColor
                opacity: 0.7
                
                Behavior on width { NumberAnimation { duration: 300 } }
              }
            }
          }
          
          // Home disk usage
          ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            
            RowLayout {
              spacing: 8
              Layout.fillWidth: true
              
              Label {
                text: "HOME"
                font.pixelSize: 9
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
              }
              
              Item { Layout.fillWidth: true }
              
              Label {
                text: root.diskUsageHome
                font.pixelSize: 9
                font.family: "JetBrains Mono"
                color: root.textColor
                opacity: 0.8
              }
            }
            
            // Progress bar - geometric
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 6
              Layout.alignment: Qt.AlignHCenter
              color: Qt.rgba(0.859, 0.737, 0.498, 0.15)
              border.width: 1
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.3)
              
              Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * (root.diskPercentHome / 100.0)
                color: root.diskPercentHome > 90 ? root.redColor : root.diskPercentHome > 75 ? root.yellowColor : root.accentColor
                opacity: 0.7
                
                Behavior on width { NumberAnimation { duration: 300 } }
              }
            }
          }
        }
        }
      }
      } // end of right content column
    } // end of main row
  }
}
