<div align="center">

# 🎹 OverField Music Player

**Pemutar Piano & Gitar Otomatis untuk "OverField"**

[![AutoHotkey v2](https://img.shields.io/badge/Language-AutoHotkey_v2-green?style=for-the-badge&logo=autohotkey)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)](../LICENSE)

<br>

[ **🇺🇸 English** ](../README.md) &nbsp;|&nbsp; [ **🇻🇳 Tiếng Việt** ](README_vi.md) &nbsp;|&nbsp; [ **🇨🇳 简体中文** ](README_zh.md) &nbsp;|&nbsp; [ **🇯🇵 日本語** ](README_ja.md) &nbsp;|&nbsp; [ **🇮🇩 Bahasa Indonesia** ](README_id.md)

<br>

<br>

![OverField Music Player Demo](img/demo.png)

</div>

> [!NOTE] 
> **⚠️ Pemberitahuan Versi Game**
> Fitur **furnitur instrumen** saat ini **hanya tersedia di server China** dari "OverField" (开放空间).
> Anda dapat mengunduhnya di sini: [Unduh Game Bilibili](https://www.biligame.com/detail/?id=114015&spm_id_from=555.224.0.0&sourceFrom=1600820011)

---

## 📖 Daftar Isi

- [Pengantar](#-pengantar)
- [Fitur Utama](#-fitur-utama)
- [Instalasi](#-instalasi)
- [Panduan Penggunaan](#-panduan-penggunaan)
- [Kontrol & Hotkey](#-kontrol--hotkey)
- [Konfigurasi](#-konfigurasi)
- [Format Lagu](#-format-lagu)
- [Kontribusi](#-kontribusi)

---

## 🌟 Pengantar

**OverField Music Player** adalah skrip otomatisasi presisi tinggi yang dirancang untuk memainkan aransemen musik yang kompleks dalam game _OverField_. Alat ini sepenuhnya mendukung **Piano** dan **Gitar Listrik** (karena memiliki tata letak tombol yang sama). Dibuat dengan **AutoHotkey v2**, alat ini menjembatani komposisi MIDI dengan kinerja dalam game, menawarkan waktu akurat hingga milidetik dan kontrol real-time.

> [!TIP] > **Suka dengan alat ini?** Mohon pertimbangkan untuk memberikan ⭐ **Bintang** di GitHub untuk mendukung pengembangan!

## ✨ Fitur Utama

| Fitur                      | Deskripsi                                                                                 |
| :------------------------- | :---------------------------------------------------------------------------------------- |
| **🎯 Waktu Presisi**       | Menggunakan `timeBeginPeriod(1)` dan loop tunggu hibrida untuk eksekusi nada yang akurat. |
| **📂 Pustaka Musik**       | Manajer daftar putar bawaan untuk mengatur file lagu `.json`.                             |
| **🎛️ Kontrol Langsung**    | Sesuaikan **Kecepatan (10-500%)**, **Transpose**, dan **Seek** secara real-time.          |
| **🧠 Logika Cerdas**       | **Jeda Otomatis** saat Alt-Tab, **Mode Optimasi** untuk lagu berat.                       |
| **🎹 Main Tingkat Lanjut** | Dukungan **Sustain** dan **Mode Mono** untuk melodi yang lebih bersih.                    |

## 🚀 Instalasi

1.  **Instal AutoHotkey v2**: Unduh dari [autohotkey.com](https://www.autohotkey.com/).
2.  **Unduh Skrip**: Clone repo ini atau unduh kode sumbernya.
3.  **Siapkan Direktori**: Pastikan folder `Songs` ada di sebelah `script.ahk` (akan dibuat otomatis jika tidak ada).
4.  **Tambah Musik**: Masukkan file lagu `.json` Anda ke dalam folder `Songs`.

## 🎮 Panduan Penggunaan

1.  Jalankan `script.ahk` (Klik kanan > Run Script).
2.  Pilih lagu dari daftar **Library**.
3.  Pilih **Target Window** (jendela game Anda) dari dropdown.
4.  Tekan **Start** atau **F4**.

> [!TIP]
> Gunakan opsi `(Unlocked - Any Window)` untuk menguji pemutaran di text editor seperti Notepad sebelum memainkannya di dalam game!

## 🎹 Kontrol & Hotkey

### Pintasan Keyboard

| Tombol | Aksi                    |
| :----: | :---------------------- |
| **F4** | Beralih **Main / Jeda** |
| **F8** | **Berhenti** Putar      |

### Kontrol Antarmuka

- **Seek**: Tarik slider progres untuk lompat ke titik mana pun.
- **Kecepatan**: Masukkan persentase (misal, `120` untuk kecepatan 1.2x) atau gunakan panah Atas/Bawah.
- **Daftar Putar**: Gunakan tombol ▲ / ▼ untuk mengubah urutan lagu.

## ⚙️ Konfigurasi

Pengaturan disimpan secara otomatis ke `config.ini`:

- **Sustain**: Menahan tombol selama durasi nada.
- **No Chords**: Mengabaikan tombol oktaf rendah (z, x, c...) yang biasanya digunakan untuk chord.
- **Mono Mode**: Hanya memainkan satu nada pada satu waktu (prioritas tertinggi).
- **Max Polyphony**: Membatasi penekanan tombol simultan (menghindari anti-spam game).

## 📁 Format Lagu

Skrip menerima struktur JSON tertentu. Contoh:

<details>
<summary>Klik untuk melihat Contoh JSON</summary>

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

### Cara Mengonversi MIDI ke JSON

Karena alat ini menggunakan format JSON tertentu, Anda dapat menggunakan alat **Tone.js MIDI** untuk mengonversi file `.mid` Anda:

1.  Buka [https://tonejs.github.io/Midi/](https://tonejs.github.io/Midi/).
2.  Seret dan lepas (drag and drop) file MIDI Anda ke halaman tersebut.
3.  Salin output JSON yang dihasilkan.
4.  Tempelkan ke dalam file baru di folder `Songs` (misalnya, `lagusaya.json`).

> [!TIP] 
> **Butuh file MIDI?** Anda dapat menemukan urutan MIDI berkualitas tinggi di [OnlineSequencer.net](https://onlinesequencer.net/sequences).

> [!IMPORTANT] 
> **🎹 Panduan Pemilihan MIDI**
> Instrumen dalam game terbatas pada **21 tombol diatonis** (3 oktaf tuts putih) dan **7 tombol chord**.
>
> - **Rentang Melodi**: C3 - B5 (Hanya tuts putih).
> - **Rentang Chord**: C2 - B2.
> - **Tips**: Untuk hasil terbaik, pilih lagu dengan melodi sederhana (sedikit nada kres/mol) atau transpose MIDI Anda ke **C Major** atau **A Minor** sebelum mengonversi.

## 📝 To-Do / Roadmap

- [ ] **Dukungan MIDI Langsung**: Menambahkan dukungan untuk mem-parsing file `.mid` secara langsung.
- [ ] **Keybinding Kustom**: Mengizinkan pengguna memetakan nada MIDI ke tombol kustom via UI.
- [ ] **Dukungan Tema**: Mode gelap dan skema warna kustom.
- [ ] **Overlay Visual**: Overlay piano visual untuk melihat tombol mana yang ditekan.
- [ ] **Perekam Makro**: Merekam kinerja dalam game dan menyimpannya ke JSON.

## 🤝 Kontribusi

Kontribusi selalu diterima! Proyek ini baru dan terbuka untuk perbaikan.
Jika Anda memiliki ide, perbaikan bug, atau fitur baru, silakan:

1.  **Fork** repositori ini.
2.  Buat feature branch Anda.
3.  Commit perubahan Anda.
4.  Buka **Pull Request**.

---

## 📞 Kontak & Dukungan

Jika Anda memiliki pertanyaan atau hanya ingin mengobrol, hubungi saya di:

[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/w4pE2uHm)
[![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white)](https://www.facebook.com/carlyle.katto.1210)

---

<div align="center">
  <i>Created with ❤️ for the OverField Community</i>
</div>
