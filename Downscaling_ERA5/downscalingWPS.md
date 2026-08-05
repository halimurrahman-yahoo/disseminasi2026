

---

## A. Downscaling Data ERA5 Menggunakan WPS hingga tahap Metgrid (Resolusi Domain 25m)

### Durasi 4 jam

---

# Sesi 1. Pengantar Downscaling dan WPS

**Durasi:** 45 menit

## Tujuan

Memahami konsep downscaling dan alur kerja WRF-WPS.

### Materi

* Konsep Numerical Weather Prediction (NWP)
* Perbedaan:

  * Global Model
  * Regional Model
* Apa itu Downscaling

  * Dynamical Downscaling
  * Statistical Downscaling
* Mengenal ERA5

  * Resolusi
  * Variabel
  * Interval waktu
* Workflow WRF

```
ERA5
   │
Ungrib
   │
Metgrid
   │
Real.exe
   │
WRF.exe
```

---

# Sesi 2. Persiapan Data

**Durasi:** 45 menit

### Materi

Struktur direktori project

```
project/

├── WPS/
├── WRF/
├── ERA5/
├── GEOG/
└── output/
```

Data yang diperlukan

* ERA5 Pressure Level
* ERA5 Surface Level
* Static Geography

Pengenalan format

* GRIB
* NetCDF
* Binary Geography

---

# [Sesi 3. Menentukan Domain Resolusi 250 m](https://jiririchter.github.io/WRFDomainWizard/)

Bahan: [namelist.wps] (namelist.md))

**Durasi:** 90 menit

## Materi

### Menentukan lokasi simulasi

* koordinat pusat domain
* luas area

### Menentukan jumlah grid

Contoh

Resolusi

```
dx = 250 m
dy = 250 m
```

Ukuran domain

```
30 km × 30 km
```

Jumlah grid

```
30000 / 250 = 120

e_we = 121
e_sn = 121
```

### Parent-child domain

Contoh nesting

| Domain | Resolusi |
| ------ | -------- |
| d01    | 9 km     |
| d02    | 3 km     |
| d03    | 1 km     |
| d04    | 250 m    |

### Editing namelist.wps

Parameter penting

* max_dom
* dx
* dy
* map_proj
* ref_lat
* ref_lon
* truelat1
* truelat2
* stand_lon

Penjelasan rasio nesting

```
9 km
 ↓
3 km
 ↓
1 km
 ↓
250 m
```

---

# Sesi 4. Geogrid

**Durasi:** 60 menit

## Materi

Fungsi Geogrid

Data geografi

* Terrain
* Landuse
* Soil
* Green Fraction

Menjalankan

```
geogrid.exe
```

Output

```
geo_em.d01.nc
geo_em.d02.nc
...
```

Visualisasi domain

* ncview
* Panoply
* QGIS

Pengecekan

* posisi domain
* resolusi
* topografi

---

# Sesi 5. Menyiapkan Data ERA5

**Durasi:** 60 menit

## Materi

Jenis data ERA5

* Surface
* Pressure Level

Mengunduh data

* CDS API
* Copernicus

Struktur file

```
ERA5/

2024010100.grib
2024010106.grib
...
```

Linking data

```
link_grib.csh
```

Pengenalan

```
Vtable
```

Pemilihan

```
Vtable.ERA-interim
atau
Vtable.ERA5
```

---

# Sesi 6. Ungrib

**Durasi:** 45 menit

## Materi

Fungsi Ungrib

Proses

```
GRIB

↓

Intermediate Format
```

Menjalankan

```
ungrib.exe
```

Output

```
FILE:2024-01-01_00
FILE:2024-01-01_06
...
```

Pengecekan log

```
ungrib.log
```

Error umum

* Vtable salah
* Data tidak lengkap
* Time mismatch

---

# Sesi 7. Metgrid

**Durasi:** 60 menit

## Materi

Konsep interpolasi

```
ERA5

↓

Interpolasi

↓

Grid WRF
```

Editing

```
METGRID.TBL
```

Menjalankan

```
metgrid.exe
```

Output

```
met_em.d01.*
met_em.d02.*
met_em.d03.*
met_em.d04.*
```

Verifikasi

* jumlah file
* waktu
* ukuran file
* variabel tersedia

---

# Sesi 8. Validasi Output Metgrid

**Durasi:** 45 menit

## Materi

Membuka file

```
met_em*.nc
```

Menggunakan

* ncview
* Panoply
* Python
* NCL

Pemeriksaan

* Terrain
* Temperature
* Pressure
* RH
* Wind
* Soil Variable



# Praktikum

Lakukan langkah berikut:

1. Menyiapkan direktori kerja.
2. Mengatur `namelist.wps` untuk domain hingga resolusi 250 m.
3. Menjalankan `geogrid.exe`.
4. Mengunduh dan menyiapkan data ERA5.
5. Menjalankan `link_grib.csh`.
6. Memilih `Vtable` yang sesuai.
7. Menjalankan `ungrib.exe`.
8. Menjalankan `metgrid.exe`.
9. Memeriksa file `met_em.d0*.YYYY-MM-DD_HH:00:00.nc`.

---

# Output Akhir

Pada akhir pelatihan, peserta diharapkan mampu:

* Memahami alur kerja WPS untuk downscaling ERA5.
* Mendesain domain bertingkat hingga resolusi **250 m** secara tepat.
* Menyiapkan dan memvalidasi data ERA5 sebagai masukan WRF.
* Menjalankan **Geogrid**, **Ungrib**, dan **Metgrid** tanpa kesalahan.
* Menghasilkan file **`met_em.d0*.nc`** yang siap digunakan pada tahap berikutnya (`real.exe` dan `wrf.exe`).
