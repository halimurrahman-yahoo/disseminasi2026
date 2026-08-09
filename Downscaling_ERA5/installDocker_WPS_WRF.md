# Panduan Menjalankan WPS & WRF 4.3 Menggunakan Docker

## 1. Menarik Image Docker

Gunakan image **dtcenter/wps_wrf:latest**.

```bash
docker pull dtcenter/wps_wrf:latest
```

---

## 2. Menjalankan Container

Jalankan container dengan nama **wrf-hydro-training**.

```bash
sudo docker run --name wrf-hydro-training -p 8889:8888 -it dtcenter/wps_wrf:latest /bin/bash
```

---

## 3. Masuk Kembali ke Container

Apabila container sudah berjalan dan ingin masuk kembali ke terminal root:

```bash
sudo docker exec -it d37a060ff1ef /bin/bash
```

> Ganti `d37a060ff1ef` dengan Container ID milik Anda.

---

# Persiapan WPS

Masuk ke direktori:

```bash
cd /comsoftware/wrf/WPS-4.3
```

Pastikan file berikut tersedia:

* `geogrid.exe`
* `ungrib.exe`
* `metgrid.exe`

---

## 4. Membuat Struktur Folder Data

Buat direktori data.

```bash
mkdir -p /comsoftware/wrf/WPS-4.3/DATA/ERA5A
mkdir -p /comsoftware/wrf/WPS-4.3/DATA/ERA5A/PL
mkdir -p /comsoftware/wrf/WPS-4.3/DATA/ERA5A/SFC
```

Nama folder dapat diubah sesuai kebutuhan, tetapi harus disesuaikan kembali pada:

* `runWPS_FINAL.sh`
* `namelist.wps`

---

## 5. Menyalin dan Mengekstrak WPS_GEOG

Salin file geografi ke dalam container.

```bash
docker cp geog_high_res_mandatory.tar.gz wrf-hydro-training:/comsoftware/wrf/WPS-4.3/DATA/
```

Masuk ke direktori data.

```bash
cd /comsoftware/wrf/WPS-4.3/DATA
```

Ekstrak file.

```bash
tar -zxvf geog_high_res_mandatory.tar.gz
```

Setelah selesai akan muncul folder:

```
WPS_GEOG
```

---

## 6. Menyalin Data ERA5

Masukkan file GRIB ke masing-masing folder:

```
DATA/
├── ERA5A/
│   ├── PL/
│   └── SFC/
```

---

# Konfigurasi namelist.wps

Salin file `namelist.wps.p` ke:

```
/comsoftware/wrf/WPS-4.3/
```

Edit menggunakan:

```bash
vi namelist.wps.p
```

Masuk ke mode edit dengan menekan:

```
i
```

Sesuaikan:

* `start_date`
* `end_date`
* Parameter `geogrid`

Ubah:

```text
map_proj = 'mercator'
```

dan

```text
geog_path = '/comsoftware/wrf/WPS-4.3/DATA/WPS_GEOG'
```

### Menyimpan File

Keluar dari mode insert dengan:

```
Esc
```

Lalu:

Simpan dan keluar:

```
:wq
```

Keluar tanpa menyimpan:

```
:q
```

Simpan saja:

```
:w
```

---

# Konfigurasi runWPS_FINAL.sh

Salin file `runWPS_FINAL.sh` ke direktori yang sama.

Edit:

```bash
vi runWPS_FINAL.sh
```

## Bagian Nomor 2

Sesuaikan direktori ERA5.

```bash
ERA5_PL_DIR="/comsoftware/wrf/WPS-4.3/DATA/ERA5A/PL"
ERA5_SFC_DIR="/comsoftware/wrf/WPS-4.3/DATA/ERA5A/SFC"
```

---

## Bagian Nomor 3

Ubah menjadi:

```bash
cd /comsoftware/wrf/WPS-4.3
```

---

## Bagian Nomor 8

Sesuaikan:

```bash
WPS_DIR=/comsoftware/wrf/WPS-4.3
WRF_RUN_DIR=/comsoftware/wrf/WPS-4.3
```

Lalu ubah pengecekan file `met_em` sesuai tanggal simulasi.

Contoh:

```bash
ncdump -h met_em.d01.2016-09-01_00:00:00.nc | grep -E "T2|U10|V10|PSFC"
```

---

## Memberikan Hak Eksekusi

```bash
chmod +x runWPS_FINAL.sh
```

Jalankan:

```bash
./runWPS_FINAL.sh
```

Jika berhasil maka akan muncul file:

```
met_em.*
```

beserta folder ERA5 pada direktori utama WPS.

---

# Menjalankan WRF

Masuk ke direktori:

```bash
cd /comsoftware/wrf/WRF-4.3/test/em_real
```

---

## Link File met_em

```bash
ln -sf /comsoftware/wrf/WPS-4.3/met_em.d0*2016* .
```

File `met_em` sekarang akan terlihat pada direktori `em_real`.

---

# Mengatur namelist.input

Masukkan file `namelist.input`.

Edit:

```bash
vi namelist.input
```

Sesuaikan:

* `start_date`
* `end_date`
* `run_hours`
* `&domains`

---

## Mengaktifkan SST Update

Pada bagian `&time_control`, tambahkan:

```text
auxinput4_inname            = "wrflowinp_d",
auxinput4_interval          = 180, 180, 180,
io_form_auxinput4           = 2,
ignore_iofields_warning     = .true.,
```

Pada bagian `&physics`, tambahkan:

```text
sst_update = 1,
```

---

# Menjalankan real.exe

Apabila belum memiliki hak akses:

