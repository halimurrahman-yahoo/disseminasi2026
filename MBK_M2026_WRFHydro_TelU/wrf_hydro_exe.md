# Instalasi Docker WRF-Hydro

[Step-1: menyiapkan exe wrfHydro](wrf_hydro_exe.md)

[Step-2: menyiapkan folder run](wrf_hydro_run.md)

### steps
1. do
```bash
docker stop wrfhydro-rc1
```
3. do
```bash
docker rm wrfhydro-rc1
```
5. do
```bash
   mkdir /Volumes/MyPassport/docker_WRF-Hydro_rc1
```
5. lakukan
```bash
   docker run -it --name wrfhydro-rc1 -v /Volumes/myPassport/docker_WRF-Hydro_rc1:/home/docker/work wrfhydro/training:v5.2.0-rc1 /bin/bash
```
6. lakukan jika masuk sbg root
```bash
docker exec -it --user root wrfhydro-rc1 bash
```

7. masuk sbg docker

```bash
docker exec -it wrfhydro-rc1 bash 
```

Image `wrfhydro/training:v5.2.0-rc1`  **bukan image yang sudah berisi hasil kompilasi** (`wrf_hydro.exe`), melainkan **environment pengembangan/training**.

Buktinya:

* Ada source code:

  ```text
  wrf_hydro_nwm_public/
  ├── trunk/
  └── tests/
  ```

* Tidak ada executable:

  ```text
  wrf_hydro.exe
  wrf_hydro_NoahMP.exe
  ```

Jadi executable memang belum dibuat.

---

### Langkah berikutnya

Mari kita lihat apakah source code tersebut memang siap dikompilasi.

Jalankan:

```bash
cd ~/work/src/wrf-hydro-training/wrf_hydro_nwm_public/trunk

ls
```

Kemudian:

```bash
find . -maxdepth 2 -type d
```
Pastikan ada direktori seperti:

```
CMakeLists.txt
NDHMS/
hydro/
Route_Link/
...
```


## Cek apakah tool kompilasi sudah tersedia

Jalankan juga:

```bash
cmake --version
```

```bash
gfortran --version
```

```bash
mpif90 --version
```

```bash
nc-config --version
```

Kalau semuanya ada, berarti image memang disiapkan untuk kompilasi.

#### lakukan kompilasi

Kompilasi tidak disimpan di dalam layer Docker, tetapi di volume mount.

Misalnya:

```bash
cd /home/docker/work

mkdir build
cd build

cmake ~/work/src/wrf-hydro-training/wrf_hydro_nwm_public/trunk -DWRF_HYDRO=ON
```

Lalu:

```bash
make -j$(nproc)
```

Dengan cara ini, hasil kompilasi akan tersimpan di:

```text
/Volumes/MyPassport/docker_WRF-Hydro_rc1/build
```

sehingga tetap ada walaupun container dihapus. Ingat jangan menjalan docker run

---

### Target sekarang bukan hanya mengompilasi lagi, tetapi juga bisa memanfaatkan executable tersebut atau mengulang kompilasi dengan konfigurasi yang sama di Mac.

Silakan kirim hasil dari empat perintah berikut:

```bash
cd ~/wrf-hydro-training/wrf_hydro_nwm_public/trunk
ls
```

```bash
find . -maxdepth 2 -type d
```

```bash
cmake --version
```

```bash
gfortran --version
```

Di image:

* ✅ `conda` ada.
* ✅ Hanya ada environment `base`.
* ❌ Paket **cmake tidak terinstal**.

Terlihat dari:

```text
(base) $ which cmake
```

tidak menghasilkan apa pun.

Dan pencarian hanya menemukan direktori data CMake:

```text
.../share/cmake
.../lib/cmake
```

bukan executable `bin/cmake`.



### install lewat root 

masuk sebagai `root` untuk menginstal paket.

Dari terminal Mac (bukan di dalam container), jalankan:

```bash
docker exec -it --user root wrfhydro-rc1 bash
```

Lalu:

```bash
apt update
apt install -y cmake
```

