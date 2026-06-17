# Design System Lazuardy

Berkas ini adalah panduan dasar (*Single Source of Truth*) untuk desain aplikasi Lazuardy Mobile. Semua *developer* harus mematuhi panduan ini saat membuat atau memodifikasi *widget*.

## 1. Color Palette

Seluruh warna diambil dari `lib/core/theme/app_theme.dart` (`AppColors`).

| Nama | Hex Code | Penggunaan Utama |
|---|---|---|
| **Primary** | `#2C8AA4` | Warna utama (Teal). Digunakan pada *icon*, *checkbox*, tulisan sorotan, dan *border* khusus. |
| **Primary Dark** | `#2D8B85` | State *hover* atau *pressed* dari elemen berwarna Primary. |
| **Secondary** | `#27346A` | Warna aksen gelap (Dark Blue). Digunakan untuk **Primary Button** (misal: Beli Paket). |
| **Background White** | `#FFFFFF` | Latar belakang *scaffold* utama dan *card*. |
| **Background Teal** | `#32868A` | Latar belakang berwarna hijau kebiruan gelap (digunakan pada Dashboard/Tarik Saldo). |
| **Text Primary** | `#1A1A2E` | Teks utama (*heading* dan *body text*). |
| **Text Secondary** | `#6B7280` | Teks sekunder (*caption*, *hint*, keterangan tambahan). |
| **Text White** | `#FFFFFF` | Teks di atas *background* berwarna gelap (Teal atau Secondary). |
| **Border Color** | `#E5E7EB` | Warna garis batas (*border*) untuk *Card* atau *Input Field*. |

---

## 2. Typography

Semua *text style* tersedia di `lib/core/theme/app_theme.dart` (`AppTextStyles`). Kita menggunakan *font* **Poppins**.

- **heading1** (26px, Bold) - Judul halaman utama.
- **heading2** (20px, Bold) - Sub-judul halaman / *App Bar*.
- **heading3** (16px, Bold) - Judul dalam *Card* atau grup menu.
- **subtitle** (15px, Semi-Bold) - Penamaan dengan hierarki sedang.
- **body** (14px, Normal) - Teks paragraf standar.
- **label** (14px, Semi-Bold) - Teks tombol, *tab*, atau label input.
- **caption** (12px, Normal) - Keterangan kecil, status bawah, *helper text*.

> [!TIP]
> Daripada menuliskan `TextStyle(color: ...)` secara berulang, biasakan menggunakan `AppTextStyles.body` dan kombinasikan dengan `.copyWith(color: ...)` bila perlu.

---

## 3. Komponen Standar

### Cards
Secara default, menggunakan `CardTheme` dari Material UI:
- Latar Belakang: `bgWhite`
- Border Radius: `16px`
- Border: `1px solid AppColors.borderColor`
- Elevation: `0` (Tidak ada *shadow* bawaan Material, gunakan `BoxShadow` khusus jika diminta desain).

### Buttons
**Primary Button** menggunakan `ElevatedButton`:
- Latar Belakang: `AppColors.secondary` (`#27346A`)
- Border Radius: `12px`
- Teks: `14px Semi-Bold White`

> [!NOTE]
> Jika butuh tombol dengan warna *Teal*, silakan *override* menggunakan `ElevatedButton.styleFrom(backgroundColor: AppColors.primary)`.

### Input Fields
Untuk *TextField*, gunakan dekorasi bawaan dari `AppTheme.inputDecoration()`:
- Border Radius: `30px` (sangat melengkung/pil)
- Latar Belakang: `bgWhite`
- *Focused Border*: `1.5px AppColors.primary`

---

## 4. Ikonografi & Aset

Selalu panggil aset gambar dari `AppAssets` (`lib/core/constants/app_assets.dart`), **jangan ketik manual _string path_-nya**.

- **Logo**: `logoFull`, `logoHorizontal`, `logoIcon`.
- **Ilustrasi Menu**:
  - `AppAssets.iconBooking`
  - `AppAssets.iconRiwayatSesi`
  - `AppAssets.iconRiwayatUlasan`
  - `AppAssets.iconRiwayatPembayaran`
