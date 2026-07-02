Secara umum, alur kerja **WRF-Hydro** terdiri dari tiga bagian besar:


1. **Pre-processing** (menyiapkan seluruh input)
2. **Simulation** (menjalankan WRF dan WRF-Hydro)
3. **Post-processing** (mengolah output menjadi informasi hidrologi)

**WRF-Hydro bukan model yang berdiri sendiri**. Ia menggunakan output atmosfer dari **WRF** sebagai forcing hidrologi. Karena itu, seluruh rantai pekerjaan dimulai dari WRF.

---

# Tahap 1. Pre-processing WRF

Tujuannya menghasilkan input atmosfer yang siap digunakan WRF.

```
Data Global
     │
     ▼
 geogrid.exe
     │
     ▼
 ungrib.exe
     │
     ▼
 metgrid.exe
     │
     ▼
 met_em*
```

## Input

### a. Geographical Data

Berisi

* topografi
* landuse
* soil type
* vegetation
* albedo
* green fraction

Output digunakan oleh

```
geogrid.exe
```

Output

```
geo_em.d01.nc
geo_em.d02.nc
...
```

---

### b. Meteorological Data

Misalnya

* ERA5
* GFS
* FNL

diproses melalui

```
ungrib.exe
```

Output

```
FILE:YYYY-MM-DD_HH
```

---

### c. Metgrid

Menginterpolasi data meteorologi ke grid WRF.

Output

```
met_em.d01.*
met_em.d02.*
```

---

# Tahap 2. Real.exe

Menghasilkan kondisi awal dan batas WRF.

Input

```
geo_em
+
met_em
```

Output utama

```
wrfinput_d01
wrfinput_d02

wrfbdy_d01
```

Pada tahap ini kondisi atmosfer awal sudah siap.

---

# Tahap 3. Menyiapkan Input WRF-Hydro

Ini adalah tahap tambahan yang tidak ada pada WRF biasa.

Input utama

```
DEM resolusi tinggi
```

misalnya

* SRTM 30 m
* MERIT DEM
* LiDAR

Kemudian dijalankan

```
WRF-Hydro GIS Preprocessing
```

yang menghasilkan berbagai parameter hidrologi.

---

## Output GIS preprocessing

Berupa:

### a. Routing grid

```
Fulldom_hires.nc
```

isi

* elevation
* flow direction
* channel mask
* stream order
* channel length

---

### b. Route_Link.nc

Berisi

* setiap sungai
* hubungan antar sungai

---

### c. GWBUCKPARM.nc

Parameter groundwater

---

### d. LAKEPARM.nc

Tahap awal tanpa LAKE, selnjutnya ya.

---

### e. soil_properties.nc

Tahap awal tanpa LAKE, selnjutnya ya, jika diperlukan.

---

### f. nudging files

Jika menggunakan data observasi debit.

---

# Tahap 4. Menyiapkan Namelist

WRF

```
namelist.input
```

WRF-Hydro

```
hydro.namelist
```

Biasanya juga ada

```
nudgingParams.nc
```

jika memakai data observasi.

---

# Tahap 5. Menjalankan WRF

```
real.exe

wrf.exe
```

Output WRF

```
wrfout_d01*
wrfout_d02*
```

Namun ketika coupled dengan WRF-Hydro, output atmosfer juga dikirim setiap timestep ke komponen hidrologi.

Variabel forcing misalnya

```
RAINRATE
T2
Q2
PSFC
SWDOWN
LWDOWN
U10
V10
```

---

# Tahap 6. Menjalankan WRF-Hydro

Saat coupled

```
wrf.exe
```

langsung menjalankan

```
WRF
+
Hydro
```

secara bersamaan.

Tidak ada executable terpisah.

---

# tahap hidrologi yang dihitung

Setiap timestep

```
Atmosfer
      │
      ▼
Rainfall

      │
      ▼
Canopy interception

      │
      ▼
Infiltration

      │
      ▼
Surface runoff

      │
      ▼
Subsurface flow

      │
      ▼
Channel routing

      │
      ▼
River discharge
```

---

# Output WRF

Output atmosfer tetap dihasilkan.

Misalnya

```
wrfout_d01*
```

isi

