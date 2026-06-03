# Dokumentasi Pengujian Sistem: Zona Pangan

## 1. Alur Utama Sistem (User Journey)
- **Registrasi:** Manager daftar akun & perusahaan -> Operator daftar (hanya jika perusahaan terdaftar).
- **Autentikasi:** Login (Dashboard) atau Forgot Password (via Verifikasi Email & Token).
- **Scan & Simpan:** Home Operator -> Smart Scanner (Galeri/Kamera) -> Result & Action -> Simpan ke Database.
- **Monitoring (Manager):** Dashboard Overview (Grafik) -> Inventory (Status Ready/Kompos) -> History (Data lengkap & Export).

## 2. Tabel Skenario Pengujian (Updated)

| ID | Modul | Deskripsi Skenario | Hasil yang Diharapkan |
| :--- | :--- | :--- | :--- |
| **TC-01** | Registrasi | Operator daftar tanpa kode perusahaan | Sistem menolak registrasi |
| **TC-02** | Forgot Pass | Verifikasi email & pengiriman token | Email terkirim & token aktif |
| **TC-03** | Reset Pass | Input token valid untuk ganti password | Password berhasil diubah |
| **TC-04** | Smart Scanner | Scan dengan galeri atau kamera | Sistem berhasil mendeteksi objek |
| **TC-05** | Save Data | Data hasil scan disimpan | Data masuk ke tabel Inventory Manager |
| **TC-06** | Dashboard | Overview menampilkan grafik & info | Grafik terupdate secara real-time |
| **TC-07** | Inventory | Status "Ready" (Segar) & "Kompos" (Busuk) | Label status muncul sesuai hasil deteksi |
| **TC-08** | History | Melihat data lengkap & simpan data | Data histori tertampil & bisa diunduh |

---

### 3. Visualisasi Alur Data (Logic Flow)

```mermaid
graph TD
    subgraph Registrasi
    M[Manager] -->|Daftar Perusahaan| DB[(Database)]
    O[Operator] -->|Daftar via Kode| DB
    end

    subgraph Scanner
    O -->|Input Foto/Camera| AI[Smart Scanner AI]
    AI -->|Deteksi| R[Hasil: Ready/Kompos]
    R -->|Simpan| DB
    end

    subgraph Monitoring
    M -->|Lihat| Dash[Dashboard Overview]
    M -->|Lihat| Inv[Inventory & History]
    end