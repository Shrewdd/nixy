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

  readonly property string appCatalogLoaderScript: [
    "from __future__ import annotations",
    "",
    "import configparser",
    "import glob",
    "import json",
    "import os",
    "import re",
    "import shlex",
    "import sys",
    "",
    "SPECIFIER_PATTERN = re.compile(r'%(?:[fFuUdDnNickvm]|c|i|k|s)')",
    "FLATPAK_PLACEHOLDER_PATTERN = re.compile(r'@@\\w*')",
    "",
    "def env_user_home():",
    "    return os.path.expanduser('~')",
    "",
    "def collect_application_dirs():",
    "    home = env_user_home()",
    "    username = os.path.basename(home.rstrip(os.sep)) or os.environ.get('USER', '')",
    "    xdg_data_home = os.environ.get('XDG_DATA_HOME', os.path.join(home, '.local', 'share'))",
    "",
    "    base_dirs = {",
    "        os.path.join(home, '.local', 'share', 'applications'),",
    "        os.path.join(home, '.nix-profile', 'share', 'applications'),",
    "        os.path.join(xdg_data_home, 'applications'),",
    "        '/usr/share/applications',",
    "        '/usr/local/share/applications',",
    "        '/run/current-system/sw/share/applications',",
    "    }",
    "",
    "    xdg_data_dirs = os.environ.get('XDG_DATA_DIRS', '')",
    "    for part in xdg_data_dirs.split(':'):",
    "        part = part.strip()",
    "        if part:",
    "            base_dirs.add(os.path.join(part, 'applications'))",
    "",
    "    if username:",
    "        base_dirs.add(os.path.join('/etc/profiles/per-user', username, 'share', 'applications'))",
    "",
    "    return sorted({os.path.realpath(d) for d in base_dirs if d})",
    "",
    "def clean_specifiers(value):",
    "    value = value.replace('%%', '%')",
    "    value = SPECIFIER_PATTERN.sub('', value)",
    "    value = FLATPAK_PLACEHOLDER_PATTERN.sub('', value)",
    "    return re.sub(r'\\s+', ' ', value).strip()",
    "",
    "def clean_token(token):",
    "    token = clean_specifiers(token)",
    "    return token.strip()",
    "",
    "def split_exec(exec_cmd):",
    "    try:",
    "        parts = shlex.split(exec_cmd, posix=True)",
    "    except Exception:",
    "        parts = exec_cmd.split()",
    "    cleaned = []",
    "    for part in parts:",
    "        token = clean_token(part)",
    "        if token:",
    "            cleaned.append(token)",
    "    return cleaned",
    "",
    "def desktop_id_from_path(path):",
    "    basename = os.path.basename(path)",
    "    if basename.endswith('.desktop'):",
    "        return basename[:-8]",
    "    return basename",
    "",
    "def iter_desktop_entries(directories):",
    "    seen_paths = set()",
    "    for directory in directories:",
    "        if not os.path.isdir(directory):",
    "            continue",
    "        pattern = os.path.join(directory, '**', '*.desktop')",
    "        for path in glob.iglob(pattern, recursive=True):",
    "            real_path = os.path.realpath(path)",
    "            if real_path in seen_paths:",
    "                continue",
    "            seen_paths.add(real_path)",
    "",
    "            parser = configparser.ConfigParser(interpolation=None)",
    "            try:",
    "                parser.read(real_path, encoding='utf-8')",
    "            except Exception:",
    "                continue",
    "            if 'Desktop Entry' not in parser:",
    "                continue",
    "            entry = parser['Desktop Entry']",
    "            if entry.get('NoDisplay', '').lower() == 'true':",
    "                continue",
    "",
    "            name = entry.get('Name', '').strip()",
    "            exec_cmd = entry.get('Exec', '').strip()",
    "            if not name or not exec_cmd:",
    "                continue",
    "",
    "            comment = entry.get('Comment', '').strip()",
    "            icon = entry.get('Icon', '').strip()",
    "            desktop_id = entry.get('X-Flatpak', '').strip() or entry.get('X-Desktop-File-Name', '').strip()",
    "            if not desktop_id:",
    "                desktop_id = desktop_id_from_path(real_path)",
    "",
    "            yield {",
    "                'name': name,",
    "                'comment': comment,",
    "                'icon': icon,",
    "                'path': real_path,",
    "                'directory': directory,",
    "                'desktopId': desktop_id,",
    "                'exec': exec_cmd,",
    "                'cleanExec': clean_specifiers(exec_cmd),",
    "                'argv': split_exec(exec_cmd),",
    "                'terminal': entry.get('Terminal', 'false').lower() == 'true',",
    "                'categories': [c.strip() for c in entry.get('Categories', '').split(';') if c.strip()],",
    "            }",
    "",
    "def main():",
    "    directories = collect_application_dirs()",
    "    data = list(iter_desktop_entries(directories))",
    "    print(json.dumps(data))",
    "    return 0",
    "",
    "if __name__ == '__main__':",
    "    sys.exit(main())",
  ].join("\n")

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
  
  // Bluetooth monitoring
  property bool bluetoothEnabled: false
  property var bluetoothDevices: []
  
  // Hyprland workspace monitoring
  property int currentWorkspace: 1
  property int totalWorkspaces: 10

  // System uptime
  property string uptimeDays: "0"
  property string uptimeHours: "0"
  property string uptimeMinutes: "0"

  // Media player (MPRIS)
  property string mediaTitle: "No media playing"
  property string mediaArtist: ""
  property string mediaPlayer: ""
  property bool mediaPlaying: false
  property var mediaPlayers: [] // List of all available players
  property int currentPlayerIndex: 0

  // Clipboard monitoring with cliphist
  property var clipboardHistory: [] // Array of {id: string, type: "text"|"image", content: string, fullContent: string, time: string}

  // Weather (Opole coordinates ~50.6751N, 17.9213E)
  property string weatherTemp: "--°C"
  property int weatherCode: -1
  property string weatherDescription: "Loading…"
  property string weatherIcon: "" // Nerd Font / Emoji placeholder
  
  // Weather forecast (7 days)
  property var forecastData: []

  // Application discovery
  property var appCatalog: []
  property var appFilteredApps: []
  property string appSearchTerm: ""
  property int appSelectedIndex: -1
  property bool appDataLoaded: false

  onAppSearchTermChanged: updateAppFilter()
  onAppCatalogChanged: updateAppFilter()

  function shellEscape(str) {
    if (str === undefined || str === null) return "''"
    var value = String(str)
    return "'" + value.replace(/'/g, "'\\''") + "'"
  }

  function commandTokensForApp(app) {
    if (!app) return []
    if (Array.isArray(app.argv) && app.argv.length > 0) {
      var cleaned = []
      for (var i = 0; i < app.argv.length; i++) {
        var token = app.argv[i]
        if (token !== undefined && token !== null) {
          var trimmed = String(token)
          if (trimmed.length > 0) cleaned.push(trimmed)
        }
      }
      if (cleaned.length > 0) {
        return cleaned
      }
    }

    var execStr = app.cleanExec || app.cleanedExec || cleanExecCommand(app.exec)
    if (!execStr || typeof execStr !== "string") return []
    var parts = execStr.split(/\s+/)
    var tokens = []
    for (var j = 0; j < parts.length; j++) {
      if (parts[j] && parts[j].length > 0) tokens.push(parts[j])
    }
    return tokens
  }

  function hideAllDashboardPanels() {
    if (appDiscoveryWindow && appDiscoveryWindow.visible) appDiscoveryWindow.hide()
    if (dashboardWindow && dashboardWindow.visible) dashboardWindow.hide()
  }

  function buildLaunchSteps(app) {
    if (!app) return []
    var steps = []
    var seen = {}

    function pushStep(label, command, details) {
      if (!command || command.length === 0) return
      var key = label + "::" + JSON.stringify(command)
      if (seen[key]) return
      seen[key] = true
      steps.push({ label: label, command: command, details: details })
    }

    var desktopId = app.desktopId || ""
    var desktopPath = app.path || ""
    var cleanExecValue = app.cleanExec || app.cleanedExec || cleanExecCommand(app.exec)
    var commandTokens = commandTokensForApp(app)
    var commandQuoted = commandTokens.length > 0 ? commandTokens.map(shellEscape).join(" ") : ""
    var hyprCommandString = cleanExecValue && cleanExecValue.length > 0 ? cleanExecValue : commandTokens.join(" ")

    var scriptParts = ["set +e"]

    if (desktopId !== "") {
      scriptParts.push("if command -v gtk-launch >/dev/null 2>&1; then gtk-launch " + shellEscape(desktopId) + " >/dev/null 2>&1 && exit 0; fi")
    }
    if (desktopPath !== "") {
      scriptParts.push("if command -v gio >/dev/null 2>&1; then gio launch " + shellEscape(desktopPath) + " >/dev/null 2>&1 && exit 0; fi")
    }

    var hasCommand = commandQuoted.length > 0
    if (hasCommand) {
      if (hyprCommandString && hyprCommandString.length > 0) {
        scriptParts.push("if command -v hyprctl >/dev/null 2>&1; then hyprctl dispatch exec " + shellEscape(hyprCommandString) + " >/dev/null 2>&1 && exit 0; fi")
      }
      scriptParts.push("if command -v systemd-run >/dev/null 2>&1; then systemd-run --user --scope -- " + commandQuoted + " >/dev/null 2>&1 && exit 0; fi")
      scriptParts.push("if command -v setsid >/dev/null 2>&1; then setsid -f -- " + commandQuoted + " >/dev/null 2>&1 && exit 0; fi")
      if (app.terminal === true) {
        scriptParts.push("( " + commandQuoted + " )")
        scriptParts.push("launch_status=$?")
        scriptParts.push("if [ $launch_status -eq 0 ]; then exit 0; fi")
      } else {
        scriptParts.push("( " + commandQuoted + " ) >/dev/null 2>&1 &")
        scriptParts.push("launch_status=$?")
        scriptParts.push("if [ $launch_status -eq 0 ]; then exit 0; fi")
      }
    }

    scriptParts.push("exit 1")

    var script = scriptParts.join("\n")
    pushStep("multi-launch", ["sh", "-c", script], { script: script, commandTokens: commandTokens })

    return steps
  }

  function startLaunchSequence(app) {
    if (!app) return
    var steps = buildLaunchSteps(app)
    if (!steps || steps.length === 0) {
      console.log("[app-discovery] no launch steps available for", app.name)
      return
    }

    hideAllDashboardPanels()

    if (appLaunchProcess.running) {
      try {
        appLaunchProcess.kill()
      } catch(e) {
        console.log("[app-discovery] kill previous launch process failed:", e)
      }
    }

    appLaunchProcess.resetLaunchState()
    appLaunchProcess.pendingApp = app
    appLaunchProcess.pendingSteps = steps.slice ? steps.slice() : steps
    appLaunchProcess.currentStepIndex = -1
    appLaunchProcess.launchAttemptCount = 0
    console.log("[app-discovery] prepared", steps.length, "launch strategies for", app.name)
    if (steps.length > 0 && steps[0] && steps[0].details && steps[0].details.script) {
      console.log("[app-discovery] multi-launch script:\n" + steps[0].details.script)
    }
    Qt.callLater(function() { tryLaunchNextStep("initial") })
  }

  function tryLaunchNextStep(reason) {
    if (!appLaunchProcess.pendingSteps || appLaunchProcess.pendingSteps.length === 0) {
      console.log("[app-discovery] launch sequence finished (" + reason + ")")
      appLaunchProcess.resetLaunchState()
      return
    }

    if (appLaunchProcess.running) {
      console.log("[app-discovery] launch process still running, skipping next step")
      return
    }

    var nextIndex = appLaunchProcess.currentStepIndex + 1
    if (nextIndex >= appLaunchProcess.pendingSteps.length) {
      var appName = appLaunchProcess.pendingApp ? appLaunchProcess.pendingApp.name : "unknown"
      console.log("[app-discovery] all launch strategies failed for", appName, "reason:", reason)
      appLaunchProcess.resetLaunchState()
      return
    }

    var step = appLaunchProcess.pendingSteps[nextIndex]
    appLaunchProcess.currentStepIndex = nextIndex
    appLaunchProcess.launchAttemptCount += 1
    appLaunchProcess.command = step.command.slice ? step.command.slice() : step.command
    var appLabel = appLaunchProcess.pendingApp ? appLaunchProcess.pendingApp.name : "unknown"
    console.log("[app-discovery] launch attempt #" + appLaunchProcess.launchAttemptCount + " using " + step.label + " -> " + appLabel)
    appLaunchProcess.running = true
  }

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

  function cleanExecCommand(execString) {
    if (!execString || typeof execString !== "string") return ""
    var cleaned = execString.replace(/%%/g, "%")
    cleaned = cleaned.replace(/%[fFuUdDnNickvm]/g, "")
    cleaned = cleaned.replace(/%[ciks]/g, "")
    return cleaned.trim()
  }

  function updateAppFilter() {
    var term = (root.appSearchTerm || "").toLowerCase().trim()
    var source = root.appCatalog || []
    if (!term) {
      root.appFilteredApps = source
    } else {
      root.appFilteredApps = source.filter(function(app) {
        if (!app) return false
        if (app.lowerName && app.lowerName.indexOf(term) !== -1) return true
        return app.lowerComment && app.lowerComment.indexOf(term) !== -1
      })
    }

    if (!root.appFilteredApps || root.appFilteredApps.length === 0) {
      root.appSelectedIndex = -1
    } else if (root.appSelectedIndex < 0 || root.appSelectedIndex >= root.appFilteredApps.length) {
      root.appSelectedIndex = 0
    }
  }

  function ensureAppDataLoaded() {
    if ((root.appDataLoaded && root.appCatalog.length > 0) || appDiscoveryLoader.running) return
    root.appDataLoaded = false
    appDiscoveryLoader.running = true
    console.log("[app-discovery] loading desktop entries (inline python)")
  }

  function launchApp(app) {
    if (!app) return
    startLaunchSequence(app)
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
  
  // Volume monitoring (WirePlumber)
  Process {
    id: volumeProcess
    command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var output = text.trim()
        // Output format: "Volume: 0.55" or "Volume: 0.55 [MUTED]"
        var match = output.match(/Volume:\s+([\d.]+)(\s+\[MUTED\])?/)
        if (match) {
          var volume = parseFloat(match[1])
          var percentage = Math.round(volume * 100)
          root.volumeLevel = percentage + "%"
          root.volumeMuted = match[2] !== undefined
          console.log("[volume] " + percentage + "% muted:" + root.volumeMuted)
        } else {
          root.volumeLevel = "--"
          console.log("[volume] parse failed: " + output)
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
  
  // Bluetooth monitoring
  Process {
    id: bluetoothStatusProcess
    command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var powered = text.trim()
        root.bluetoothEnabled = (powered === "yes")
        console.log("[bluetooth] powered: " + root.bluetoothEnabled)
      }
    }
  }
  
  Process {
    id: bluetoothDevicesProcess
    command: ["sh", "-c", "bluetoothctl devices | while read -r line; do mac=$(echo $line | awk '{print $2}'); name=$(echo $line | cut -d' ' -f3-); connected=$(bluetoothctl info $mac | grep 'Connected:' | awk '{print $2}'); paired=$(bluetoothctl info $mac | grep 'Paired:' | awk '{print $2}'); echo \"$mac|$name|$connected|$paired\"; done"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = text.trim().split('\n')
        var devices = []
        for (var i = 0; i < lines.length; i++) {
          if (lines[i] === '') continue
          var parts = lines[i].split('|')
          if (parts.length >= 4) {
            devices.push({
              mac: parts[0],
              name: parts[1],
              connected: parts[2] === 'yes',
              paired: parts[3] === 'yes'
            })
          }
        }
        root.bluetoothDevices = devices
        console.log("[bluetooth] devices: " + devices.length)
      }
    }
  }
  
  Timer {
    id: bluetoothTimer
    interval: 3000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: { 
      if (!bluetoothStatusProcess.running) bluetoothStatusProcess.running = true
      if (!bluetoothDevicesProcess.running) bluetoothDevicesProcess.running = true
    }
  }
  
  // Function to force immediate Bluetooth refresh
  function refreshBluetooth() {
    bluetoothTimer.stop()
    if (!bluetoothStatusProcess.running) bluetoothStatusProcess.running = true
    if (!bluetoothDevicesProcess.running) bluetoothDevicesProcess.running = true
    Qt.callLater(function() { bluetoothTimer.start() })
  }
  
  // Hyprland workspace monitoring
  Process {
    id: hyprlandWorkspaceProcess
    command: ["sh", "-c", "hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}'"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var ws = parseInt(text.trim())
        if (!isNaN(ws) && ws > 0) {
          root.currentWorkspace = ws
          console.log("[hyprland] workspace: " + ws)
        }
      }
    }
  }
  
  Timer {
    interval: 500
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: { if (!hyprlandWorkspaceProcess.running) hyprlandWorkspaceProcess.running = true }
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

  // System uptime monitoring
  Process {
    id: uptimeProcess
    command: ["sh", "-c", "awk '{print int($1/86400), int(($1%86400)/3600), int(($1%3600)/60)}' /proc/uptime"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var uptimeText = text.trim()
        if (uptimeText && uptimeText !== "") {
          var parts = uptimeText.split(/\s+/)
          if (parts.length >= 3) {
            root.uptimeDays = parts[0]
            root.uptimeHours = parts[1]
            root.uptimeMinutes = parts[2]
            console.log("[uptime] " + parts[0] + "d " + parts[1] + "h " + parts[2] + "m")
          }
        }
      }
    }
  }
  
  Timer {
    interval: 60000 // Update every minute
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: { if (!uptimeProcess.running) uptimeProcess.running = true }
  }

  // List all available media players
  Process {
    id: mediaListProcess
    command: ["sh", "-c", "playerctl -l"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var data = text.trim()
        if (data && data !== "") {
          var players = data.split('\n').filter(function(p) { return p.length > 0 })
          root.mediaPlayers = players
          if (root.currentPlayerIndex >= players.length) {
            root.currentPlayerIndex = 0
          }
          console.log("[media] Found players: " + players.join(", "))
        } else {
          root.mediaPlayers = []
          root.currentPlayerIndex = 0
        }
      }
    }
  }

  // Media player (MPRIS) monitoring via playerctl
  Process {
    id: mediaProcess
    command: ["sh", "-c", "playerctl -p " + (root.mediaPlayers.length > 0 ? root.mediaPlayers[root.currentPlayerIndex] : "''") + " metadata --format '{{playerName}}|||{{title}}|||{{artist}}|||{{status}}' 2>/dev/null || echo ''"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var data = text.trim()
        if (data && data !== "") {
          var parts = data.split('|||')
          if (parts.length >= 4) {
            root.mediaPlayer = parts[0] || ""
            root.mediaTitle = parts[1] || "No title"
            root.mediaArtist = parts[2] || ""
            root.mediaPlaying = (parts[3] === "Playing")
            console.log("[media] " + root.mediaPlayer + " - " + root.mediaTitle)
          }
        } else {
          root.mediaPlayer = ""
          root.mediaTitle = "No media playing"
          root.mediaArtist = ""
          root.mediaPlaying = false
        }
      }
    }
    
    onExited: function(exitCode, exitStatus) {
      if (exitCode !== 0) {
        root.mediaPlayer = ""
        root.mediaTitle = "No media playing"
        root.mediaArtist = ""
        root.mediaPlaying = false
      }
    }
  }
  
  Timer {
    interval: 2000 // Update every 2 seconds
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: {
      if (!mediaListProcess.running) mediaListProcess.running = true
      Qt.callLater(function() {
        if (!mediaProcess.running) mediaProcess.running = true
      })
    }
  }

  // Clipboard monitoring with cliphist
  Process {
    id: clipboardProcess
    command: ["sh", "-c", "cliphist list | head -n 8"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var output = text.trim()
        if (output === "") {
          root.clipboardHistory = []
          return
        }
        
        var lines = output.split('\n')
        var history = []
        var now = new Date()
        
        for (var i = 0; i < lines.length && i < 8; i++) {
          if (lines[i] === "") continue
          
          // Cliphist format: "ID\tcontent"
          var parts = lines[i].split('\t')
          if (parts.length < 2) continue
          
          var content = parts.slice(1).join('\t') // Rejoin in case content has tabs
          
          // Clean up content: replace newlines/tabs with spaces, trim whitespace
          var cleanContent = content.replace(/[\n\r\t]+/g, ' ').replace(/\s+/g, ' ').trim()
          var displayContent = cleanContent.length > 200 ? cleanContent.substring(0, 200) + "..." : cleanContent
          
          history.push({
            id: parts[0],
            type: "text",
            content: displayContent,
            fullContent: content,
            itemNumber: i + 1
          })
        }
        
        root.clipboardHistory = history
        console.log("[clipboard] Loaded " + history.length + " items from cliphist")
      }
    }
  }
  
  Timer {
    interval: 2000 // Update every 2 seconds
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: {
      if (!clipboardProcess.running) {
        clipboardProcess.running = true
      }
    }
  }

  Process {
    id: appDiscoveryLoader
    command: [
      "python3",
      "-c",
      root.appCatalogLoaderScript
    ]

    stdout: StdioCollector {
      onStreamFinished: {
        var raw = text.trim()
        if (raw === "") {
          root.appCatalog = []
          root.appDataLoaded = true
          root.updateAppFilter()
          console.log("[app-discovery] loader returned empty dataset")
          return
        }

        try {
          var parsed = JSON.parse(raw)
          var mapped = []
          var seen = {}
          for (var i = 0; i < parsed.length; i++) {
            var entry = parsed[i] || {}
            var name = entry.name || ""
            var exec = entry.exec || ""
            var cleanExec = entry.cleanExec || root.cleanExecCommand(exec)
            if (!name || (!exec && !cleanExec)) continue
            var comment = entry.comment || ""
            var desktopId = entry.desktopId || ""
            var uniqueKey = desktopId || entry.path || (name + "::" + exec)
            if (uniqueKey && seen[uniqueKey]) continue
            if (uniqueKey) seen[uniqueKey] = true
            mapped.push({
              name: name,
              lowerName: name.toLowerCase(),
              exec: exec,
              cleanExec: cleanExec,
              cleanedExec: cleanExec,
              comment: comment,
              lowerComment: comment ? comment.toLowerCase() : "",
              icon: entry.icon || "",
              path: entry.path || "",
              desktopId: desktopId,
              argv: entry.argv || [],
              terminal: entry.terminal === true,
              categories: entry.categories || [],
              directory: entry.directory || ""
            })
          }
          mapped.sort(function(a, b) { return a.lowerName.localeCompare(b.lowerName) })
          root.appCatalog = mapped
          root.appDataLoaded = true
          root.updateAppFilter()
          console.log("[app-discovery] parsed " + mapped.length + " entries")
        } catch(e) {
          console.log("[app-discovery] JSON parse error: " + e)
          root.appCatalog = []
          root.appDataLoaded = true
          root.updateAppFilter()
        }
      }
    }

    stderr: StdioCollector {
      onStreamFinished: {
        var output = text.trim()
        if (output !== "") {
          console.log("[app-discovery] loader stderr:", output)
        }
      }
    }

    onExited: function(exitCode, exitStatus) {
      if (exitCode !== 0) {
        console.log("[app-discovery] loader exited with code " + exitCode + (exitStatus !== 0 ? (" status " + exitStatus) : ""))
        if (!root.appDataLoaded) {
          root.appDataLoaded = true
          root.updateAppFilter()
        }
      } else {
        console.log("[app-discovery] loader finished successfully")
      }
    }
  }

  Process {
    id: appLaunchProcess
    property var pendingApp: null
    property var pendingSteps: []
    property int currentStepIndex: -1
    property int launchAttemptCount: 0

    function resetLaunchState() {
      pendingApp = null
      pendingSteps = []
      currentStepIndex = -1
      launchAttemptCount = 0
    }

    stdout: StdioCollector {
      onStreamFinished: {
        var output = text.trim()
        if (output !== "") {
          console.log("[app-discovery] launch stdout:", output)
        }
      }
    }

    stderr: StdioCollector {
      onStreamFinished: {
        var output = text.trim()
        if (output !== "") {
          console.log("[app-discovery] launch stderr:", output)
        }
      }
    }

    onExited: function(exitCode, exitStatus) {
      var step = pendingSteps && pendingSteps.length > currentStepIndex && currentStepIndex >= 0 ? pendingSteps[currentStepIndex] : null
      var label = step ? step.label : "unknown"
      if (exitCode === 0) {
        var appName = pendingApp ? pendingApp.name : "unknown"
        console.log("[app-discovery] launch succeeded for", appName, "via", label)
        resetLaunchState()
      } else {
        var exitInfo = "exit " + exitCode
        if (exitStatus && exitStatus !== 0) {
          exitInfo += " status=" + exitStatus
        }
        console.log("[app-discovery] launch step", label, "failed (" + exitInfo + ")")
        Qt.callLater(function() { root.tryLaunchNextStep(exitInfo) })
      }
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

      // Left: Vertical Weather Widget - Sci-fi design
      Rectangle { // Weather Card
        id: weatherCard
        Layout.preferredWidth: 120
        Layout.fillHeight: true
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
          ColumnLayout { // Right: date and workspace
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            spacing: 12
            Label {
              text: root.dayText.toUpperCase()
              font.pixelSize: 18
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 0.5
              color: root.subTextColor
              horizontalAlignment: Text.AlignRight
            }
            
            // Workspace indicator
            Rectangle {
              Layout.alignment: Qt.AlignRight
              width: 90
              height: 28
              radius: 3
              color: Qt.rgba(0.651, 0.753, 0.575, 0.12)
              border.width: 1
              border.color: Qt.rgba(0.651, 0.753, 0.575, 0.3)
              
              RowLayout {
                anchors.centerIn: parent
                spacing: 6
                
                Label {
                  text: "󱂬"
                  font.pixelSize: 14
                  font.family: "JetBrainsMono Nerd Font"
                  color: root.accentColor
                  opacity: 0.8
                }
                
                Label {
                  text: "WS " + root.currentWorkspace
                  font.pixelSize: 11
                  font.weight: Font.Bold
                  font.family: "JetBrains Mono"
                  font.letterSpacing: 0.5
                  color: root.accentColor
                }
              }
            }
            
            // Uptime display
            RowLayout {
              spacing: 8
              Layout.alignment: Qt.AlignRight
              
              Label {
                text: "󱫋"
                font.pixelSize: 10
                font.family: "JetBrainsMono Nerd Font"
                color: root.accentColor
                opacity: 0.6
              }
              
              Label {
                text: root.uptimeDays + "d " + root.uptimeHours + "h " + root.uptimeMinutes + "m"
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.subTextColor
                opacity: 0.8
              }
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

          Item { Layout.fillWidth: true }

          Rectangle {
            width: 1
            height: 40
            color: root.borderColor
            opacity: 0.3
          }

          Rectangle {
            id: appDiscoveryButton
            Layout.preferredWidth: 160
            Layout.alignment: Qt.AlignVCenter
            height: 40
            radius: 4
            property bool hovered: false
            color: hovered ? Qt.rgba(0.651, 0.753, 0.575, 0.18) : Qt.rgba(0.651, 0.753, 0.575, 0.08)
            border.width: 1
            border.color: hovered ? Qt.rgba(0.651, 0.753, 0.575, 0.45) : Qt.rgba(0.651, 0.753, 0.575, 0.3)

            RowLayout {
              anchors.fill: parent
              anchors.margins: 12
              spacing: 10

              Rectangle {
                width: 24
                height: 24
                radius: 3
                color: Qt.rgba(0, 0, 0, 0.25)

                Label {
                  anchors.centerIn: parent
                  text: "󰍉"
                  font.pixelSize: 14
                  font.family: "JetBrainsMono Nerd Font"
                  color: root.accentColor
                }
              }

              ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Label {
                  text: "APP DISCOVERY"
                  font.pixelSize: 10
                  font.weight: Font.Bold
                  font.family: "JetBrains Mono"
                  color: root.textColor
                  elide: Text.ElideRight
                }

                Label {
                  text: "Search installed apps"
                  font.pixelSize: 8
                  font.family: "JetBrains Mono"
                  color: root.subTextColor
                  opacity: 0.7
                  elide: Text.ElideRight
                }
              }
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onEntered: appDiscoveryButton.hovered = true
              onExited: appDiscoveryButton.hovered = false
              onClicked: appDiscoveryWindow.toggleVisibility()
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
          anchors.fill: parent
          anchors.margins: 16
          spacing: 10
          
          // Header
          RowLayout {
            spacing: 8
            Layout.fillWidth: true
            
            Label {
              text: "BLUETOOTH"
              font.pixelSize: 10
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 2
              color: root.redColor
              opacity: 0.8
            }
            
            Item { Layout.fillWidth: true }
            
            // Toggle indicator
            Rectangle {
              width: 32
              height: 16
              radius: 8
              color: root.bluetoothEnabled ? Qt.rgba(0.902, 0.494, 0.502, 0.3) : Qt.rgba(0.5, 0.5, 0.5, 0.2)
              border.width: 1
              border.color: root.bluetoothEnabled ? root.redColor : root.subTextColor
              
              Rectangle {
                width: 12
                height: 12
                radius: 6
                x: root.bluetoothEnabled ? parent.width - width - 2 : 2
                y: 2
                color: root.bluetoothEnabled ? root.redColor : root.subTextColor
                
                Behavior on x { NumberAnimation { duration: 150 } }
              }
              
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  // Toggle bluetooth with immediate refresh
                  var cmd = root.bluetoothEnabled ? "bluetoothctl power off" : "bluetoothctl power on"
                  var toggleProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["sh", "-c", "' + cmd + '"] }', root)
                  toggleProcess.running = true
                  // Immediate refresh after toggle
                  Qt.callLater(function() {
                    setTimeout(function() { root.refreshBluetooth() }, 300)
                  })
                }
              }
            }
          }
          
          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: root.redColor
            opacity: 0.3
          }
          
          // Bluetooth disabled state - centered with enable button
          Item {
            visible: !root.bluetoothEnabled
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
              anchors.centerIn: parent
              spacing: 16
              
              Rectangle {
                width: 56
                height: 56
                radius: 2
                color: Qt.rgba(0.5, 0.5, 0.5, 0.1)
                Layout.alignment: Qt.AlignHCenter
                border.width: 2
                border.color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
                
                Label {
                  anchors.centerIn: parent
                  text: "󰂲"
                  font.pixelSize: 28
                  font.family: "JetBrainsMono Nerd Font"
                  color: root.subTextColor
                }
              }
              
              Label {
                text: "MODULE DISABLED"
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1.5
                color: root.subTextColor
                opacity: 0.8
                Layout.alignment: Qt.AlignHCenter
              }
              
              // Enable button
              Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 200
                height: 40
                radius: 3
                color: Qt.rgba(0.902, 0.494, 0.502, 0.15)
                border.width: 2
                border.color: Qt.rgba(0.902, 0.494, 0.502, 0.4)
                
                Label {
                  anchors.centerIn: parent
                  text: "ENABLE BLUETOOTH"
                  font.pixelSize: 10
                  font.weight: Font.Bold
                  font.family: "JetBrains Mono"
                  font.letterSpacing: 1
                  color: root.redColor
                }
                
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: {
                    var toggleProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["sh", "-c", "bluetoothctl power on"] }', root)
                    toggleProcess.running = true
                    Qt.callLater(function() {
                      setTimeout(function() { root.refreshBluetooth() }, 300)
                    })
                  }
                }
              }
            }
          }
          
          // Bluetooth enabled state - show icon, status, and devices
          ColumnLayout {
            visible: root.bluetoothEnabled
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            
            Rectangle {
              width: 56
              height: 56
              radius: 2
              color: Qt.rgba(0.902, 0.494, 0.502, 0.15)
              Layout.alignment: Qt.AlignHCenter
              border.width: 2
              border.color: Qt.rgba(0.902, 0.494, 0.502, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: "󰂯"
                font.pixelSize: 28
                font.family: "JetBrainsMono Nerd Font"
                color: root.redColor
              }
            }
            
            Label {
              text: "ENABLED"
              font.pixelSize: 9
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 1
              color: root.redColor
              opacity: 0.8
              Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 1
              color: root.redColor
              opacity: 0.2
            }
            
            // Devices list
            Flickable {
              Layout.fillWidth: true
              Layout.fillHeight: true
              contentHeight: devicesColumn.height
              clip: true
            
            ColumnLayout {
              id: devicesColumn
              width: parent.width
              spacing: 4
              
              Label {
                text: "DEVICES"
                font.pixelSize: 8
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
                opacity: 0.6
              }
              
              Repeater {
                model: root.bluetoothDevices
                
                Rectangle {
                  Layout.fillWidth: true
                  Layout.preferredHeight: 32
                  radius: 2
                  color: modelData.connected ? Qt.rgba(0.902, 0.494, 0.502, 0.1) : "transparent"
                  border.width: 1
                  border.color: modelData.connected ? Qt.rgba(0.902, 0.494, 0.502, 0.3) : Qt.rgba(0.5, 0.5, 0.5, 0.2)
                  
                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 6
                    
                    Label {
                      text: modelData.connected ? "󰂱" : (modelData.paired ? "󰂯" : "󰂲")
                      font.pixelSize: 12
                      font.family: "JetBrainsMono Nerd Font"
                      color: modelData.connected ? root.redColor : root.subTextColor
                    }
                    
                    Label {
                      text: modelData.name
                      font.pixelSize: 9
                      font.family: "JetBrains Mono"
                      color: modelData.connected ? root.textColor : root.subTextColor
                      elide: Text.ElideRight
                      Layout.fillWidth: true
                    }
                  }
                  
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                      // Toggle connection with immediate refresh
                      var cmd = modelData.connected ? "bluetoothctl disconnect " + modelData.mac : "bluetoothctl connect " + modelData.mac
                      var connectProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["sh", "-c", "' + cmd + '"] }', root)
                      connectProcess.running = true
                      // Immediate refresh after connection toggle
                      Qt.callLater(function() {
                        setTimeout(function() { root.refreshBluetooth() }, 500)
                      })
                    }
                  }
                }
              }
              
              ColumnLayout {
                visible: root.bluetoothDevices.length === 0
                spacing: 4
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                
                Label {
                  text: root.bluetoothEnabled ? "NO DEVICES" : "MODULE DISABLED"
                  font.pixelSize: 9
                  font.weight: Font.Bold
                  font.family: "JetBrains Mono"
                  font.letterSpacing: 1
                  color: root.subTextColor
                  opacity: 0.6
                  Layout.alignment: Qt.AlignHCenter
                }
                
                Label {
                  visible: root.bluetoothEnabled
                  text: "Pair devices to see them here"
                  font.pixelSize: 8
                  font.family: "JetBrains Mono"
                  color: root.subTextColor
                  opacity: 0.4
                  Layout.alignment: Qt.AlignHCenter
                  horizontalAlignment: Text.AlignHCenter
                  wrapMode: Text.WordWrap
                  Layout.preferredWidth: 200
                }
              }
            }
          }
          }
        }
        }

        Rectangle { // Storage Size Display - Sci-fi lab design
        id: storageCard
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
        
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 16
          spacing: 12
          
          ColumnLayout {
            spacing: 6
            Layout.alignment: Qt.AlignHCenter
            
            Label {
              text: "STORAGE SIZE"
              font.pixelSize: 10
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 2
              color: root.purpleColor
              opacity: 0.8
              Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
              width: 56
              height: 56
              radius: 2
              color: Qt.rgba(0.843, 0.6, 0.714, 0.1)
              Layout.alignment: Qt.AlignHCenter
              border.width: 2
              border.color: Qt.rgba(0.843, 0.6, 0.714, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: "󰋊"
                font.pixelSize: 28
                font.family: "JetBrainsMono Nerd Font"
                color: root.purpleColor
              }
            }
          }
          
          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: root.purpleColor
            opacity: 0.3
          }
          
          // ROOT partition
          ColumnLayout {
            spacing: 6
            Layout.fillWidth: true
            
            RowLayout {
              spacing: 6
              
              Label {
                text: "ROOT (/)"
                font.pixelSize: 9
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
              }
              
              Item { Layout.fillWidth: true }
              
              Label {
                text: root.diskUsageRoot
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.textColor
              }
            }
            
            Label {
              text: root.diskPercentRoot + "% used"
              font.pixelSize: 8
              font.family: "JetBrains Mono"
              color: root.subTextColor
              opacity: 0.7
            }
          }
          
          // HOME partition
          ColumnLayout {
            spacing: 6
            Layout.fillWidth: true
            
            RowLayout {
              spacing: 6
              
              Label {
                text: "HOME (~)"
                font.pixelSize: 9
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
              }
              
              Item { Layout.fillWidth: true }
              
              Label {
                text: root.diskUsageHome
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.textColor
              }
            }
            
            Label {
              text: root.diskPercentHome + "% used"
              font.pixelSize: 8
              font.family: "JetBrains Mono"
              color: root.subTextColor
              opacity: 0.7
            }
          }
        }
        }
        
        Rectangle { // Media Player Panel - Sci-fi geometric design
        id: mediaCard
        Layout.preferredWidth: 360
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
          anchors.margins: 14
          spacing: 8
          
          // Header with source selector
          ColumnLayout {
            spacing: 6
            Layout.fillWidth: true
            
            RowLayout {
              spacing: 8
              Layout.fillWidth: true
              
              Label {
                text: "MEDIA PLAYER"
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 2
                color: root.yellowColor
                opacity: 0.8
              }
              
              Item { Layout.fillWidth: true }
              
              Label {
                text: root.mediaPlayers.length > 1 ? root.mediaPlayers.length + " SOURCES" : ""
                font.pixelSize: 7
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                font.letterSpacing: 1
                color: root.subTextColor
                opacity: 0.5
                visible: root.mediaPlayers.length > 1
              }
            }
            
            // Source switcher (only visible when multiple sources)
            RowLayout {
              spacing: 3
              Layout.fillWidth: true
              visible: root.mediaPlayers.length > 1
              
              Repeater {
                model: root.mediaPlayers
                
                Rectangle {
                  Layout.fillWidth: true
                  Layout.preferredHeight: 20
                  radius: 2
                  color: index === root.currentPlayerIndex ? Qt.rgba(0.859, 0.737, 0.498, 0.15) : Qt.rgba(0.859, 0.737, 0.498, 0.05)
                  border.width: 1
                  border.color: index === root.currentPlayerIndex ? Qt.rgba(0.859, 0.737, 0.498, 0.4) : Qt.rgba(0.859, 0.737, 0.498, 0.2)
                  
                  Label {
                    anchors.centerIn: parent
                    text: modelData.toUpperCase()
                    font.pixelSize: 6
                    font.weight: Font.Bold
                    font.family: "JetBrains Mono"
                    font.letterSpacing: 0.5
                    color: index === root.currentPlayerIndex ? root.yellowColor : root.subTextColor
                    elide: Text.ElideRight
                    width: parent.width - 6
                    horizontalAlignment: Text.AlignHCenter
                  }
                  
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                      root.currentPlayerIndex = index
                      mediaProcess.running = true
                    }
                  }
                }
              }
            }
          }
          
          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: root.yellowColor
            opacity: 0.3
          }
          
          // Media info
          ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5
            
            Rectangle {
              width: 48
              height: 48
              radius: 2
              color: Qt.rgba(0.859, 0.737, 0.498, 0.1)
              Layout.alignment: Qt.AlignHCenter
              border.width: 2
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: root.mediaPlaying ? "" : "󱗝"
                font.pixelSize: 24
                font.family: "JetBrainsMono Nerd Font"
                color: root.yellowColor
              }
            }
            
            ColumnLayout {
              spacing: 2
              Layout.fillWidth: true
              Layout.alignment: Qt.AlignHCenter
              
              Label {
                text: root.mediaTitle
                font.pixelSize: 10
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.textColor
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                Layout.preferredWidth: 320
              }
              
              Label {
                text: root.mediaArtist
                font.pixelSize: 8
                font.family: "JetBrains Mono"
                color: root.subTextColor
                opacity: 0.8
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                Layout.preferredWidth: 320
                visible: root.mediaArtist !== ""
              }
            }
          }
          
          // Controls
          Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            
          RowLayout {
            anchors.centerIn: parent
            spacing: 8
            
            Rectangle {
              width: 32
              height: 32
              radius: 2
              color: Qt.rgba(0.859, 0.737, 0.498, 0.1)
              border.width: 1
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰒮"
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                color: root.yellowColor
              }
              
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  var player = root.mediaPlayers.length > 0 ? root.mediaPlayers[root.currentPlayerIndex] : ""
                  if (player !== "") {
                    var prevProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["playerctl", "-p", "' + player + '", "previous"] }', root)
                    prevProcess.running = true
                  }
                }
              }
            }
            
            Rectangle {
              width: 38
              height: 38
              radius: 2
              color: Qt.rgba(0.859, 0.737, 0.498, 0.15)
              border.width: 2
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.4)
              
              Label {
                anchors.centerIn: parent
                text: root.mediaPlaying ? "󰏤" : "󰐊"
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
                color: root.yellowColor
              }
              
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  var player = root.mediaPlayers.length > 0 ? root.mediaPlayers[root.currentPlayerIndex] : ""
                  if (player !== "") {
                    var playPauseProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["playerctl", "-p", "' + player + '", "play-pause"] }', root)
                    playPauseProcess.running = true
                  }
                }
              }
            }
            
            Rectangle {
              width: 32
              height: 32
              radius: 2
              color: Qt.rgba(0.859, 0.737, 0.498, 0.1)
              border.width: 1
              border.color: Qt.rgba(0.859, 0.737, 0.498, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰒭"
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                color: root.yellowColor
              }
              
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  var player = root.mediaPlayers.length > 0 ? root.mediaPlayers[root.currentPlayerIndex] : ""
                  if (player !== "") {
                    var nextProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["playerctl", "-p", "' + player + '", "next"] }', root)
                    nextProcess.running = true
                  }
                }
              }
            }
          }
          }
        }
        }
      }
      } // end of right content column
      
      // Notifications Panel (right side)
      Rectangle {
        id: notificationsPanel
        Layout.preferredWidth: 248
        Layout.fillHeight: true
        radius: 4
        color: root.primaryColor
        border.width: 2
        border.color: Qt.rgba(0.498, 0.733, 0.702, 0.4) // tealColor
        
        // Technical shadow
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "black"
          opacity: 0.3
          x: 3
          z: -1
        }
        
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 16
          spacing: 12
          
          // Header
          RowLayout {
            spacing: 8
            Layout.fillWidth: true
            
            Rectangle {
              width: 32
              height: 32
              radius: 2
              color: Qt.rgba(0.498, 0.733, 0.702, 0.12)
              border.width: 1
              border.color: Qt.rgba(0.498, 0.733, 0.702, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰂚"
                font.pixelSize: 16
                font.family: "JetBrainsMono Nerd Font"
                color: root.tealColor
              }
            }
            
            Label {
              text: "NOTIFY"
              font.pixelSize: 10
              font.weight: Font.Bold
              font.family: "JetBrains Mono"
              font.letterSpacing: 2
              color: root.tealColor
              opacity: 0.8
            }
            
            Item { Layout.fillWidth: true }
            
            // Clear all button
            Rectangle {
              visible: root.clipboardHistory.length > 0
              width: 28
              height: 28
              radius: 2
              color: Qt.rgba(0.902, 0.494, 0.502, 0.1)
              border.width: 1
              border.color: Qt.rgba(0.902, 0.494, 0.502, 0.3)
              
              Label {
                anchors.centerIn: parent
                text: "󰩺"
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                color: root.redColor
                opacity: 0.8
              }
              
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = Qt.rgba(0.902, 0.494, 0.502, 0.15)
                onExited: parent.color = Qt.rgba(0.902, 0.494, 0.502, 0.1)
                onClicked: {
                  // Wipe all cliphist history
                  var wipeProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["cliphist", "wipe"] }', root)
                  wipeProcess.running = true
                  console.log("[clipboard] Wiped all clipboard history")
                  root.clipboardHistory = []
                }
              }
            }
          }
          
          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: root.tealColor
            opacity: 0.3
          }
          
          // Clipboard history
          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
              anchors.fill: parent
              spacing: 0
              
              // Empty state
              Item {
                visible: root.clipboardHistory.length === 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                ColumnLayout {
                  anchors.centerIn: parent
                  spacing: 12
                  
                  Rectangle {
                    width: 56
                    height: 56
                    radius: 2
                    color: Qt.rgba(0.498, 0.733, 0.702, 0.1)
                    Layout.alignment: Qt.AlignHCenter
                    border.width: 2
                    border.color: Qt.rgba(0.498, 0.733, 0.702, 0.3)
                    
                    Label {
                      anchors.centerIn: parent
                      text: "󰜦"
                      font.pixelSize: 28
                      font.family: "JetBrainsMono Nerd Font"
                      color: root.tealColor
                      opacity: 0.6
                    }
                  }
                  
                  Label {
                    text: "CLIPBOARD EMPTY"
                    font.pixelSize: 9
                    font.weight: Font.Bold
                    font.family: "JetBrains Mono"
                    font.letterSpacing: 1.5
                    color: root.tealColor
                    opacity: 0.6
                    Layout.alignment: Qt.AlignHCenter
                  }
                  
                  Label {
                    text: "Copy something\nto see it here"
                    font.pixelSize: 8
                    font.family: "JetBrains Mono"
                    color: root.subTextColor
                    opacity: 0.5
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                  }
                }
              }
              
              // Clipboard items list
              Flickable {
                visible: root.clipboardHistory.length > 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: clipItemsColumn.height
                clip: true
                
                ColumnLayout {
                  id: clipItemsColumn
                  width: parent.width
                  spacing: 6
                  
                  Repeater {
                    model: root.clipboardHistory
                    
                    Rectangle {
                      id: clipItem
                      Layout.fillWidth: true
                      Layout.preferredHeight: 32
                      radius: 2
                      color: clipItemMouse.containsMouse ? Qt.rgba(0.498, 0.733, 0.702, 0.1) : Qt.rgba(0.498, 0.733, 0.702, 0.05)
                      border.width: 1
                      border.color: clipItemMouse.containsMouse ? Qt.rgba(0.498, 0.733, 0.702, 0.3) : Qt.rgba(0.498, 0.733, 0.702, 0.2)
                      
                      RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        
                        Label {
                          text: "#" + modelData.itemNumber
                          font.pixelSize: 7
                          font.weight: Font.Bold
                          font.family: "JetBrains Mono"
                          color: root.tealColor
                          opacity: 0.5
                          Layout.alignment: Qt.AlignVCenter
                        }
                        
                        Label {
                          text: modelData.content
                          font.pixelSize: 9
                          font.family: "JetBrains Mono"
                          color: root.textColor
                          opacity: 0.85
                          Layout.fillWidth: true
                          Layout.alignment: Qt.AlignVCenter
                          elide: Text.ElideRight
                          maximumLineCount: 1
                        }
                      }
                      
                      // Click to copy
                      MouseArea {
                        id: clipItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                          var clipId = modelData.id
                          var copyProcess = Qt.createQmlObject('import Quickshell.Io; Process { command: ["sh", "-c", "cliphist decode ' + clipId + ' | wl-copy"] }', clipItem)
                          copyProcess.running = true
                          console.log("[clipboard] Copied item " + clipId + " to clipboard")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } // end of main row
  }

  PanelWindow {
    id: appDiscoveryWindow
    color: "transparent"
    focusable: true
    visible: false
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 520
    implicitHeight: 620

    Keys.onEscapePressed: hide()
    Keys.onPressed: function(event) {
      if (handleNavigationKey(event)) {
        event.accepted = true
      }
    }

    function handleNavigationKey(event) {
      if (!visible || !event || typeof event.key !== "number" || !appList) return false
      var key = event.key
      var count = root.appFilteredApps.length
      if (key === Qt.Key_Return || key === Qt.Key_Enter) {
        if (root.appSelectedIndex >= 0 && root.appSelectedIndex < count) {
          root.launchApp(root.appFilteredApps[root.appSelectedIndex])
        }
        return true
      }
      if (count <= 0) return false

      var current = root.appSelectedIndex >= 0 ? root.appSelectedIndex : 0
      var step = Math.max(1, Math.floor(appList.height / 52))

      switch (key) {
        case Qt.Key_Down: {
          var next = Math.min(current + 1, count - 1)
          if (next !== root.appSelectedIndex) {
            root.appSelectedIndex = next
          } else {
            appList.positionViewAtIndex(next, ListView.Contain)
          }
          return true
        }
        case Qt.Key_Up: {
          var prev = Math.max(current - 1, 0)
          if (prev !== root.appSelectedIndex) {
            root.appSelectedIndex = prev
          } else {
            appList.positionViewAtIndex(prev, ListView.Contain)
          }
          return true
        }
        case Qt.Key_PageDown: {
          var downIndex = Math.min(current + step, count - 1)
          if (downIndex !== root.appSelectedIndex) {
            root.appSelectedIndex = downIndex
          } else {
            appList.positionViewAtIndex(downIndex, ListView.Contain)
          }
          return true
        }
        case Qt.Key_PageUp: {
          var upIndex = Math.max(current - step, 0)
          if (upIndex !== root.appSelectedIndex) {
            root.appSelectedIndex = upIndex
          } else {
            appList.positionViewAtIndex(upIndex, ListView.Contain)
          }
          return true
        }
        case Qt.Key_Home: {
          if (root.appSelectedIndex !== 0) {
            root.appSelectedIndex = 0
          } else {
            appList.positionViewAtIndex(0, ListView.Beginning)
          }
          return true
        }
        case Qt.Key_End: {
          var last = count - 1
          if (root.appSelectedIndex !== last) {
            root.appSelectedIndex = last
          } else {
            appList.positionViewAtIndex(last, ListView.End)
          }
          return true
        }
        default:
          return false
      }
    }

    function toggleVisibility() {
      if (visible) {
        hide()
      } else {
        show()
      }
    }

    function show() {
      if (!visible) {
        root.ensureAppDataLoaded()
        visible = true
      }
    }

    function hide() {
      if (visible) {
        visible = false
      }
    }

    onVisibleChanged: {
      if (visible) {
        root.ensureAppDataLoaded()
        root.appSearchTerm = ""
        Qt.callLater(function() {
          searchField.forceActiveFocus()
          searchField.selectAll()
        })
      }
    }

    Component.onCompleted: {
      try {
        var targetScreen = Quickshell.primaryScreen
        if (targetScreen && targetScreen.geometry) {
          var screenWidth = targetScreen.geometry.width
          var screenHeight = targetScreen.geometry.height
          if (screenWidth > 0 && screenHeight > 0) {
            x = Math.max(0, (screenWidth - implicitWidth) / 2)
            y = Math.max(0, (screenHeight - implicitHeight) / 3)
            console.log("[app-discovery] window positioned at (" + x + ", " + y + ")")
          }
        }
      } catch(e) {
        console.log("[app-discovery] positioning error", e)
      }
    }

    Rectangle {
      anchors.fill: parent
      radius: 8
      color: root.primaryColor
      border.width: 2
      border.color: root.borderColor

      Rectangle {
        anchors.fill: parent
        anchors.margins: -8
        radius: parent.radius + 4
        color: Qt.rgba(0, 0, 0, 0.28)
        z: -1
        opacity: 0.7
      }

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        RowLayout {
          Layout.fillWidth: true
          spacing: 8

          Label {
            text: "APP DISCOVERY"
            font.pixelSize: 14
            font.weight: Font.Bold
            font.family: "JetBrains Mono"
            font.letterSpacing: 1
            color: root.textColor
          }

          Item { Layout.fillWidth: true }

          Rectangle {
            width: 28
            height: 28
            radius: 4
            color: Qt.rgba(0.651, 0.753, 0.575, 0.08)
            border.width: 1
            border.color: Qt.rgba(0.651, 0.753, 0.575, 0.3)

            Label {
              anchors.centerIn: parent
              text: "󰑓"
              font.pixelSize: 14
              font.family: "JetBrainsMono Nerd Font"
              color: root.accentColor
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                root.appDataLoaded = false
                root.appCatalog = []
                root.ensureAppDataLoaded()
              }
            }
          }
        }

        TextField {
          id: searchField
          Layout.fillWidth: true
          placeholderText: "Search applications…"
          text: root.appSearchTerm
          color: root.textColor
          selectionColor: root.accentColor
          selectedTextColor: root.primaryColor
          font.family: "JetBrains Mono"
          font.pixelSize: 12
          onTextChanged: {
            if (root.appSearchTerm !== text) {
              root.appSearchTerm = text
            }
          }
          Keys.onPressed: function(event) {
            if (appDiscoveryWindow.handleNavigationKey(event)) {
              event.accepted = true
            }
          }

          background: Rectangle {
            radius: 4
            color: Qt.rgba(0, 0, 0, 0.2)
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.08)
          }
        }

        StackLayout {
          Layout.fillWidth: true
          Layout.fillHeight: true
          currentIndex: root.appDataLoaded ? (root.appFilteredApps.length > 0 ? 2 : 1) : 0

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
              anchors.centerIn: parent
              spacing: 8

              BusyIndicator {
                running: true
                implicitWidth: 32
                implicitHeight: 32
              }

              Label {
                text: "Loading applications…"
                font.pixelSize: 10
                font.family: "JetBrains Mono"
                color: root.subTextColor
              }
            }
          }

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
              anchors.centerIn: parent
              spacing: 6

              Label {
                text: root.appSearchTerm.length > 0 ? "No matches" : "No applications found"
                font.pixelSize: 12
                font.weight: Font.Bold
                font.family: "JetBrains Mono"
                color: root.subTextColor
              }

              Label {
                text: root.appSearchTerm.length > 0 ? "Try a different query" : "Install applications to populate the list"
                font.pixelSize: 9
                font.family: "JetBrains Mono"
                color: root.subTextColor
                opacity: 0.7
              }
            }
          }

          ListView {
            id: appList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.appFilteredApps
            clip: true
            spacing: 6
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationWraps: false
            preferredHighlightBegin: 0
            preferredHighlightEnd: height
            highlightFollowsCurrentItem: false
            ScrollBar.vertical: ScrollBar { }

            delegate: Rectangle {
              required property var modelData
              width: ListView.view ? ListView.view.width : parent ? parent.width : 0
              height: 52
              radius: 4
              color: index === appList.currentIndex ? Qt.rgba(0.651, 0.753, 0.575, 0.18) : Qt.rgba(1, 1, 1, 0.03)
              border.width: 1
              border.color: index === appList.currentIndex ? Qt.rgba(0.651, 0.753, 0.575, 0.35) : Qt.rgba(1, 1, 1, 0.08)

              RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                Rectangle {
                  width: 28
                  height: 28
                  radius: 4
                  color: Qt.rgba(0, 0, 0, 0.35)

                  Label {
                    anchors.centerIn: parent
                    text: modelData.name ? modelData.name.charAt(0).toUpperCase() : "?"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    font.family: "JetBrains Mono"
                    color: root.textColor
                  }
                }

                ColumnLayout {
                  Layout.fillWidth: true
                  spacing: 2

                  Label {
                    text: modelData.name
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.family: "JetBrains Mono"
                    color: root.textColor
                    elide: Text.ElideRight
                  }

                  Label {
                    visible: modelData.comment && modelData.comment.length > 0
                    text: modelData.comment
                    font.pixelSize: 10
                    font.family: "JetBrains Mono"
                    color: root.subTextColor
                    opacity: 0.8
                    elide: Text.ElideRight
                  }
                }
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                  appList.currentIndex = index
                }
                onClicked: {
                  if (appList.currentIndex !== index) {
                    appList.currentIndex = index
                  } else {
                    root.launchApp(modelData)
                  }
                }
                onDoubleClicked: root.launchApp(modelData)
              }
            }

            onCurrentIndexChanged: {
              if (root.appSelectedIndex !== currentIndex) {
                root.appSelectedIndex = currentIndex
              }
            }

            function ensureIndexVisible(index) {
              if (index < 0) return
              positionViewAtIndex(index, ListView.Contain)
            }
          }
        }

        Connections {
          target: root
          function onAppSelectedIndexChanged() {
            if (root.appSelectedIndex !== appList.currentIndex) {
              appList.currentIndex = root.appSelectedIndex
              appList.ensureIndexVisible(root.appSelectedIndex)
            }
          }
        }
      }
    }
  }
}