```
T2
RH
Q2
RAINNC
RAINC
U10
V10
PSFC
SWDOWN
HFX
LH
PBLH
dll
```

Output ini sama seperti WRF biasa.

---

# Output WRF-Hydro

Selain wrfout, muncul folder output hidrologi.

Misalnya

```
CHRTOUT
```

Berisi debit sungai.

Variabel

```
streamflow
velocity
depth
```

---

```
RTOUT
```

Jika memakai routing tertentu.

---

```
LDASOUT
```

Berisi kondisi permukaan.

Misalnya

```
soil moisture

snow

surface runoff

baseflow

evapotranspiration
```

---

```
LAKEOUT
```

Jika menggunakan modul danau.

---

```
GWOUT
```

Jika groundwater aktif.

---

```
HYDRO_RST
```

Restart file hidrologi.

---

# Output penting yang paling sering dianalisis

## Dari WRF

| File   | Isi                                           |
| ------ | --------------------------------------------- |
| wrfout | Curah hujan, suhu, angin, kelembapan, radiasi |
| wrfrst | Restart atmosfer                              |

---

## Dari Hydro

| File      | Isi                       |
| --------- | ------------------------- |
| CHRTOUT   | Debit sungai (Q)          |
| LDASOUT   | Soil moisture, runoff, ET |
| GWOUT     | Groundwater               |
| LAKEOUT   | Danau                     |
| HYDRO_RST | Restart hidro             |

---

# Tahap 7. Post-processing

Biasanya dilakukan dengan Python, NCL, R, MATLAB, atau Panoply.

Contoh analisis atmosfer

```
wrfout

↓

Rainfall map

Temperature

Wind

Humidity

Extreme rainfall
```

---

Contoh analisis hidrologi

```
CHRTOUT

↓

Hydrograph

Peak discharge

Flood timing

Travel time
```

---

Contoh analisis spasial

```
LDASOUT

↓

Soil moisture map

Surface runoff map

Groundwater storage
```

---

# Tahap 8. Validasi

Biasanya dibandingkan dengan data observasi.

### Atmosfer

* Curah hujan stasiun
* GSMaP
* IMERG
* ERA5 (untuk evaluasi)

### Hidrologi

* Debit sungai (AWLR)
* Tinggi muka air
* Data banjir
* Luas genangan dari citra satelit (misalnya Sentinel-1)

Metrik yang umum digunakan meliputi NSE, KGE, RMSE, MAE, dan bias untuk mengevaluasi performa simulasi.

---

## Ringkasan alur keseluruhan

```text
                DATA GLOBAL ATMOSFER
                 (ERA5 / GFS / FNL)
                         │
                         ▼
         geogrid → ungrib → metgrid
                         │
                         ▼
                    met_em*.nc
                         │
                         ▼
                     real.exe
                         │
                         ▼
         wrfinput_d0* + wrfbdy_d01
                         │
                         ▼
                 WRF (Atmosfer)
                         │
          menghasilkan forcing atmosfer
                         │
                         ▼
                WRF-Hydro (Coupled)
                         │
     ┌──────────────┬───────────────┬──────────────┐
     ▼              ▼               ▼              ▼
 Infiltrasi   Surface runoff   Baseflow    Channel routing
     │              │               │              │
     └──────────────┴───────────────┴──────────────┘
                         │
                         ▼
                Output hidrologi
        (CHRTOUT, LDASOUT, GWOUT, LAKEOUT)
                         │
                         ▼
                 Post-processing
                         │
                         ▼
    Peta hujan, kelembapan tanah, limpasan, hidrogaraf,
    debit puncak, waktu tiba banjir, serta evaluasi terhadap
    data observasi dan analisis statistik.
```

Yang perlu diingat adalah **WRF menghasilkan kondisi atmosfer (forcing)**, sedangkan **WRF-Hydro mengubah forcing tersebut menjadi respons hidrologi** pada resolusi yang lebih tinggi. Dengan demikian, satu simulasi *coupled* menyediakan dua kelompok keluaran sekaligus: **output atmosfer** (misalnya `wrfout`) dan **output hidrologi** (misalnya `CHRTOUT`, `LDASOUT`, `GWOUT`, dan file terkait), yang kemudian dianalisis bersama untuk memahami hubungan antara proses meteorologi dan respons DAS.
