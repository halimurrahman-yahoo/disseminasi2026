Dalam **WRF-Hydro**, air hujan yang jatuh dari hasil simulasi WRF tidak langsung menjadi debit sungai. Air tersebut melewati beberapa proses hidrologi yang direpresentasikan oleh tiga komponen utama:

## 1. Overland Flow (Aliran Permukaan)

Overland flow adalah aliran air di atas permukaan tanah setelah hujan turun.

### Proses Fisik

Saat hujan turun:

1. Sebagian meresap ke tanah (infiltrasi)
2. Sebagian tertahan vegetasi
3. Jika intensitas hujan lebih besar daripada kapasitas infiltrasi tanah:

[
Rainfall > Infiltration
]

maka terbentuk limpasan permukaan (runoff).

Air mengalir mengikuti kemiringan topografi menuju:

* parit
* anak sungai
* sungai utama

---

### Pada DAS Segara Anakan

Misalnya:

Hujan ekstrem 100 mm/hari terjadi di lereng Gunung Sawal.

Karena:

* tanah jenuh
* lereng curam

maka terbentuk overland flow besar.

Air membawa:

* pasir
* lanau
* lempung

menuju Sungai Citanduy.

---

### Dalam WRF-Hydro

Menggunakan:

### Diffusive Wave Equation

atau

### 2D Shallow Water Approximation

Output:

* surface runoff
* flow depth
* flow velocity

---

### Mengapa Penting untuk Sedimen?

Sebagian besar erosi terjadi saat overland flow.

Semakin besar:

* kecepatan aliran
* kedalaman aliran

maka semakin besar kemampuan mengangkut sedimen.

---

# 2. Channel Routing (Perambatan Aliran Sungai)

Setelah air masuk ke sungai, proses berikutnya adalah routing.

Routing berarti:

menghitung bagaimana gelombang debit bergerak dari hulu ke hilir.

---

## Analogi

Bayangkan ada hujan deras di hulu Citanduy.

Debit puncak tidak langsung sampai ke Segara Anakan.

Perlu waktu beberapa jam hingga beberapa hari.

Proses perjalanan inilah yang dihitung oleh routing.

---

## Parameter yang Berpengaruh

### Geometri Sungai

* panjang sungai
* lebar sungai
* kemiringan sungai

---

### Kekasaran Sungai

Koefisien Manning:

[
n
]

Misalnya:

* sungai bersih: 0.03
* sungai banyak vegetasi: 0.05

---

### Kemiringan

[
S
]

semakin curam:

* kecepatan naik
* waktu tempuh turun

---

## Dalam WRF-Hydro

Umumnya menggunakan:

### Muskingum-Cunge Routing

atau

### Diffusive Wave Routing

---

Output:

* discharge (Q)
* velocity
* water depth

pada setiap segmen sungai.

---

## Hubungan dengan Sedimen

Kemampuan sungai mengangkut sedimen sangat bergantung pada:

[
Q
]

dan

[
V
]

Semakin besar debit:

* semakin banyak sedimen tersuspensi
* semakin besar sediment yield

yang masuk ke Segara Anakan.

---

# 3. Groundwater Bucket (Simpanan Air Tanah)

Ini adalah representasi sederhana air tanah dalam WRF-Hydro.

Disebut bucket karena dianggap seperti ember penyimpan air.

---

## Konsep Dasar

Saat hujan:

Sebagian air:

[
P
]

masuk ke tanah.

Air tersebut mengisi "ember air tanah".

---

### Jika ember belum penuh

air tersimpan.

---

### Jika ember penuh

air keluar perlahan ke sungai sebagai:

### Baseflow

---

## Analogi

Musim kemarau.

Tidak ada hujan selama 2 minggu.

Tetapi Sungai Citanduy masih mengalir.

Mengapa?

Karena air tanah terus mengalir ke sungai.

Inilah baseflow.

---

## Dalam WRF-Hydro

Bucket mempunyai:

### Storage

[
S
]

---

### Recharge

Air masuk:

[
R
]

---

### Discharge

Air keluar:

[
Q_b
]

---

Persamaan sederhana:

[
\frac{dS}{dt}=R-Q_b
]

---

Output:

* groundwater storage
* baseflow
* recharge

---

# Hubungan Ketiga Komponen

Skemanya dapat digambarkan sebagai:

```text
             HUJAN (WRF)
                   |
                   v
      -------------------------
      |                       |
      | Infiltrasi            |
      |                       |
      v                       v

Groundwater Bucket     Overland Flow
      |                       |
      |                       |
      v                       |
   Baseflow                   |
      |                       |
      -----------+------------
                  |
                  v

           Channel Routing
                  |
                  v

            Debit Sungai
                  |
                  v

           Segara Anakan
                  |
                  v

        Transport Sedimen
```

---

# Untuk Riset Segara Anakan

Komponen paling kritis adalah:

### 1. Overland Flow

Karena langsung menghasilkan erosi lahan dan membawa sedimen.

### 2. Channel Routing

Karena menentukan berapa banyak sedimen yang sampai ke laguna.

### 3. Groundwater Bucket

Lebih berpengaruh pada debit musim kemarau dan kontinuitas aliran, tetapi kontribusinya terhadap transport sedimen biasanya jauh lebih kecil dibanding overland flow saat musim hujan.

Untuk penelitian Anda (ENSO–DMI → Sedimen Segara Anakan), fokus analisis sebaiknya pada:

**ENSO/DMI → Curah Hujan → Overland Flow → Peak Discharge → Sediment Yield → Sediment Delivery ke Segara Anakan**

sedangkan **Groundwater Bucket** digunakan untuk menjelaskan perubahan baseflow antara tahun El Niño (2015), transisi/La Niña (2016), dan netral (2017).
