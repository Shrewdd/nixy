{ pkgs, ... }:

let
  mocha = import ../../shared/theme/catppuccin-mocha-base16.nix;

  configDir = pkgs.writeTextDir "shell.qml" ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Services.Pipewire

    ShellRoot {
      QtObject {
        id: audio

        readonly property var sink: Pipewire.defaultAudioSink
        readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0
        readonly property bool muted: (sink && sink.audio) ? sink.audio.muted : false

        function clamp01(v) {
          return Math.max(0, Math.min(1.0, v));
        }

        function setVolume(v) {
          if (!sink || !sink.audio)
            return;
          sink.audio.muted = false;
          sink.audio.volume = clamp01(v);
        }

        function stepVolume(delta) {
          setVolume(volume + delta);
        }
      }

      PanelWindow {
        id: panel
        anchors {
          top: true
          left: true
          right: true
        }
        margins {
          top: 8
          left: 8
          right: 8
        }
        implicitHeight: 40

        property bool volumeOpen: false

        Rectangle {
          anchors.fill: parent
          radius: 8
          border.color: "#${mocha.base02}"
          border.width: 2
          gradient: Gradient {
            GradientStop { position: 0; color: "#${mocha.base00}" }
            GradientStop { position: 1; color: "#${mocha.base01}" }
          }
        }

        RowLayout {
          anchors.fill: parent
          anchors.margins: 8
          spacing: 8

          Rectangle {
            id: timeBox
            width: 100
            height: 24
            color: "#${mocha.base01}"
            radius: 6
            border.color: "#${mocha.base02}"
            border.width: 1
            Layout.alignment: Qt.AlignVCenter

            Column {
              anchors.fill: parent
              anchors.margins: 4
              spacing: 0

              Text {
                id: timeText
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Noto Sans"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: "#${mocha.base05}"
                text: Qt.formatTime(new Date(), "hh:mm")
              }

              Text {
                id: dateText
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Noto Sans"
                font.pixelSize: 9
                color: "#${mocha.base04}"
                text: Qt.formatDate(new Date(), "ddd d MMM")
              }

              Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                  timeText.text = Qt.formatTime(new Date(), "hh:mm");
                  dateText.text = Qt.formatDate(new Date(), "ddd d MMM");
                }
              }
            }
          }

          Rectangle {
            id: appsBox
            width: 80
            height: 24
            color: "#${mocha.base01}"
            radius: 6
            border.color: "#${mocha.base02}"
            border.width: 1
            Layout.alignment: Qt.AlignVCenter

            Text {
              anchors.centerIn: parent
              font.family: "Noto Sans"
              font.pixelSize: 10
              font.weight: Font.DemiBold
              color: "#${mocha.base05}"
              text: "Apps 3"
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor

              onEntered: appsBox.border.color = "#${mocha.base0C}";
              onExited: appsBox.border.color = "#${mocha.base02}";
            }
          }

          Rectangle {
            id: activeBox
            Layout.fillWidth: true
            height: 24
            color: "#${mocha.base01}"
            radius: 6
            border.color: "#${mocha.base02}"
            border.width: 1

            Text {
              anchors.fill: parent
              anchors.margins: 6
              font.family: "Noto Sans"
              font.pixelSize: 10
              font.weight: Font.DemiBold
              color: "#${mocha.base05}"
              verticalAlignment: Text.AlignVCenter
              horizontalAlignment: Text.AlignHCenter
              elide: Text.ElideRight
              text: "Active: Quickshell"
            }
          }

          Rectangle {
            id: volumeBox
            width: 100
            height: 24
            color: "#${mocha.base01}"
            radius: 6
            border.color: panel.volumeOpen ? "#${mocha.base0C}" : "#${mocha.base02}"
            border.width: 1
            Layout.alignment: Qt.AlignVCenter

            Text {
              id: volumeText
              anchors.centerIn: parent
              font.family: "Noto Sans"
              font.pixelSize: 10
              font.weight: Font.DemiBold
              color: panel.volumeOpen ? "#${mocha.base0C}" : "#${mocha.base05}"
              text: audio.muted ? "Muted" : ("Vol " + Math.round(audio.volume * 100) + "%")
            }

            MouseArea {
              id: volumeMouse
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              acceptedButtons: Qt.LeftButton

              onClicked: panel.volumeOpen = !panel.volumeOpen

              onWheel: wheel => {
                const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                audio.stepVolume(step);
              }
            }

            Behavior on border.color {
              ColorAnimation { duration: 150 }
            }
          }
        }
      }

      PanelWindow {
        id: volumePopout
        visible: panel.volumeOpen
        color: "transparent"

        WlrLayershell.namespace: "nixy"
        WlrLayershell.layer: WlrLayershell.Overlay
        WlrLayershell.exclusiveZone: 0

        anchors {
          top: true
          right: true
        }
        margins {
          top: panel.margins.top + panel.implicitHeight + 8
          right: panel.margins.right
        }

        implicitWidth: 200
        implicitHeight: 140

        function updateVolumeFromPosition(x) {
          const ratio = Math.max(0, Math.min(1, x / sliderTrack.width));
          audio.setVolume(ratio);
        }

        Item {
          anchors.fill: parent
          opacity: panel.volumeOpen ? 1 : 0
          scale: panel.volumeOpen ? 1 : 0.9

          Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
          }

          Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
          }

          Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#${mocha.base01}"
            border.color: "#${mocha.base02}"
            border.width: 2
          }

          Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
              font.family: "Noto Sans"
              font.pixelSize: 12
              font.weight: Font.Bold
              color: "#${mocha.base05}"
              text: "Volume"
            }

            Text {
              font.family: "Noto Sans"
              font.pixelSize: 10
              color: "#${mocha.base04}"
              text: audio.muted ? "Muted" : (Math.round(audio.volume * 100) + "%")
            }

            Rectangle {
              id: sliderTrack
              width: parent.width
              height: 10
              color: "#${mocha.base00}"
              radius: 5
              border.color: "#${mocha.base02}"
              border.width: 1

              Rectangle {
                width: sliderTrack.width * Math.max(0, Math.min(1, audio.volume))
                height: sliderTrack.height
                color: "#${mocha.base0D}"
                radius: 5

                Behavior on width {
                  NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: mouse => volumePopout.updateVolumeFromPosition(mouse.x)
                onPositionChanged: mouse => {
                  if (pressed)
                    volumePopout.updateVolumeFromPosition(mouse.x);
                }
                onWheel: wheel => {
                  const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                  audio.stepVolume(step);
                }
              }
            }

            Text {
              font.family: "Noto Sans"
              font.pixelSize: 9
              color: "#${mocha.base04}"
              text: "Scroll or drag"
            }
          }
        }
      }
    }
  '';

in
{
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;

    configs.default = configDir;
    activeConfig = "default";

    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
