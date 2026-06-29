Target: membangun kompetensi sehingga peserta mampu **menyiapkan seluruh input WRF-Hydro secara mandiri** 


Silabus yang berjenjang dari konsep spasial → QGIS → Python → preprocessing WRF-Hydro. 

## Silabus Pelatihan

# Persiapan Data WRF-Hydro Menggunakan QGIS dan Python

**Target peserta**

* Peneliti hidrologi
* Mahasiswa S1/S2
* Pengguna WRF yang ingin mempelajari WRF-Hydro
* Pengguna GIS dasar

**Prasyarat**

* Mengerti komputer dasar
* Pernah menggunakan Linux lebih baik
* Tidak wajib memahami GIS maupun Python

---

### Modul 1. Pengantar WRF-Hydro

Durasi : 2 jam

#### Tujuan

Peserta memahami posisi preprocessing dalam keseluruhan workflow WRF-Hydro.

#### Materi

* [Konsep WRF-Hydro](https://github.com/halimurrahman-yahoo/DBR_AHE/blob/main/WRFHydro/tahapanWRF-Hydro.md)
* [One-way vs Two-way coupling](https://github.com/halimurrahman-yahoo/DBR_AHE/blob/main/WRFHydro/one_or_two_ways_WRF-Hydro.md)
* [Domain atmosfer dan domain hidrologi](https://github.com/halimurrahman-yahoo/DBR_AHE/blob/main/WRFHydro/skemaWRFHydro.md)
* Alur preprocessing

```
DEM
```
 ↓
```
River Network
```
 ↓
```
Flow Direction
 ↓
Flow Accumulation
 ↓
Routing Grid
 ↓
Fulldom_hires.nc
 ↓
Hydro.exe
```

### Modul 2. Dasar-Dasar GIS
-memahami konsep spasial yang diperlukan dalam WRF-Hydro.

### Modul 3. Dasar QGIS
-memahami aplikasi GIS seperti:

1. Interface (Browser, Layer, Processing Toolbox, etc.)
2. Data (raster, shapefile, Styling, etc.)
3. Geoprocessing (Clip Raster, Clip Vector, Reproject, Merge Raster, Raster Calculator, etc.)
4. Export (GeoTIFF, Shapefile, etc.)

### Modul 4. Raster Analysis
-memahami pengolahan DEM menjadi input hidrologi (DEM, Slope, Raster Calculator, Resampling, etc.)

### Modul 5. Vector Analysis
-memhami pengolahan pngolahan batas DAS (Editing, Topology, Field Calculator, Spatial Join, etc.)

### Modul 6. Hydrologic GIS
-memahami pengolahan jaringan sungai (Flow Direction/Accumulation, Catchment, Stream Network, GRASS, etc.)

### Modul 7. Data WRF-Hydro
-memahami Input yang diperlukan (DEM, Landuse, Soil, River, Coordinate consistency, etc.) dan memprosesnya 

### Modul 8. Python untuk GIS
-memahami pengolahan data spatial berbasis Python (NumPy, Pandas, File, List, Dictionary, Variable, etc.)

### Modul 9. Python untuk NetCDF
-mampu mengolah data netcdf (mis. geo_em.d01.nc) (NetCDF, xarray, Dimension, Variable, etc.)

### Modul 10. WRF-Hydro GIS Preparation
-mampu membuat Fulldom_hires.nc (Domain, DEM, River, Regridding, Routing Grid, etc.)

### Modul 11. WRF-Hydro Geogrid
-mampu cek semua file untuk WRF-Hydro (geo_em, Fulldom, Hydro2dtbl, Route_Link, etc.)

### Modul 12. Integrasi dengan WRF
-memahami hubungan preprocessing dengan simulasi penuh.

```
WPS
↓
real.exe
↓
wrf.exe
↓
WRF-Hydro preprocessing
↓
hydro.exe
↓
Output
```

### Kompetensi Akhir

mampu:

1. Memahami konsep dasar GIS untuk pemodelan hidrologi.
2. Mengoperasikan QGIS untuk pengolahan data raster dan vektor.
3. Menggunakan Python untuk otomatisasi pengolahan data spasial.
4. Memahami struktur data NetCDF yang digunakan dalam WRF dan WRF-Hydro.
5. Menyiapkan seluruh data masukan WRF-Hydro, termasuk DEM, jaringan sungai, dan parameter hidrologi.
6. Melakukan kontrol kualitas (quality control) terhadap hasil preprocessing.
7. Mengotomatisasi alur kerja preprocessing menggunakan Python dan QGIS.
8. Mengintegrasikan hasil preprocessing ke dalam workflow lengkap WRF–WRF-Hydro hingga siap dijalankan di lingkungan HPC.

## Catatan untuk konteks WRF-Hydro di HPC

Bahwa alur **WPS → `real.exe` → `wrf.exe` → WRF-Hydro** di HPC, kelompok tahapannya: 
* **Level 1 – GIS Foundation**: Modul 1–6 (konsep GIS, QGIS, analisis raster dan vektor).
* **Level 2 – WRF-Hydro Preparation**: Modul 7–14 (persiapan data hidrologi, Python untuk GIS, NetCDF, dan preprocessing WRF-Hydro).
* **Level 3 – Operational Workflow**: Modul 15–16  simulasi WRF-Hydro di Linux/HPC, sehingga memahami alur lengkap dari data mentah hingga simulasi hidrologi.
