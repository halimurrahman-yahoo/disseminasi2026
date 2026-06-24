**Apa yang sebenarnya komponen WRF-Hydro di setiap time step**.

Pada WRF-Hydro, tiga komponen tersebut sebenarnya berada pada level yang berbeda:

```text
WRF Atmosphere
      |
      |  Rainfall (P)
      v

Noah-MP LSM
      |
      +--> ET
      +--> Soil Moisture
      +--> Infiltration
      |
      v

WRF-Hydro Extensions
      |
      +--> Overland Flow
      |
      +--> Subsurface Flow
      |
      +--> Channel Routing
      |
      +--> Groundwater Bucket
      |
      v

Streamflow Outlet
```

---

# 1. OVERLAND FLOW DALAM WRF-HYDRO

File utama:

```text
hydro.namelist

OVROUGHRTFAC
OVROUGHRT
```

dan

```text
Route_Link.nc
Fulldom_hires.nc
```

---

## Apa yang dihitung?

WRF menghasilkan hujan:

[
P
]

Noah-MP menghitung:

[
I
]

(infiltrasi)

serta

[
ET
]

(evapotranspirasi)

Maka terbentuk excess water:

[
R=P-I-ET
]

Air berlebih ini menjadi:

```text
Surface Runoff
```

---

## Kemudian?

WRF-Hydro mendistribusikan runoff tersebut ke grid resolusi tinggi.

Contoh:

Atmospheric grid

```text
1 km
```

Hydro grid

```text
100 m
```

maka:

```text
1 grid WRF
=
100 grid Hydro
```

---

## Persamaan

WRF-Hydro memakai

### Diffusive Wave

berbasis:

[
\frac{\partial h}{\partial t}
+
\frac{\partial q}{\partial x}
=============================

r
]

dimana

* h = kedalaman air
* q = debit per satuan lebar
* r = hujan/runoff

---

## Output Overland Flow

File:

```text
CHRTOUT*
```

atau

```text
RTOUT*
```

berisi:

* runoff depth
* flow velocity
* flow accumulation

---

# Untuk Segara Anakan

Misalnya:

hujan 150 mm/hari

di lereng Citanduy.

WRF-Hydro menghitung:

```text
berapa mm menjadi runoff
```

dan

```text
ke mana runoff mengalir
```

hingga masuk sungai.

---

# 2. CHANNEL ROUTING DALAM WRF-HYDRO

Ini jantung model hidrologinya.

---

File:

```text
Route_Link.nc
```

berisi

setiap ruas sungai:

```text
LINKNO
Length
Slope
Order
```

---

Contoh:

```text
Link 1
   |
Link 2
   |
Link 3
   |
Segara Anakan
```

---

## Apa yang dihitung?

Air dari overland flow masuk ke channel.

Kemudian WRF-Hydro menghitung:

[
Q(t)
]

yang bergerak dari hulu ke hilir.

---

## Persamaan

Biasanya:

### Muskingum-Cunge

atau

### Diffusive Wave

---

Persamaan sederhana:

[
Q_{out}
=======

C_1 Q_{in}^{t+1}
+
C_2 Q_{in}^{t}
+
C_3 Q_{out}^{t}
]

---

## Artinya?

Model menghitung:

* waktu tempuh
* attenuasi banjir
* debit puncak

---

Misalnya:

Di Citanduy Hulu:

```text
Q = 1000 m³/s
```

tidak langsung menjadi

```text
1000 m³/s
```

di Segara Anakan.

Karena:

* penyimpanan
* gesekan
* travel time

---

## Output

File:

```text
CHRTOUT_DOMAIN*
```

variabel:

```text
streamflow
velocity
water depth
```

---

Untuk penelitian sedimen:

Ini output paling penting.

Karena MUSLE memerlukan:

[
Q
]

dan

[
Q_{peak}
]

---

# 3. GROUNDWATER BUCKET DALAM WRF-HYDRO

Ini sering disalahpahami.

---

WRF-Hydro standar

BUKAN

MODFLOW.

Tidak menghitung akuifer secara detail.

---

Yang digunakan adalah:

```text
Conceptual Bucket Model
```

---

Bayangkan:

```text
      _________
     |         |
     | Bucket  |
     |_________|
```

Air infiltrasi masuk ke bucket.

---

## Input

Dari Noah-MP:

```text
Deep Drainage
```

atau

```text
Recharge
```

---

Misalnya:

```text
20 mm/hari
```

masuk ke bucket.

---

Storage:

[
S
]

akan bertambah.

---

## Pelepasan Air

Bucket mengeluarkan air:

[
Q_b
]

secara perlahan.

---

Persamaan:

[
Q_b
===

C S
]

dimana:

* C = koefisien resesi

---

## Artinya

Semakin penuh bucket:

semakin besar baseflow.

---

## Output

Variabel:

```text
GW_STORAGE
```

```text
BASEFLOW
```

```text
RECHARGE
```

---

# Pada Tahun El Niño 2015

Misalnya:

Curah hujan turun 40%.

Maka:

```text
Recharge turun
```

↓

```text
GW Storage turun
```

↓

```text
Baseflow turun
```

↓

Debit musim kemarau mengecil.

---

# Pada Tahun La Niña 2016

Curah hujan naik.

Maka:

```text
Recharge naik
```

↓

```text
Bucket penuh
```

↓

```text
Baseflow besar
```

↓

Debit sungai tetap tinggi bahkan setelah hujan berhenti.

---

# Yang Paling Penting untuk Riset Sedimen Segara Anakan

Jika tujuan utama adalah **sediment yield dan sediment delivery**, maka kontribusi relatifnya:

| Komponen           | Pengaruh terhadap sedimen |
| ------------------ | ------------------------- |
| Overland Flow      | Sangat besar              |
| Channel Routing    | Sangat besar              |
| Groundwater Bucket | Kecil                     |
| Baseflow           | Kecil                     |
| Peak Runoff        | Sangat besar              |
| Peak Discharge     | Sangat besar              |

Karena itu, untuk DAS Segara Anakan konfigurasi:

```text
WRF (1 km)
      ↓
WRF-Hydro
      ↓
Hydro grid 100 m
      ↓
Channel routing aktif
      ↓
Groundwater bucket aktif
      ↓
Output debit per jam
      ↓
MUSLE
      ↓
Sediment Yield
      ↓
Sediment Delivery ke Segara Anakan
```

Dengan desain ini bisa dikuantifikasi jalur lengkap:

**ENSO/DMI → hujan → overland flow → debit puncak → erosi → sediment yield → sedimentasi Segara Anakan**, yang sangat relevan dengan topik publikasi tentang sedimentasi dan perubahan lingkungan pesisir yang sedang Anda kerjakan.