---
Statusnya sekarang:

| Komponen                                             | Status               |
| ---------------------------------------------------- | -------------------- |
| Source WRF-Hydro v5.2.0-rc1                          | ✅                    |
| gfortran                                             | ✅                    |
| mpif90                                               | ✅                    |
| netCDF                                               | ✅                    |
| cmake                                                | ✅ (`/usr/bin/cmake`) |
| Volume ke `/Volumes/MyPassport/docker_WRF-Hydro_rc1` | ✅                    |

## Selanjutnya: sbg root kompilasi di volume eksternal

Karena Anda sudah masuk sebagai `root`, saya sarankan hasil build disimpan di volume eksternal yang sudah di-mount.

### 1. Masuk ke folder build

```bash
cd /home/docker/work
mkdir -p build
cd build
```

### 2. Cari lokasi `CMakeLists.txt`

Sebelum menjalankan CMake, kita perlu mengetahui lokasi file `CMakeLists.txt` pada source. Jalankan:

```bash
find /home/docker/wrf-hydro-training/wrf_hydro_nwm_public -name CMakeLists.txt
```
```bash
./work/src/wrf-hydro-training/wrf_hydro_nwm_public/trunk/NDHMS/CMakeLists.txt
```

### 3. Setelah menemukan `CMakeLists.txt`

CMakeLists.txt di

```text
/home/docker/wrf-hydro-training/wrf_hydro_nwm_public/trunk/NDHMS/CMakeLists.txt
```
```text
/home/docker/work/src/wrf-hydro-training/wrf_hydro_nwm_public/trunk/NDHMS/CMakeLists.txt
```
maka konfigurasi build menjadi:

```bash
cd /home/docker/work/build

cmake -LAH /home/docker/work/src/wrf-hydro-training/wrf_hydro_nwm_public/trunk/NDHMS
```
### 4. Kompilasi

Jika konfigurasi berhasil tanpa error:

Jalankan:

```bash
make -j$(nproc)
```

Jika `nproc` tidak tersedia:

```bash
make -j4
```

atau jika Mac Anda memiliki banyak core:

```bash
make -j8
```


## Setelah selesai

Jangan langsung menutup terminal. Jalankan:

```bash
find . -name "wrf_hydro*.exe"
```

atau

```bash
find /home/docker/work/build -type f | grep wrf_hydro
```

Ini berarti kompilasi **berhasil 100%**. dengan dua executable:

```text
/home/docker/work/build/Run/wrf_hydro.exe
/home/docker/work/build/Run/wrf_hydro_NoahMP.exe
```

Karena folder `build` berada di:

```text
/home/docker/work/build
```

dan `/home/docker/work` adalah bind mount ke:

```text
/Volumes/MyPassport/docker_WRF-Hydro_rc1
```

maka executable tersebut juga sudah tersimpan di Mac pada:

```text
/Volumes/MyPassport/docker_WRF-Hydro_rc1/build/Run/
├── wrf_hydro.exe
└── wrf_hydro_NoahMP.exe
```

## Langkah berikutnya 

Sebelum menjalankan model, pastikan executable memang berjalan dengan benar.

Jalankan:

```bash
cd /home/docker/work/build/Run

ls -lh
```

Kemudian:

```bash
ldd wrf_hydro.exe
```

dan

```bash
ldd wrf_hydro_NoahMP.exe
```

Pastikan tidak ada baris yang berisi:

```text
not found
```

Jika semua library ditemukan, executable siap digunakan.

## Rapikan hak akses

Karena proses build dilakukan sebagai `root`, ubah kepemilikan hasil build agar mudah diakses oleh user `docker` dan dari macOS:

```bash
chown -R docker:docker /home/docker/work/build
```
## Cek apakah executable tetap ada

Jalankan:

```bash
ls -lh /home/docker/work/build/Run
```

Anda seharusnya masih melihat:

```
wrf_hydro.exe
wrf_hydro_NoahMP.exe
```

---

## Tidak perlu `chown`

