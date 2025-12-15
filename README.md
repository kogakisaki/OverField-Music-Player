<div align="center">

# 🎹 OverField Music Player

**Automated Piano & Guitar Player for "OverField"**

[![AutoHotkey v2](https://img.shields.io/badge/Language-AutoHotkey_v2-green?style=for-the-badge&logo=autohotkey)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)](LICENSE)

<br>

[ **🇺🇸 English** ](README.md) &nbsp;|&nbsp; [ **🇻🇳 Tiếng Việt** ](docs/README_vi.md) &nbsp;|&nbsp; [ **🇨🇳 简体中文** ](docs/README_zh.md) &nbsp;|&nbsp; [ **🇯🇵 日本語** ](docs/README_ja.md) &nbsp;|&nbsp; [ **🇮🇩 Bahasa Indonesia** ](docs/README_id.md)

<br>

<br>

![OverField Music Player Demo](docs/img/demo.png)

</div>

> [!NOTE]
> **⚠️ Game Version Notice**
> The **musical furniture** is currently **only available in the Chinese server** of "OverField" (开放空间).
> You can download it here: [Bilibili Game Download](https://www.biligame.com/detail/?id=114015&spm_id_from=555.224.0.0&sourceFrom=1600820011)

---

## 📖 Table of Contents

- [Introduction](#-introduction)
- [Key Features](#-key-features)
- [Installation](#-installation)
- [Usage Guide](#-usage-guide)
- [Controls & Hotkeys](#-controls--hotkeys)
- [Configuration](#-configuration)
- [Song Format](#-song-format)

---

## 🌟 Introduction

**OverField Music Player** is a high-precision automation script designed to play complex musical arrangements in the game _OverField_. It fully supports **Piano** and **Electric Guitar** (which share the same key layout). Built with **AutoHotkey v2**, it bridges the gap between MIDI compositions and in-game performance, offering millisecond-accurate timing and a suite of real-time controls.

> [!TIP]
> **Enjoying the tool?** Please consider giving this project a ⭐ **Star** on GitHub to support development!

## ✨ Key Features

| Feature                 | Description                                                                  |
| :---------------------- | :--------------------------------------------------------------------------- |
| **🎯 Precision Timing** | Uses `timeBeginPeriod(1)` and hybrid wait loops for accurate note execution. |
| **📂 Music Library**    | Built-in playlist manager to organize `.json` song files.                    |
| **🎛️ Live Control**     | Adjust **Speed (10-500%)**, **Transpose**, and **Seek** in real-time.        |
| **🧠 Smart Logic**      | **Auto-Pause** on Alt-Tab, **Optimization Mode** for heavy songs.            |
| **🎹 Advanced Play**    | **Sustain** support and **Mono Mode** for cleaner melodies.                  |

## 🚀 Installation

1.  **Install AutoHotkey v2**: Download from [autohotkey.com](https://www.autohotkey.com/).
2.  **Download Script**: Clone this repo or download the source.
3.  **Setup Directory**: Ensure a `Songs` folder exists next to `script.ahk` (it creates one automatically).
4.  **Add Music**: Drop your `.json` song files into the `Songs` folder.

## 🎮 Usage Guide

1.  Run `script.ahk` (Right-click > Run Script).
2.  Select a track from the **Library** list.
3.  Choose the **Target Window** (your game window) from the dropdown.
4.  Press **Start** or **F4**.

> [!TIP]
> Use the `(Unlocked - Any Window)` option to test playback in a text editor like Notepad before playing in-game!

## 🎹 Controls & Hotkeys

### Keyboard Shortcuts

|  Key   | Action                  |
| :----: | :---------------------- |
| **F4** | Toggle **Play / Pause** |
| **F8** | **Stop** Playback       |

### Interface Controls

- **Seeking**: Drag the progress slider to jump to any point.
- **Speed**: Enter a percentage (e.g., `120` for 1.2x speed) or use Up/Down arrows.
- **Playlist**: Use ▲ / ▼ buttons to reorder songs.

## ⚙️ Configuration

Settings are auto-saved to `config.ini`:

- **Sustain**: Keeps keys pressed for the duration of the note.
- **No Chords**: Ignores lower-octave keys (z, x, c...) usually used for chords.
- **Mono Mode**: Plays only one note at a time (highest priority).
- **Max Polyphony**: Limits simultaneous scrypt key presses.

## 📁 Song Format

The script accepts specific JSON structure. Example:

<details>
<summary>Click to view JSON Example</summary>

```json
{
  "tracks": [
    {
      "instrument": { "family": "piano" },
      "notes": [
        {
          "time": 0.0,
          "duration": 0.5,
          "midi": 60
        }
      ]
    }
  ]
}
```

</details>

### How to Convert MIDI to JSON

Since this tool uses a specific JSON format, you can use the **Tone.js MIDI** tool to convert your `.mid` files:

1.  Go to [https://tonejs.github.io/Midi/](https://tonejs.github.io/Midi/).
2.  Drag and drop your MIDI file onto the page.
3.  Copy the generated JSON output.
4.  Paste it into a new file in the `Songs` folder (e.g., `mysong.json`).

> [!TIP]
> **Need MIDI files?** You can find high-quality MIDI sequences at [OnlineSequencer.net](https://onlinesequencer.net/sequences).

> [!IMPORTANT]
> **🎹 MIDI Selection Guide**
> The in-game instrument is limited to **21 diatonic keys** (3 octaves of white keys only) and **7 chord keys**.
>
> - **Melody Range**: C3 - B5 (White keys only).
> - **Chord Range**: C2 - B2.
> - **Tip**: For best results, choose songs with simple melodies (few sharps/flats) or transpose your MIDI to **C Major** or **A Minor** before converting.

## 📝 To-Do / Roadmap

- [ ] **Direct MIDI Support**: Add support for parsing `.mid` files directly without conversion to JSON.
- [ ] **Custom Keybinding**: Allow users to map MIDI notes to custom keys via UI.
- [ ] **Theme Support**: Dark mode and custom color schemes for the definition.
- [ ] **Visual Overlay**: A visual piano overlay to see which keys are being pressed.
- [ ] **Data Recorder**: Record in-game performance and save to JSON.
- [x] **Mini Mode**: Compact UI for better visibility.

## 🤝 Contributing

Contributions are always welcome! This project is new and open to improvements.
If you have any ideas, bug fixes, or new features (like better MIDI parsing!), please feel free to:

1.  **Fork** the repository.
2.  Create your feature branch.
3.  Commit your changes.
4.  Open a **Pull Request**.

---

## 📞 Contact & Support

If you have any questions or just want to hang out, reach out to me:

[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/w4pE2uHm)
[![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white)](https://www.facebook.com/carlyle.katto.1210)

---

<div align="center">
  <i>Created with ❤️ for the OverField Community</i>
</div>
