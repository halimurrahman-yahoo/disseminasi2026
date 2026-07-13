Tahap **menyiapkan folder `run`** dengan menggunakan struktur yang rapi 

## 1. Masuk ke folder run

Di dalam container (sebagai `root` atau `docker`, keduanya boleh untuk tahap ini):

```bash
cd /home/docker/work/run
pwd
```

Seharusnya hasilnya:

```text
/home/docker/work/run
```

---

## 2. Salin executable

Dari folder hasil build:

```bash
cp /home/docker/work/build/Run/wrf_hydro.exe .
cp /home/docker/work/build/Run/wrf_hydro_NoahMP.exe .
```

Cek:

```bash
ls -lh
```

Minimal akan muncul:

```text
wrf_hydro.exe
wrf_hydro_NoahMP.exe
```

---

## 3. Buat struktur subfolder

Saya menyarankan struktur berikut:

```bash
mkdir -p DOMAIN
mkdir -p FORCING
mkdir -p OUTPUT
mkdir -p RESTART
mkdir -p LOGS
```

Sehingga menjadi:

```text
run/
├── wrf_hydro.exe
├── wrf_hydro_NoahMP.exe
├── DOMAIN/
├── FORCING/
├── OUTPUT/
├── RESTART/
└── LOGS/
```
Setelah folder `run` siap, akan diisi dengan:

```
run/
│
├── hydro.namelist
├── namelist.hrldas
├── wrf_hydro.exe
├── wrf_hydro_NoahMP.exe
│
├── DOMAIN/
│   ├── Route_Link.nc
│   ├── Fulldom_hires.nc
│   ├── GWBUCKPARM.nc
│   ├── GWBASINS.nc
│   ├── geo_em.d01.nc
│   ├── soil_properties.nc
│   └── wrfinput_d01
│
├── FORCING/
│
├── OUTPUT/
│
└── RESTART/
```


`hydro.namelist` dan `namelist.hrldas` menggunakan **template resmi WRF-Hydro v5.2.0-rc1** yang sesuai dengan executable yang baru dikompilasi. Ini akan mengurangi risiko parameter yang tidak kompatibel.

Cek apakah template resmi sudah ada di source code:

```bash
find /home/docker/wrf-hydro-training -type f \( -name "hydro.namelist" -o -name "namelist.hrldas" \)
```

copy **template resmi WRF-Hydro v5.2.0-rc1**, sehingga kita **tidak perlu** menggunakan template lama dari internet.

## Langkah 1. Salin template resmi

Karena executable yang dikompilasi menggunakan **NoahMP**, gunakan template NoahMP.

Jalankan:

```bash
cd /home/docker/work/run

cp /home/docker/wrf-hydro-training/wrf_hydro_nwm_public/trunk/NDHMS/template/HYDRO/hydro.namelist .
cp /home/docker/wrf-hydro-training/wrf_hydro_nwm_public/trunk/NDHMS/template/NoahMP/namelist.hrldas .
```

Cek:

```bash
ls -lh
```

Seharusnya muncul kira-kira:

```text
hydro.namelist
namelist.hrldas
wrf_hydro.exe
wrf_hydro_NoahMP.exe
```

## Langkah 2. Siapkan folder DOMAIN

Masuk ke folder domain:

```bash
cd /home/docker/work/domain
```

Isi folder ini dengan hasil GIS preprocessing.

Idealnya nanti berisi seperti ini:

```text
domain/
├── Route_Link.nc
├── Fulldom_hires.nc
├── GWBUCKPARM.nc
├── soil_properties.nc
├── geo_em.d02.nc
├── spatialweights.nc
└── ...
```
dari **hasil menjalankan GIS Preprocessor** dan menghasilkan:

* ✅ `SAL_routing.zip`

Biasanya isi `SAL_routing.zip` mencakup file-file seperti:

* `Route_Link.nc`
* `Fulldom_hires.nc`
* `GWBUCKPARM.nc`
* `LakeParm.nc` (jika ada)
* `soil_properties.nc`
* `hydro2dtbl.nc`
* dan file pendukung lainnya.

Ini digunakan untuk domain Segara Anakan.

jalankan **di Mac** (bukan di dalam container, jika file ZIP ada di host):

```bash
unzip -l SAL_routing.zip
```

lanjut ke kompilasi [https://github.com/NCAR/wrf_hydro_gis_preprocessor](https://github.com/NCAR/wrf_hydro_gis_preprocessor)
