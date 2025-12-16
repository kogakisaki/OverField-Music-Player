<div align="center">

# 🎹 OverField Music Player

**Trình Chơi Piano & Guitar Tự Động Cho "OverField"**

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
> **⚠️ Lưu Ý Phiên Bản Game**:
> **các đồ nội thất nhạc cụ** hiện tại **chỉ mới xuất hiện ở server Trung Quốc** của "OverField" (开放空间).
> Bạn có thể tải game tại đây: [Tải Game trên Bilibili](https://www.biligame.com/detail/?id=114015&spm_id_from=555.224.0.0&sourceFrom=1600820011)

---

## 📖 Mục Lục

- [Giới Thiệu](#-giới-thiệu)
- [Tính Năng Chính](#-tính-năng-chính)
- [Cài Đặt](#-cài-đặt)
- [Hướng Dẫn Sử Dụng](#-hướng-dẫn-sử-dụng)
- [Phím Tắt & Điều Khiển](#-phím-tắt--điều-khiển)
- [Cấu Hình](#-cấu-hình)
- [Định Dạng Nhạc](#-định-dạng-nhạc)

---

## 🌟 Giới Thiệu

**OverField Music Player** là công cụ tự động hóa giúp bạn trình diễn những bản nhạc phức tạp trong game _OverField_. Tool hỗ trợ hoàn hảo cho cả **Piano** và **Guitar Điện** (vì chúng có cùng layout phím). Được viết bằng **AutoHotkey v2**, tool đảm bảo độ chính xác mili-giây và cung cấp giao diện điều khiển chuyên nghiệp như một trình phát nhạc thực thụ.

> [!TIP] 
> **Thấy tool hữu ích?** Hãy ủng hộ tác giả bằng cách thả ⭐ **Star** trên GitHub nhé!

## ✨ Tính Năng Chính

| Tính Năng              | Mô Tả                                                                            |
| :--------------------- | :------------------------------------------------------------------------------- |
| **🎯 Timing Chuẩn**    | Dùng thuật toán hybird wait loop và `timeBeginPeriod(1)` để gõ phím cực chuẩn.   |
| **📂 Thư Viện Nhạc**   | Quản lý, sắp xếp và load file nhạc `.json` ngay trong tool.                      |
| **🎛️ Chỉnh Real-time** | Chỉnh **Tốc độ (10-500%)**, **Transpose (Tông)**, và **Tua nhạc** khi đang chơi. |
| **🧠 Thông Minh**      | **Tự Động Pause** khi Alt-Tab ra ngoài, **Chế Độ Tối Ưu** cho bài nhạc nặng.     |
| **🎹 Chế Độ Cao Cấp**  | Hỗ trợ **Sustain** (giữ phím) và **Mono Mode** (đơn âm).                         |

## 🚀 Cài Đặt

1.  **Cài AutoHotkey v2**: Tải tại [autohotkey.com](https://www.autohotkey.com/).
2.  **Tải Script**: Clone repo này hoặc tải file `script.ahk` về.
3.  **Chuẩn Bị Thư Mục**: Tạo thư mục `Songs` cùng chỗ với `script.ahk` (nếu chưa có).
4.  **Thêm Nhạc**: Thêm các file nhạc đã convert (`.json`) vào thư mục `Songs`.

## 🎮 Hướng Dẫn Sử Dụng

1.  Chạy file `script.ahk` (Chuột phải > Run Script).
2.  Chọn bài hát từ danh sách **Library**.
3.  Chọn **Cửa Sổ Game** từ danh sách thả xuống.
4.  Nhấn **Start** hoặc phím **F4**.

> [!TIP]
> Hãy chọn chế độ `(Unlocked - Any Window)` để test nhạc trên Notepad trước khi vào game để tránh lỗi thao tác!

## 🎹 Phím Tắt & Điều Khiển

### Phím Tắt

|     Phím     | Chức năng                          |
| :----------: | :--------------------------------- |
|    **F4**    | **Play / Pause** (Phát / Tạm dừng) |
|    **F8**    | **Stop** (Dừng hẳn)                |
| **Ctrl + →** | **Next** (Bài kế tiếp)             |
| **Ctrl + ←** | **Previous** (Bài trước)           |

### Giao Diện

- **Thanh Tiến Trình**: Kéo chuột để tua đến đoạn nhạc mong muốn.
- **Tốc Độ**: Nhập % tốc độ hoặc dùng nút Lên/Xuống (Mặc định 100%).
- **Playlist**: Dùng nút ▲ / ▼ để sắp xếp bài hát.
- **Điều hướng**: Dùng nút **Next** / **Prev** để chuyển bài.

## ⚙️ Cấu Hình

Cài đặt được lưu tự động vào `config.ini`:

- **Sustain**: Giữ phím nhấn xuống theo độ dài nốt nhạc.
- **No Chords**: Bỏ qua các nốt trầm (hàng phím z, x, c...).
- **Mono Mode**: Chỉ chơi 1 nốt tại một thời điểm (ưu tiên nốt cao/mới nhất).
- **Max Polyphony**: Giới hạn số phím nhấn cùng lúc (tránh anti-cheat hoặc mất nốt).

## 📁 Định Dạng Nhạc

Tool làm việc với file JSON có cấu trúc sau:

<details>
<summary>Xem ví dụ JSON</summary>

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

### Cách Chuyển MIDI sang JSON

Tool này sử dụng định dạng JSON đặc biệt, bạn có thể dùng công cụ **Tone.js MIDI** để convert file `.mid`:

1.  Truy cập trang [https://tonejs.github.io/Midi/](https://tonejs.github.io/Midi/).
2.  Kéo thả file MIDI của bạn vào trang web.
3.  Copy đoạn mã JSON được tạo ra.
4.  Paste vào một file mới trong thư mục `Songs` (ví dụ: `baihat.json`).

> [!TIP] 
> **Tìm nhạc MIDI?** Bạn có thể tìm thấy các bản MIDI chất lượng tại [OnlineSequencer.net](https://onlinesequencer.net/sequences).

> [!IMPORTANT] 
> **🎹 Lưu Ý Khi Chọn MIDI**
> Đàn trong game được thiết kế giới hạn với **21 phím giai điệu** (3 quãng tám phím trắng) và **7 phím hợp âm**.
>
> - **Phạm vi giai điệu**: C3 - B5 (Chỉ phím trắng).
> - **Phạm vi hợp âm**: C2 - B2.
> - **Mẹo**: Để có trải nghiệm tốt nhất, hãy chọn các bài hát có giai điệu đơn giản (ít nốt thăng/gián) hoặc transpose file MIDI về giọng **Đô trưởng (C Major)** hoặc **La thứ (A Minor)** trước khi convert.

## 📝 To-Do / Kế Hoạch Phát Triển

- [ ] **Hỗ trợ file MIDI**: Đọc trực tiếp file `.mid` mà không cần convert sang JSON.
- [ ] **Tùy chỉnh phím**: Cho phép người dùng tự map nốt MIDI sang phím bất kỳ trên giao diện.
- [ ] **Giao diện Theme**: Thêm Dark mode và tùy chỉnh màu sắc.
- [ ] **Hiển thị trực quan**: Thêm overlay bàn phím ảo để nhìn thấy nốt đang gõ.
- [ ] **Ghi âm Macro**: Ghi lại màn biểu diễn trong game và lưu ra file.
- [x] **Chế độ Mini**: Giao diện nhỏ gọn để dễ nhìn hơn.

## 🤝 Đóng Góp

Mọi sự đóng góp đều được hoan nghênh! Dự án này còn rất mới và đang cần nhiều sự cải tiến từ cộng đồng.
Nếu bạn có ý tưởng, sửa lỗi, hoặc tính năng mới (ví dụ như thuật toán đọc MIDI xịn hơn!), đừng ngần ngại:

1.  **Fork** kho lưu trữ này.
2.  Tạo nhánh tính năng (feature branch) của bạn.
3.  Commit các thay đổi.
4.  Mở một **Pull Request** (PR).

---

## 📞 Liên Hệ & Hỗ Trợ

Nếu bạn có câu hỏi hoặc muốn giao lưu, hãy liên hệ với mình qua:

[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/w4pE2uHm)
[![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white)](https://www.facebook.com/carlyle.katto.1210)

---

<div align="center">
  <i>Created with ❤️ for the OverField Community</i>
</div>
