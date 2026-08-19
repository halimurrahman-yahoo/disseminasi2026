# Catatan

Sudah saya update sesuai permintaan.

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

File utama sesuai permintaan Anda:

[Download namelist.input.updated](namelist.input.updated)

Ada satu hal penting mengenai `restart = .true.`. Dalam WRF, opsi ini berarti simulasi **dimulai dari file `wrfrst`**, bukan hanya mengaktifkan pembuatan restart file. Jadi jika ini adalah running pertama dari `2025-11-20 00:00 UTC` dan belum ada `wrfrst_d01_2025-11-20_00:00:00`, seharusnya:

```fortran
restart          = .false.,
restart_interval = 720,
```

WRF tetap akan menghasilkan restart setiap 12 jam. Jika kemudian running terputus dan Anda melanjutkan dari `wrfrst`, barulah gunakan:

```fortran
restart = .true.,
```

Karena itu saya juga siapkan versi yang lebih tepat untuk **initial/first run**, tetapi tetap membuat `wrfrst` setiap 12 jam:

[Download namelist.input.first_run](namelist.input.first_run)

Untuk running operasional pertama, saya lebih menyarankan memakai **`namelist.input.first_run`**. Setelah restart dari checkpoint 12-jam, gunakan versi `namelist.input.updated` dengan `restart=.true.`.