```bash
chmod +x real.exe
```

Jalankan:

```bash
./real.exe
```

Jika berhasil akan muncul file seperti:

* `wrfbdy_d01`
* `wrfinput_d01`
* `wrflowinp_d01`

---

# Menjalankan wrf.exe

Berikan hak akses jika diperlukan.

```bash
chmod +x wrf.exe
```

Jalankan:

```bash
./wrf.exe
```

---

# Melihat Progress Simulasi

Buka terminal lain.

Jalankan:

```bash
tail -f rsl.error.0000
```

---

# Visualisasi Hasil di Google Colab

Unggah file:

```
wrfout_d01_2016-09-01_00_00_00
wrfout_d02_2016-09-01_00_00_00
wrfout_d03_2016-09-01_00_00_00
```

Kemudian jalankan kode berikut.

```python
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from matplotlib.animation import FuncAnimation
from IPython.display import HTML, display
import numpy as np

# 1. Daftar file semua domain
FILES = [
    "wrfout_d01_2016-09-01_00_00_00",
    "wrfout_d02_2016-09-01_00_00_00",
    "wrfout_d03_2016-09-01_00_00_00"
]

datasets = [xr.open_dataset(f) for f in FILES]
total_jam = len(datasets[0].Time)

# 2. Siapkan Kanvas
fig, axes = plt.subplots(
    1, 3,
    figsize=(22, 7),
    subplot_kw={'projection': ccrs.PlateCarree()}
)

# 3. Pengaturan Skala Warna
tingkat_warna = np.arange(0, 21, 1)

dummy_lat = datasets[0]['XLAT'].isel(Time=0)
dummy_lon = datasets[0]['XLONG'].isel(Time=0)
dummy_rain = (
    datasets[0]['RAINC'].isel(Time=0)
    + datasets[0]['RAINNC'].isel(Time=0)
).assign_coords({"lat": dummy_lat, "lon": dummy_lon})

dummy_plot = dummy_rain.plot.contourf(
    ax=axes[0],
    transform=ccrs.PlateCarree(),
    levels=tingkat_warna,
    cmap="rainbow",
    vmin=0,
    vmax=20,
    add_colorbar=False
)

cbar = fig.colorbar(
    dummy_plot,
    ax=axes.ravel().tolist(),
    orientation="horizontal",
    pad=0.1,
    aspect=60,
    shrink=0.7,
    ticks=tingkat_warna,
    extend='max'
)

cbar.set_label(
    "Intensitas Curah Hujan Per Jam (mm/hour)",
    fontsize=15,
    fontweight='bold'
)

cbar.ax.tick_params(labelsize=11)

def update(t):

    time_str = str(datasets[0]['Times'].values[t].decode('utf-8'))

    for i, (ds, ax) in enumerate(zip(datasets, axes)):

        ax.clear()

        tot_rain = ds['RAINC'] + ds['RAINNC']

        if t == 0:
            rain_t = tot_rain.isel(Time=0)
        else:
            rain_t = (
                tot_rain.isel(Time=t)
                - tot_rain.isel(Time=t-1)
            )

        lat = ds['XLAT'].isel(Time=0)
        lon = ds['XLONG'].isel(Time=0)

        rain_t = rain_t.where(rain_t > 0)
        rain_t = rain_t.assign_coords({"lat": lat, "lon": lon})

        lon_min, lon_max = lon.min().values, lon.max().values
        lat_min, lat_max = lat.min().values, lat.max().values

        ax.set_extent(
            [lon_min, lon_max, lat_min, lat_max],
            crs=ccrs.PlateCarree()
        )

        rain_t.plot.contourf(
            ax=ax,
            x="lon",
            y="lat",
            transform=ccrs.PlateCarree(),
            levels=tingkat_warna,
            cmap="rainbow",
            vmin=0,
            vmax=20,
            add_colorbar=False
        )

        resolusi = "50m" if i < 2 else "10m"

        ax.coastlines(
            resolution=resolusi,
            color="black",
            linewidth=1.2
        )

        ax.add_feature(
            cfeature.BORDERS,
            linestyle="-",
            edgecolor="black",
            linewidth=0.8
        )

        gl = ax.gridlines(
            draw_labels=True,
            linestyle="--",
            alpha=0.5,
            color="gray"
        )

        gl.top_labels = False
        gl.right_labels = False

        if i > 0:
            gl.left_labels = False

        ax.set_title(
            f"Domain {i+1} ({FILES[i][7:10]})",
            fontsize=14
        )

    plt.suptitle(
        f"Simulasi WRF: Pergerakan Curah Hujan Per Jam\nWaktu Simulasi: {time_str}",
        fontsize=18,
        fontweight='bold',
        y=1.02
    )

print("Sedang merender animasi... Data hujan ringan tetap dipertahankan.")

ani = FuncAnimation(fig, update, frames=total_jam, interval=400)

plt.close(fig)

display(HTML(ani.to_jshtml()))

for ds in datasets:
    ds.close()
```

---

# Hasil

Animasi akan menampilkan:

* Curah hujan per jam.
* Pergerakan hujan pada Domain 1, Domain 2, dan Domain 3.
* Skala intensitas hujan 0–20 mm/jam.
* Seluruh hujan dengan nilai > 0 mm tetap ditampilkan.

Jika dokumentasi ini akan diunggah ke GitHub, saya juga bisa merapikannya lagi dengan penomoran otomatis, daftar isi (Table of Contents), blok **Tips**, **Warning**, dan **Troubleshooting** menggunakan format Markdown GitHub agar tampil lebih profesional.
