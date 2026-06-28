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

# Modul 1. Pengantar WRF-Hydro

Durasi : 2 jam

## Tujuan

Peserta memahami posisi preprocessing dalam keseluruhan workflow WRF-Hydro.

### Materi

* Konsep WRF-Hydro
* One-way vs Two-way coupling
* Domain atmosfer dan domain hidrologi
* Alur preprocessing

```
DEM
 ↓
River Network
 ↓
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

Output

Peserta memahami seluruh data yang akan dibuat.

---

# Modul 2. Dasar-Dasar GIS

Durasi : 4 jam

## Tujuan

Peserta memahami konsep spasial yang diperlukan dalam WRF-Hydro.

### Materi

Raster

* Pixel
* Resolution
* Extent
* Cell size
* NoData

Vector

* Point
* Line
* Polygon

Coordinate System

* Geographic
* Projected
* Datum
* EPSG

Operasi GIS

* Clip
* Merge
* Reproject
* Buffer
* Dissolve

Praktik

Menggunakan data Indonesia.

---

# Modul 3. Dasar QGIS

Durasi : 6 jam

## Materi

Interface

* Browser
* Layer
* Processing Toolbox

Data

* Membuka raster
* Membuka shapefile
* Styling

Geoprocessing

* Clip Raster
* Clip Vector
* Reproject
* Merge Raster
* Raster Calculator

Export

* GeoTIFF
* Shapefile
* GeoPackage

Praktik

Membuat peta DAS.

---

# Modul 4. Raster Analysis

Durasi : 6 jam

Materi

DEM

Slope

Aspect

Hillshade

Raster Calculator

Masking

Resampling

Nearest Neighbor

Bilinear

Cubic

Praktik

Mengolah DEM menjadi input hidrologi.

---

# Modul 5. Vector Analysis

Durasi : 5 jam

Materi

Editing

Topology

Field Calculator

Spatial Join

Intersection

Union

Dissolve

Split

Praktik

Mengolah batas DAS.

---

# Modul 6. Hydrologic GIS

Durasi : 8 jam

Materi

Konsep

Flow Direction

Flow Accumulation

Catchment

Stream Network

River Order

Watershed

Sink

Fill

Burn Stream

TauDEM

GRASS

SAGA

Praktik

Menghasilkan jaringan sungai.

---

# Modul 7. Data WRF-Hydro

Durasi : 4 jam

Materi

Input yang diperlukan

DEM

Landuse

Soil

River

Lake

Reservoir

Coordinate consistency

Resolution consistency

Projection consistency

Praktik

Validasi data.

---

# Modul 8. Dasar Python

Durasi : 8 jam

## Materi

Python

Variable

Loop

Function

List

Dictionary

NumPy

Pandas

File

CSV

GeoJSON

Praktik

Membaca data spasial.

---

# Modul 9. Python untuk GIS

Durasi : 10 jam

Library

numpy

pandas

geopandas

rasterio

xarray

shapely

fiona

pyproj

matplotlib

Materi

Read Raster

Write Raster

Read Shapefile

Coordinate Transform

Spatial Join

Mask Raster

Clip Raster

Praktik

Membuat script GIS sederhana.

---

# Modul 10. Python untuk NetCDF

Durasi : 6 jam

Materi

NetCDF

xarray

netCDF4

Coordinate

Dimension

Variable

Metadata

Praktik

Membaca

```
geo_em.d01.nc
```

Mengubah variabel

Menulis NetCDF baru.

---

# Modul 11. WRF-Hydro GIS Preparation

Durasi : 12 jam

Materi

Domain

DEM

River

Lake

Projection

Regridding

Routing Grid

High Resolution Grid

Channel Grid

Praktik

Membuat

```
Fulldom_hires.nc
```

---

# Modul 12. WRF-Hydro Geogrid

Durasi : 8 jam

Materi

geo_em

Fulldom

Hydro2dtbl

Route_Link

GWBUCKPARM

LAKEPARM

CHANNELGRID

Praktik

Mengecek semua file.

---

# Modul 13. Quality Control

Durasi : 4 jam

Materi

Visualisasi

QGIS

Python

Validasi

River

DEM

Projection

Missing Data

Praktik

Debugging preprocessing.

---

# Modul 14. Automation

Durasi : 8 jam

Materi

Batch Processing

QGIS Model Builder

Python Automation

Bash

Workflow

Praktik

Otomatisasi preprocessing.

---

# Modul 15. Mini Project

Durasi : 16 jam

Peserta memilih satu DAS.

Target

Mulai dari

DEM

↓

Preprocessing

↓

Routing

↓

Fulldom

↓

Visualisasi

↓

Laporan

---

# Modul 16. Integrasi dengan WRF

Durasi : 4 jam

Materi

```
WPS
```

↓

```
real.exe
```

↓

```
wrf.exe
```

↓

```
WRF-Hydro preprocessing
```

↓

```
hydro.exe
```

↓

Output

Peserta memahami hubungan preprocessing dengan simulasi penuh.

---

# Kompetensi Akhir

Setelah mengikuti pelatihan, peserta mampu:

1. Memahami konsep dasar GIS untuk pemodelan hidrologi.
2. Mengoperasikan QGIS untuk pengolahan data raster dan vektor.
3. Menggunakan Python untuk otomatisasi pengolahan data spasial.
4. Memahami struktur data NetCDF yang digunakan dalam WRF dan WRF-Hydro.
5. Menyiapkan seluruh data masukan WRF-Hydro, termasuk DEM, jaringan sungai, dan parameter hidrologi.
6. Melakukan kontrol kualitas (quality control) terhadap hasil preprocessing.
7. Mengotomatisasi alur kerja preprocessing menggunakan Python dan QGIS.
8. Mengintegrasikan hasil preprocessing ke dalam workflow lengkap WRF–WRF-Hydro hingga siap dijalankan di lingkungan HPC.

## Catatan untuk konteks WRF-Hydro di HPC

Bahwa alur **WPS → `real.exe` → `wrf.exe` → WRF-Hydro** di HPC, pelatihan ini tidak berhenti pada tahap GIS. Next Level, yaitu:
* **Level 1 – GIS Foundation**: Modul 1–6 (konsep GIS, QGIS, analisis raster dan vektor).
* **Level 2 – WRF-Hydro Preparation**: Modul 7–14 (persiapan data hidrologi, Python untuk GIS, NetCDF, dan preprocessing WRF-Hydro).
* **Level 3 – Operational Workflow**: Modul 15–16  simulasi WRF-Hydro di Linux/HPC, sehingga peserta memahami alur lengkap dari data mentah hingga simulasi hidrologi.
