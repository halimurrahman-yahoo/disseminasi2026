# Docker?

Docker adalah platform **virtualisasi berbasis container** yang memungkinkan kita menjalankan aplikasi beserta seluruh dependensi, library, dan konfigurasi sistem secara **terisolasi**.

* **Container** berbeda dengan **virtual machine (VM)**:

  * VM: memvirtualisasi seluruh OS → berat, butuh banyak resource.
  * Docker: memvirtualisasi aplikasi & dependensinya di atas OS host → ringan, cepat, portable.
* Dengan Docker, sekali aplikasi dijalankan di container, ia akan berjalan **sama persis** di mana saja: laptop, server, atau cloud.

**Kelebihan utama Docker**:

1. **Portabilitas:** aplikasi berjalan konsisten di berbagai sistem.
2. **Isolasi:** tidak ada konflik library atau versi software.
3. **Reproduksibilitas:** bisa membuat environment ilmiah yang sama persis, penting untuk penelitian.
4. **Ringan & cepat:** tidak perlu boot OS penuh seperti VM.

| Masalah tanpa Docker            | Solusi dengan Docker             |
| ------------------------------- | -------------------------------- |
| Instalasi rumit, banyak library | Pre-built container, tinggal run |
| Konflik versi library           | Container isolasi, versi tetap   |
| Sulit reproduksi simulasi       | Environment identik di semua OS  |
| Tutorial lambat karena setup    | Fokus belajar model, bukan setup |


# Langkah-langkah Docker


### 1️⃣ Cek apakah Docker Desktop sudah terinstall

Di terminal:

```bash
which docker
```

Kalau keluar path seperti:

```
/usr/local/bin/docker
```

berarti Command Line Interface (CLI) ada.

Sekarang cek apakah daemon hidup:

```bash
docker info
```

Kalau error sama → daemon belum jalan.

---
## Kalau Docker Desktop tidak ada?

Install dari:

👉 [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

Pilih versi **Mac Intel** atau **Apple Silicon** sesuai tipe Mac Anda.

Cek tipe Mac:

```bash
uname -m
```

* `x86_64` → Intel
* `arm64` → Apple Silicon (M1/M2/M3)

---

## Catatan untuk Workflow WRF-Hydro

Setup environment WRF-Hydro training:

* Pastikan Docker Desktop punya RAM minimal 8 GB
* CPU minimal 4 core
* Disk space > 20 GB

Cek dan atur di:

```
Docker Desktop → Settings → Resources
```

### 2️⃣ Jalankan Docker Desktop

Buka lewat:

* Spotlight → ketik **Docker**
* atau buka dari Applications → **Docker**

Tunggu sampai muncul pesan:

```
Docker Desktop is running
```

Dan icon 🐳 muncul di menu bar (pojok kanan atas).

---

### 3️⃣ Coba pull image

Setelah Docker Desktop running:

```bash
docker pull wrfhydro/training:v5.2.0-rc1
```

---


## Troubleshooting jika error

Coba restart daemon:

```bash
killall Docker
open -a Docker
```

Atau reboot Mac.

---
## **Docker Desktop crash saat startup** 

### 1️⃣ Cek Apakah Proses Docker Jalan atau Tidak

Di Terminal jalankan:

```bash
ps aux | grep -i docker
```

Kalau tidak ada proses seperti:

```
Docker Desktop
com.docker.backend
```

berarti memang gagal start.

---

### 2️⃣ Jalankan Manual dari Terminal (lihat error)

Coba paksa buka:

```bash
open -a Docker
```

Kalau tidak muncul apa-apa, cek log error:

```bash
tail -n 50 ~/Library/Containers/com.docker.docker/Data/log/vm/dockerd.log
```

Kalau folder log tidak ada → kemungkinan install rusak.

---

### 3️⃣ Kasus Umum di macOS

#### A. Rosetta belum terinstall (untuk Mac M1/M2)

Kalau Mac Apple Silicon:

```bash
uname -m
```

Jika keluar `arm64`, jalankan:

```bash
softwareupdate --install-rosetta
```

---

#### B. Virtualization belum aktif

Masuk ke:

System Settings → Privacy & Security →
Pastikan Docker diizinkan pada:

* ✅ Developer Tools
* ✅ Full Disk Access (sementara untuk test)

---

#### C. Sisa instalasi lama corrupt

Ini paling sering terjadi.

Lakukan clean reset:

```bash
rm -rf ~/Library/Containers/com.docker.docker
rm -rf ~/.docker
```

Lalu reinstall Docker Desktop terbaru.

---

### 4️⃣ Jika Docker Langsung Crash (langsung close)

Coba jalankan binary langsung:

```bash
/Applications/Docker.app/Contents/MacOS/Docker
```

---

### 5️⃣ Solusi Akhir (Clean Reinstall)

1. Uninstall Docker:

   * Applications → Docker → Move to Trash

2. Bersihkan sisa file:

```bash
rm -rf ~/Library/Containers/com.docker.docker
rm -rf ~/.docker
rm -rf ~/Library/Group\ Containers/group.com.docker
```

3. Restart Mac

4. Install ulang dari website resmi

---

## Menghapus docker pull wrfhydro/training:v5.2.0-rc1 karena dokcer lain atau hardisk kapasitas terbatas

Lakukan langkah sbb:

---

# 1️⃣ Cek Image yang Terpasang

```bash
docker images
```

Cari baris:

```
wrfhydro/training   v5.2.0-rc1
```

Catat IMAGE ID-nya.

---

# 2️⃣ Hapus Image Tersebut

```bash
docker rmi wrfhydro/training:v5.2.0-rc1
```

Kalau berhasil, akan muncul:

```
Untagged: wrfhydro/training:v5.2.0-rc1
Deleted: sha256:xxxxx
```

---

# Jika Muncul Error "image is being used by container"

Berarti masih ada container yang memakai image itu.

Cek dulu:

```bash
docker ps -a
```

Kalau ada container dari image itu, hapus dulu:

```bash
docker rm NAMA_CONTAINER
```

Atau paksa sekaligus:

```bash
docker rmi -f wrfhydro/training:v5.2.0-rc1
```

---

# 3️⃣ Bersihkan Space (OK?)

Untuk melihat total pemakaian Docker:

```bash
docker system df
```

Untuk bersihkan cache, container mati, dll:

```bash
docker system prune
```

Kalau mau bersih total (hati-hati):

```bash
docker system prune -a
```

Hati-hati y.. Ini akan menghapus SEMUA image yang tidak dipakai container.

---

# 4️⃣ Cek Disk Space Setelah Hapus

```bash
df -h
```

---

# Tips Hemat Disk untuk WRF-Hydro

Image training biasanya 5–10 GB.
Kalau disk Mac terbatas:

* Gunakan hanya 1 image aktif
* Atur limit disk di:

  ```
  Docker Desktop → Settings → Resources → Disk image size
  ```


```bash
docker system df
```
