<div align="center">

# 🎹 OverField Music Player (OverField 自動演奏ツール)

**「OverField」向けの高精度自動ピアノ・ギター演奏スクリプト**

[![AutoHotkey v2](https://img.shields.io/badge/Language-AutoHotkey_v2-green?style=for-the-badge&logo=autohotkey)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)](../LICENSE)

<br>

[ **🇺🇸 English** ](../README.md) &nbsp;|&nbsp; [ **🇻🇳 Tiếng Việt** ](README_vi.md) &nbsp;|&nbsp; [ **🇨🇳 简体中文** ](README_zh.md) &nbsp;|&nbsp; [ **🇯🇵 日本語** ](README_ja.md) &nbsp;|&nbsp; [ **🇮🇩 Bahasa Indonesia** ](README_id.md)

<br>

<br>

![OverField Music Player Demo](img/demo.png)

</div>

> [!NOTE] > **⚠️ ゲームバージョンに関する注意** > **楽器家具**演奏機能は現在、「OverField」(开放空间) の**中国サーバーでのみ利用可能**です。
> ダウンロードはこちら: [Bilibili ゲーム詳細](https://www.biligame.com/detail/?id=114015&spm_id_from=555.224.0.0&sourceFrom=1600820011)

---

## 📖 目次

- [はじめに](#-はじめに)
- [主な機能](#-主な機能)
- [インストール](#-インストール)
- [使い方](#-使い方)
- [操作方法](#-操作方法)
- [設定](#-設定)
- [楽曲フォーマット](#-楽曲フォーマット)
- [貢献について](#-貢献について)

---

## 🌟 はじめに

**OverField Music Player**は、ゲーム*OverField*内で複雑な楽曲を演奏するために設計された高精度な自動化スクリプトです。**ピアノ**と**エレキギター**（キー配置が同じため）の両方を完全にサポートしています。**AutoHotkey v2**で構築されており、MIDI 楽曲とゲーム内パフォーマンスの橋渡しを行い、ミリ秒単位の正確なタイミングとリアルタイムな制御を提供します。

> [!TIP] > **気に入りましたか？** 開発をサポートするために、GitHub で ⭐ **Star** をつけていただけると嬉しいです！

## ✨ 主な機能

| 機能                    | 説明                                                                                 |
| :---------------------- | :----------------------------------------------------------------------------------- |
| **🎯 精密なタイミング** | `timeBeginPeriod(1)`と独自の待機ループを使用し、正確な演奏を実現します。             |
| **📂 ライブラリ管理**   | 内蔵プレイリストで、`.json`形式の楽曲ファイルを整理・管理できます。                  |
| **🎛️ リアルタイム操作** | 演奏中に**速度 (10-500%)**、**移調 (Transpose)**、**シーク**を調整可能。             |
| **🧠 スマート機能**     | **自動一時停止**：ウィンドウ切り替え時に停止。**最適化モード**：重い曲のラグを防止。 |
| **🎹 高度な演奏**       | **サステイン (Sustain)** 対応。**モノラルモード**でメロディをクリアに。              |

## 🚀 インストール

1.  **AutoHotkey v2 のインストール**: [autohotkey.com](https://www.autohotkey.com/) からダウンロードしてインストールしてください。
2.  **スクリプトのダウンロード**: このリポジトリをクローンするか、ソースコードをダウンロードします。
3.  **フォルダの準備**: `script.ahk`と同じ場所に`Songs`フォルダがあることを確認してください（なければ自動作成されます）。
4.  **楽曲の追加**: 変換済みの`.json`楽曲ファイルを`Songs`フォルダに入れます。

## 🎮 使い方

1.  `script.ahk`を右クリックして **Run Script** を選択します。
2.  左側の **Library** リストから曲を選択します。
3.  ドロップダウンから **Target Window (対象ウィンドウ)** を選択します。
4.  **Start** ボタンを押すか、**F4** キーで演奏を開始します。

> [!TIP]
> 最初に `(Unlocked - Any Window)` を選択し、メモ帳などでテストすることをお勧めします。

## 🎹 操作方法

### ショートカットキー

|  キー  | 動作                |
| :----: | :------------------ |
| **F4** | **再生 / 一時停止** |
| **F8** | **完全停止**        |

### インターフェース操作

- **シーク**: スライダーをドラッグして曲の好きな位置へジャンプ。
- **速度**: 数値を入力（例: `120` = 1.2 倍速）または矢印キーで調整。
- **プレイリスト**: ▲ / ▼ ボタンで曲順を並べ替え。

## ⚙️ 設定

設定は自動的に `config.ini` に保存されます：

- **Sustain**: 音符の長さに応じてキーを押し続けます。
- **No Chords**: 低音域の和音キー（z, x, c...）を無視します。
- **Mono Mode**: 同時に 1 つの音だけを演奏します（高音優先）。
- **Max Polyphony**: 同時押しキー数を制限し、入力抜けを防ぎます。

## 📁 楽曲フォーマット

このスクリプトは、以下の JSON 構造を読み込みます：

<details>
<summary>JSONの例を見る</summary>

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

### MIDI を JSON に変換する方法

このツールは特定の JSON フォーマットを使用するため、**Tone.js MIDI** ツールを使用して `.mid` ファイルを変換できます：

1.  [https://tonejs.github.io/Midi/](https://tonejs.github.io/Midi/) にアクセスします。
2.  MIDI ファイルをページにドラッグ＆ドロップします。
3.  生成された JSON 出力をコピーします。
4.  `Songs` フォルダ内の新しいファイルに貼り付けます（例：`mysong.json`）。

> [!TIP] > **MIDI ファイルをお探しですか？** [OnlineSequencer.net](https://onlinesequencer.net/sequences) で高品質な MIDI シーケンスを見つけることができます。

> [!IMPORTANT] > **🎹 MIDI 選択ガイド**
> ゲーム内の楽器は、**21 個の全音階キー**（白鍵 3 オクターブ分）と**7 個のコードキー**に制限されています。
>
> - **メロディ範囲**: C3 - B5（白鍵のみ）。
> - **コード範囲**: C2 - B2。
> - **ヒント**: 最良の結果を得るには、メロディがシンプルな曲（シャープやフラットが少ない曲）を選ぶか、MIDI を **ハ長調 (C Major)** または **イ短調 (A Minor)** に移調してから変換することをお勧めします。

## 📝 今後の予定 / ロードマップ

- [ ] **MIDI 直接対応**: JSON 変換なしで `.mid` ファイルを直接読み込む機能。
- [ ] **キー配置のカスタム**: UI 上で MIDI ノートとキーの対応付けを変更可能にする。
- [ ] **テーマ対応**: ダークモードや配色のカスタマイズ。
- [ ] **ビジュアルオーバーレイ**: 押されているキーを画面上に表示。
- [ ] **マクロ録音**: ゲーム内の演奏を記録してファイルに保存。

## 🤝 貢献について

貢献はいつでも大歓迎です！新しいアイデア、バグ修正、機能追加（より良い MIDI 解析など！）があれば、お気軽にどうぞ：

1.  このリポジトリを **Fork** します。
2.  機能ブランチ (Feature branch) を作成します。
3.  変更をコミットします。
4.  **Pull Request** を送信します。

---

## 📞 お問い合わせ・サポート

ご質問や交流をご希望の方は、以下までご連絡ください：

[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/w4pE2uHm)
[![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white)](https://www.facebook.com/carlyle.katto.1210)

---

<div align="center">
  <i>Created with ❤️ for the OverField Community</i>
</div>