Untuk bind mount dari macOS, saya biasanya **tidak melakukan `chown` sama sekali**.

Jadi abaikan saja error tersebut.

---

## Yang lebih penting sekarang

Mari pastikan hasil build benar-benar ada di Mac.

Di terminal macOS (bukan di dalam container), jalankan:

```bash
ls -lh /Volumes/MyPassport/docker_WRF-Hydro_rc1/build/Run
```

Kalau muncul:

```
wrf_hydro.exe
wrf_hydro_NoahMP.exe
```

berarti semuanya sudah tersimpan permanen di external drive.

sudah memiliki:

* ✅ executable `wrf_hydro.exe`
* ✅ executable `wrf_hydro_NoahMP.exe`
* ✅ source code yang dapat dikompilasi ulang kapan saja
* ✅ seluruh hasil build tersimpan di `/Volumes/MyPassport/docker_WRF-Hydro_rc1`

membangun **workflow produksi** untuk domain Segara Anakan, dengan workflow

1. **Folder build** (sudah selesai) ✅
2. **Folder run** untuk WRF-Hydro.
3. Menyalin executable ke folder run.
4. Menyiapkan:

   * `hydro.namelist`
   * `namelist.hrldas`
   * tabel NoahMP
   * `Route_Link.nc`
   * `Fulldom_hires.nc`
   * `GWBUCKPARM.nc`
   * `soil_properties.nc`
   * forcing (`LDASIN` atau hasil WRF)
5. Menjalankan simulasi.

direktori kerja yang rapi di external drive, sbb

```text
/Volumes/myPassport/docker_WRF-Hydro_rc1/
├── build/          # hasil kompilasi
├── run/            # direktori menjalankan simulasi
├── domain/         # Route_Link.nc, Fulldom_hires.nc, dll.
├── forcing/        # LDASIN atau forcing hasil WRF
├── output/         # hasil simulasi
├── scripts/        # script bantu
├── logs/           # log file
└── archive/        # backup konfigurasi
```


```text
Host (Mac):
/Volumes/myPassport/docker_WRF-Hydro_rc1

↓

Container:
/home/docker/work
```

Jadi semua hasil kompilasi sudah tersimpan permanen di external disk **myPassport**.


# Merapikan struktur

Di terminal Mac:

```bash
cd /Volumes/myPassport/docker_WRF-Hydro_rc1

mkdir -p \
domain \
forcing \
run \
output \
logs \
scripts \
src \
archive
```

Sehingga menjadi

```
docker_WRF-Hydro_rc1/
│
├── build/
├── run/
├── domain/
├── forcing/
├── output/
├── logs/
├── scripts/
├── src/
└── archive/
```

Saat ini source masih berada di dalam image Docker

```
/home/docker/wrf-hydro-training
```

Kalau suatu saat image terhapus, source juga hilang.

Lebih aman bila kita salin ke external drive.

Dari dalam container:

```bash
cp -a /home/docker/wrf-hydro-training \
      /home/docker/work/src/
```

Nanti hasilnya

```
/Volumes/myPassport/docker_WRF-Hydro_rc1/src/
└── wrf-hydro-training
```

Jadi punya:

* source
* executable
* build

di satu tempat.

Karena target akhirnya adalah **Segara Anakan**, struktur seperti ini.

```
docker_WRF-Hydro_rc1/
│
├── src/
│
├── build/
│
├── run/
│    ├── hydro.namelist
│    ├── namelist.hrldas
│    ├── wrf_hydro.exe
│    ├── wrf_hydro_NoahMP.exe
│    └── SOILPARM.TBL
│
├── domain/
│    ├── Route_Link.nc
│    ├── Fulldom_hires.nc
│    ├── GWBUCKPARM.nc
│    ├── soil_properties.nc
│    └── ...
│
├── forcing/
│    ├── LDASIN/
│    └── wrfout/
│
├── output/
│
└── logs/
```

Ini sangat mirip dengan struktur yang digunakan di HPC sehingga nanti sinkronisasi ke BRIN menjadi jauh lebih mudah.
