# Phát hiện DDoS bằng Học máy — Pipeline FAMS + Leave-One-Group-Out

Đánh giá khả năng tổng quát hóa của mô hình học máy trong phát hiện DDoS theo nhóm tấn công,
sử dụng khung lựa chọn đặc trưng FAMS và thiết kế thực nghiệm Leave-One-Group-Out trên CIC-DDoS 2019.

## Cấu trúc repo

```
├── phase1_feature_selection.ipynb   # Giai đoạn 1: FAMS feature selection (Kaggle dataset)
├── phase2_model_training.ipynb      # Giai đoạn 2: Huấn luyện KNN/RF/XGB + LOGO evaluation
├── fams_features.json               # Output Phase 1 → input Phase 2 (18 đặc trưng)
├── data/                            # Dữ liệu (không tracked bởi git)
│   ├── ddos_balanced/final_dataset.csv   # Kaggle DDoS dataset (Phase 1)
│   └── cic_ddos_2019/                    # CIC-DDoS 2019 Parquet files (Phase 2)
├── reports/
│   ├── LaTex/                       # Nguồn báo cáo LaTeX (IEEEtran)
│   ├── Helper/build.sh              # Script build PDF bằng Docker
│   └── Pdf/Main.pdf                 # PDF output (không tracked)
└── pyproject.toml                   # Dependencies (quản lý bằng uv)
```

## Yêu cầu

- Python 3.13+
- [uv](https://docs.astral.sh/uv/) (hoặc pip)

## Cài đặt

```bash
# Dùng uv (khuyến nghị)
uv sync

# Hoặc dùng pip
pip install -e .
```

## Chạy notebook

### Giai đoạn 1 — Lựa chọn đặc trưng FAMS

Yêu cầu: `data/ddos_balanced/final_dataset.csv`
(tải từ [Kaggle DDoS Datasets](https://www.kaggle.com/datasets/devendra416/ddos-datasets))

```bash
jupyter nbconvert --to notebook --execute --inplace phase1_feature_selection.ipynb
```

Output: `fams_features.json` — danh sách 18 đặc trưng được chọn.

### Giai đoạn 2 — Huấn luyện và đánh giá mô hình

Yêu cầu:
- `fams_features.json` (output Phase 1)
- `data/cic_ddos_2019/*.parquet` (CIC-DDoS 2019 — tải từ [Canadian Institute for Cybersecurity](https://www.unb.ca/cic/datasets/ddos-2019.html), chuyển sang Parquet)

```bash
jupyter nbconvert --to notebook --execute --inplace phase2_model_training.ipynb
```

### Chạy tương tác

```bash
jupyter notebook
# Hoặc
jupyter lab
```

Mở `phase1_feature_selection.ipynb` → chạy hết → mở `phase2_model_training.ipynb` → chạy hết.

## Build báo cáo LaTeX

Yêu cầu Docker.

```bash
cd reports/Helper
./build.sh
```

PDF được ghi ra `reports/Pdf/Main.pdf`.
