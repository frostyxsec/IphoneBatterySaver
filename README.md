# ⚡ Battery Tweak — IPhone Service Manager

> Script shell bash untuk mengoptimalkan baterai IPhone dengan menonaktifkan background service yang tidak diperlukan.

---

## 📋 Deskripsi

**Battery Tweak** adalah tool CLI berbasis Bash yang memudahkan kamu untuk mengaktifkan atau menonaktifkan background service IPhone yang tidak esensial — seperti Siri, Analytics, dan Assistant — guna menghemat daya baterai. Semua operasi dilakukan lewat menu interaktif dengan tampilan terminal yang bersih dan berwarna.

Respring/restart dilakukan **secara manual** oleh pengguna, sehingga kamu punya kendali penuh atas kapan perubahan diterapkan.

---

## 🖥️ Preview

```
  ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
  ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
  ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝
  ...

  ╔══════════════════════════════════════════════════════════╗
  ║  ⚡ IPhone Battery Optimizer — Service Manager v1.0       ║
  ║  Disable/Enable background services to save battery      ║
  ╚══════════════════════════════════════════════════════════╝

  MENU UTAMA
  ──────────────────────────────────────────────────────────
   [1]  🔴  OFF   — Disable semua service (hemat baterai)
   [2]  🟢  ON    — Enable semua service (kembalikan normal)
   [3]  🔍  STATUS — Cek status service saat ini
   [4]  ❌  KELUAR
```

---

## ✨ Fitur

| Fitur | Keterangan |
|---|---|
| 🔴 **OFF Mode** | Disable semua service sekaligus dengan satu perintah |
| 🟢 **ON Mode** | Enable kembali semua service ke kondisi normal |
| 🔍 **Status View** | Tampilkan status tiap service (ON/OFF) secara real-time |
| 🎨 **Colored UI** | Tampilan terminal berwarna dengan banner ASCII art |
| 🔒 **Root Check** | Otomatis mendeteksi jika script tidak dijalankan sebagai root |
| 🔁 **Manual Respring** | Tidak ada restart otomatis — pengguna mengontrol kapan reboot |

---

## 🛠️ Persyaratan

- IPhone (diuji di IPhone Ventura / Sonoma / Sequoia)
- Terminal dengan dukungan warna ANSI
- Akses `sudo` / root
- `launchctl` (sudah tersedia bawaan IPhone)

---

## 🚀 Instalasi & Penggunaan

### 1. Clone atau download script

```bash
# Simpan file x.sh di
/var/jb/var/root atau path root masing masing
```

### 2. Beri izin eksekusi

```bash
chmod +x x.sh
```

### 3. Jalankan dengan sudo

```bash
sudo bash x.sh / ./x.sh
```

### 4. Pilih menu

```
Pilih menu [1/2/3/4] →
```

- Ketik `1` lalu Enter → **Disable** semua service
- Ketik `2` lalu Enter → **Enable** semua service
- Ketik `3` lalu Enter → **Lihat status** tiap service
- Ketik `4` lalu Enter → **Keluar**

---

## ⚙️ Daftar Service yang Dikelola

| No. | Service ID | Label |
|---|---|---|
| 01 | `com.apple.siriinferenced` | Siri Inference |
| 02 | `com.apple.siriknowledged` | Siri Knowledge |
| 03 | `com.apple.wifianalyticsd` | WiFi Analytics |
| 04 | `com.apple.duetexpertd` | Duet Expert |
| 05 | `com.apple.coreduetd` | Core Duet |
| 06 | `com.apple.analyticsd` | Analytics |
| 07 | `com.apple.nanobackupd` | Nano Backup |
| 08 | `com.apple.tipsd` | Tips |
| 09 | `com.apple.assistantd` | Assistant |

---

## 🔧 Cara Kerja

### Mode OFF (Disable)

Setiap service dimatikan menggunakan dua perintah `launchctl`:

```bash
sudo launchctl bootout system/com.apple.siriinferenced
sudo launchctl disable system/com.apple.siriinferenced
```

- `bootout` → Menghentikan service yang sedang berjalan
- `disable` → Mencegah service berjalan kembali setelah reboot

### Mode ON (Enable)

Service dikembalikan menggunakan:

```bash
sudo launchctl enable system/com.apple.siriinferenced
sudo launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.siriinferenced.plist
```

- `enable` → Mengizinkan service berjalan kembali
- `bootstrap` → Menjalankan service dari plist-nya

---

## ⚠️ Catatan Penting

> **Respring / Restart Manual**
> Script ini **tidak melakukan restart otomatis**. Setelah menjalankan mode ON atau OFF, lakukan restart manual agar perubahan diterapkan secara penuh.

> **SIP (System Integrity Protection)**
> Beberapa service mungkin tidak dapat dinonaktifkan jika SIP aktif. Pastikan SIP dalam kondisi yang sesuai dengan kebutuhanmu sebelum menjalankan script ini.

> **Risiko**
> Menonaktifkan service seperti `assistantd` atau `siriinferenced` akan menonaktifkan fitur Siri. Gunakan mode ON untuk mengembalikan fungsionalitas tersebut kapan saja.

---

## 📂 Struktur Proyek

```
battery-tweak/
├── x.sh    # Script utama
└── README.md           # Dokumentasi ini
```

---

## 🔄 Changelog

### v1.0.0
- Rilis pertama
- Fitur OFF / ON / STATUS
- Banner ASCII art dengan warna ANSI
- Root check otomatis
- Manual respring (tidak ada auto-restart)

---

## 👤 Author

**Frosty**
- Script: `x.sh`
- Platform: IPhone / Linux
- Versi: 1.0.0

---

## 📄 Lisensi

Proyek ini bersifat open-source dan bebas digunakan untuk keperluan pribadi. Tidak ada garansi. Gunakan dengan risiko sendiri.

---

<div align="center">
  <sub>⚡ Dibuat dengan ❤️ untuk menghemat baterai IPhone</sub>
</div>
