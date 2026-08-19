# Catatan disain simulasi TC Senyar



Perubahan yang diterapkan:

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

# PENTING !!!

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

[Download namelist.input.first_run](namelist.input.first_run)

Untuk running operasional pertama, gunakan **`namelist.input.first_run`**. Setelah restart dari checkpoint 12-jam, gunakan versi `namelist.input.updated` dengan `restart=.true.`.

## Versi untuk pasca "STOP" atau running terputus

[Download namelist.input](namelist.input.updated)
