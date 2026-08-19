# Simulasi TC Senyar

## 1. Disain Simulasi

### Latar belakang dan tujuan
Studi Siklon Tropis Senyar menganalisis kejadian hujan ekstrem di Sumatra bagian utara pada 25–26 November 2025 dan mengusulkan keterlibatan beberapa komponen
atmosfer, terutama Equatorial Rossby Wave (ERW), cold surge, anomali kelembapan yang berasosiasi dengan MJO, serta interaksi sirkulasi dengan Pegunungan Barisan.
Skema awal mengusulkan empat simulasi, yaitu Control Run, modifikasi topografi, pelemahan cold surge, dan pengurangan kelembapan.


Disain simulasi terdiri atas enam eksperimen WRF:
1. CTRL — Control Run;
2. FLAT-TOPO — reduced/removed Barisan topography;
3. WEAK-CS — weakened cold-surge anomaly;
4. RED-MJO-Q — reduced MJO-associated moisture anomaly;
5. WEAK-ERW — weakened ERW circulation anomaly;
6. WEAK-CS-ERW — combined cold-surge and ERW weakening experiment.

Lebih lanjut rancangan disain pelajari domuken simulasi >> [Dokumen Disain Simulasi](skema_senyar.pdf)

## 2.Implementasi untuk WPS dan WRF

### Domain Area of Interest

<img width="1351" height="615" alt="TC_Senyar" src="https://github.com/user-attachments/assets/8ecc684f-38b6-445e-b67f-b4e8222c4469" />

### Penyesuaian namelist:

[1. Download namelist.wps.p](namelist.wps.p)

[2. Download namelist.input.fisrt.run](namelist_firstrun.input)

[3. Download namelist.input.next.run](namelist_nextrun.input)

***Untuk Download no 2 dan 3, sebelum digunakan running WRF jangan lupa rename file hasil download menjadi namelist.input !!!***

### Penjelasan

* `num_metgrid_levels = 61`
* `cu_physics = 2, 0`

  * D01 10 km: BMJ
  * D02 3.33 km: tanpa cumulus parameterization / explicit convection
* `restart = .true.`
* `restart_interval = 720` menit = **12 jam**
* SST update:

  * `sst_update = 1`
  * `auxinput4_interval = 60, 60` menit
  * menggunakan `wrflowinp_d01` dan `wrflowinp_d02`
* Output WRF:

  * `history_interval = 60, 60`
  * `frames_per_outfile = 24, 24`
  * jadi **1 file `wrfout` per hari**, dengan 24 time-step/jam di dalam satu file.

***PENTING !!!***

Hal penting mengenai `restart = .true.` dalam WRF. Opsi ini berarti simulasi **dimulai dari file `wrfrst`**, bukan hanya mengaktifkan pembuatan restart file. 

Jadi running pertama dari `2025-11-20 00:00 UTC` dan belum ada `wrfrst_d01_2025-11-20_00:00:00`, jadi:

```fortran
restart          = .false.,
restart_interval = 720,
```

WRF tetap akan menghasilkan restart setiap 12 jam. Jika kemudian running terputus, lanjutkan dari `wrfrst`, barulah gunakan:

```fortran
restart = .true.,
```

---

## Versi untuk **initial/first run**, dan akan membuat `wrfrst` setiap 12 jam,

[Download namelist_firstrun.input](namelist_firstrun.input)

***Jangan lupa rename file hasil download menjadi namelist.input !!!***


Untuk running operasional pertama, gunakan **`namelist_firstrun.input`**. Setelah restart dari checkpoint 12-jam, gunakan versi `namelist.input.updated` dengan `restart=.true.`.

## Versi untuk pasca "STOP" atau running terputus

[Download namelist_nextrun.input](namelist_nextrun.input)

***Jangan lupa rename file hasil download menjadi namelist.input !!!***
