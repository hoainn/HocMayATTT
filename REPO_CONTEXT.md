# Ngữ cảnh repo — Viết báo cáo hợp lý

Tài liệu này tổng hợp cấu trúc và pipeline thực tế của repo để viết báo cáo LaTeX (`reports/LaTex/`) nhất quán với code và dữ liệu.

---

## 1. Cấu trúc repo

```
HocMayATT/
├── data/
│   ├── (Phase 1)         # Dữ liệu Phase 1: CIC DoS 2016 + CIC IDS 2017 + CIC IDS 2018 từ Kaggle (devendra416/ddos-datasets) → final_dataset.csv
│   ├── ids2018/          # CIC-IDS 2018 (CSV) — có thể dùng riêng tùy pipeline
│   ├── ddos2019/         # CIC-DDoS 2019 (17 file Parquet) — Phase 2
│   ├── ddos_balanced/    # Dataset cân bằng (nếu có)
│   ├── ddos_imbalanced/  # Dataset mất cân bằng (nếu có)
│   └── docs/             # Tài liệu (vd. FAMS.pdf)
├── phase1_feature_selection.ipynb   # Giai đoạn 1: FAMS feature selection
├── phase1_feature_selection.md     # Mô tả thiết kế Phase 1
├── phase2_model_training.ipynb     # Giai đoạn 2: Huấn luyện theo nhóm tấn công
├── phase2_model_training.md       # Mô tả thiết kế Phase 2
├── ddos_detection_fams.ipynb      # Pipeline gộp (tùy biến)
├── ddos_detection_fams_executed.ipynb
├── fams_features.json             # Output Phase 1: danh sách đặc trưng FAMS (23 tên trong repo hiện tại)
├── workflow.mmd                   # Sơ đồ tổng thể (Mermaid)
├── workflow_phase1.d2 / workflow_phase2.d2
├── main.py
├── reports/
│   ├── LaTex/            # Nguồn báo cáo (Main.tex, chapters/, hinh/, reference.bib)
│   ├── Pdf/               # PDF build (Main.pdf)
│   └── Helper/            # Docker + build.sh
├── CLAUDE.md
└── REPO_CONTEXT.md        # File này
```

---

## 2. Pipeline thực tế (code)

### Phase 1 — Lựa chọn đặc trưng FAMS

| Hạng mục | Trong code / doc |
|----------|-------------------|
| **Nguồn dữ liệu** | **CIC DoS 2016, CIC IDS 2017, CIC IDS 2018** — dataset tổng hợp từ Kaggle [devendra416/ddos-datasets](https://www.kaggle.com/datasets/devendra416/ddos-datasets); file dùng trong pipeline: `final_dataset.csv` (balanced 50/50). |
| **Tiền xử lý** | Ép kiểu, ±∞→NaN, dropna, dedup; mã hóa nhãn BENIGN=0, attack=1 |
| **Chia dữ liệu** | Stratified **70/30** (train/test) |
| **Chuẩn hóa** | **RobustScaler** (median/IQR) fit trên train |
| **Cân bằng lớp** | SMOTE bỏ qua nếu dataset đã 50/50 |
| **5 phương pháp FAMS** | Variance (Filter), Mutual Information (Filter), RFE/Backward Elimination (Wrapper), Lasso L1 (Embedded), RF Importance (Embedded); mỗi phương pháp chọn top-25 |
| **Bỏ phiếu** | Giữ đặc trưng có số phiếu ≥ 3 hoặc > 3 (tùy cấu hình) → **8 đặc trưng** (workflow.mmd) hoặc **23** (fams_features.json tương ứng một lần chạy với ngưỡng khác) |
| **Đánh giá Phase 1** | KNN, RF, XGB với 3-fold CV + test set; metric F2, FNR |

### Phase 2 — Huấn luyện và đánh giá (CIC-DDoS 2019)

| Hạng mục | Trong code / doc |
|----------|-------------------|
| **Nguồn** | **17 file Parquet** trong `data/ddos2019/` (CIC-DDoS 2019) |
| **Chuẩn hóa nhãn** | DrDoS_X → X, UDP-lag → UDPLag |
| **Đặc trưng** | Chỉ dùng **N đặc trưng FAMS** từ Phase 1 (đọc từ `fams_features.json`) |
| **Phân nhóm tấn công** | G1 (Reflection/Application hoặc UDP Amplification), G2 (Reflection/Volume hoặc App Protocol), G3 (Exploitation/Flooding); Benign dùng chung |
| **Chia Benign** | 70/30 một lần, dùng chung cho mọi thí nghiệm |
| **Thí nghiệm** | **Exp 1:** Train G1 → Test G2+G3. **Exp 2:** Train G2 → Test G1+G3. **Exp 3:** Train G3 → Test G1+G2 (G3 ít mẫu → cần SMOTE/class_weight) |
| **Chuẩn hóa** | **RobustScaler** fit trên X_train |
| **Tối ưu siêu tham số** | **Optuna** (30 trials, TPE), subsample stratified, val 80/20, **mục tiêu F2** |
| **CV** | **5-fold StratifiedKFold**, scoring F2 |
| **Mô hình** | KNN, RF, XGB |
| **Metric đánh giá** | Accuracy, Precision, Recall, **F1**, **F2**, FNR, AUC, Confusion Matrix, **Gap (CV F2 − Test F2)** |

---

## 3. So sánh với báo cáo LaTeX hiện tại

| Nội dung | Báo cáo LaTeX | Repo (code) | Gợi ý viết |
|----------|----------------|--------------|------------|
| **Dataset** | CICDDoS2019 | CIC-DDoS 2019 (17 Parquet) | Khớp; có thể nêu rõ "17 file Parquet" nếu muốn mô tả chi tiết. |
| **Đặc trưng FAMS** | 21 đặc trưng (bảng từ paper Ma et al.) | 8 (workflow) hoặc 23 (fams_features.json) từ chạy nội bộ | Báo cáo có thể: (1) giữ 21 đặc trưng của FAMS paper làm tham chiếu và nêu "nghiên cứu áp dụng/đối chiếu với tập đặc trưng từ Phase 1 (N đặc trưng)"; hoặc (2) thay bảng bằng danh sách thực tế từ `fams_features.json` nếu muốn báo cáo trùng với code. |
| **Chia train/test** | 80/20 | Phase 1: 70/30; Phase 2: Benign 70/30 + train-one-group test-others | Nếu báo cáo mô tả "một" thí nghiệm đơn giản: 80/20 là hợp lý. Nếu báo cáo mô tả đúng pipeline repo: nên nêu 70/30 và thiết kế theo nhóm (train G1, test G2+G3, v.v.). |
| **Số lượng mẫu** | 500.000 bản ghi | Phase 2: ~45k–46k dòng sạch (sau dropna, dedup); tổng raw tùy file | Chỉ nêu "500.000" nếu thực sự subsample đúng số đó; nếu không, dùng số thực tế từ notebook (vd. "khoảng 45.000 bản ghi sau tiền xử lý") hoặc bỏ con số cụ thể. |
| **Kịch bản kiểm thử** | 3 kịch bản: (1) Nền Syn/UDP/UDP-Lag, (2) test_22_01 DNS/LDAP/MSSQL, (3) test_23_01 SNMP/NTP/TFTP/NetBIOS | 3 thí nghiệm: Train G1→Test G2+G3, Train G2→Test G1+G3, Train G3→Test G1+G2 | Có thể căn chỉnh: hoặc đổi báo cáo sang "3 thí nghiệm theo nhóm (train một nhóm, test trên nhóm chưa thấy)", hoặc giữ 3 kịch bản nhưng ghi rõ tương ứng với file/ngày thu thập (test_22_01, test_23_01) nếu có trong data. |
| **Scaler** | Ch.4: RobustScaler; Ch.5: StandardScaler | Phase 1 & 2: **RobustScaler** | Thống nhất dùng **RobustScaler** trong cả phương pháp và thực nghiệm, trừ khi có lý do rõ ràng dùng StandardScaler. |
| **Tối ưu siêu tham số** | RandomizedSearchCV | **Optuna** (30 trials, TPE) | Có thể đổi báo cáo sang "Optuna (TPE, 30 trials)" hoặc giữ RandomizedSearchCV nếu mô tả phương pháp tổng quát. |
| **Metric chính** | F1-Score, Accuracy, thời gian suy luận | Phase 2: **F2**, F1, Accuracy, FNR, Gap | Nếu báo cáo phản ánh repo: nên thêm F2 và (tuỳ chọn) Gap CV–Test. |

---

## 4. Nguồn dữ liệu và nhãn (để trích dẫn chính xác)

- **CICDDoS2019:** Sharafaldin et al., ICISSP 2018 — `\cite{cicddos2019}` (Phase 2).
- **Phase 1 — Kaggle DDoS dataset:** CIC DoS 2016, CIC IDS 2017, CIC IDS 2018 — nguồn: [Kaggle: devendra416/ddos-datasets](https://www.kaggle.com/datasets/devendra416/ddos-datasets); file `final_dataset.csv` dùng cho lựa chọn đặc trưng FAMS.
- **Nhãn CIC-DDoS 2019 trong code:** DrDoS_DNS, DrDoS_LDAP, DrDoS_MSSQL, DrDoS_NetBIOS, DrDoS_NTP, DrDoS_SNMP, DrDoS_SSDP, DrDoS_UDP, UDP-lag, Syn, WebDDoS, Benign (và Portmap, TFTP tùy taxonomy).
- **Nhóm trong phase2_model_training:** G1 (MSSQL, DNS, LDAP, NetBIOS, SNMP, Portmap), G2 (NTP, TFTP), G3 (Syn, UDP, UDPLag, WebDDoS). Trong ddos_detection_fams_executed: G1 UDP Amplification (DNS, NTP, SNMP, UDP, UDPLag), G2 App Protocol (LDAP, MSSQL, NetBIOS, Portmap, TFTP), G3 Flooding (Syn, WebDDoS).

---

## 5. Tài liệu tham khảo trong repo

- **FAMS (khung + 21 đặc trưng):** Ma, Chen, Zhai (2023), *Electronics*, "A DDoS Attack Detection Method Based on Natural Selection of Features and Models" — `data/docs/FAMS.pdf`.
- **Phase 1 dataset:** CIC DoS 2016, CIC IDS 2017, CIC IDS 2018 từ [Kaggle: devendra416/ddos-datasets](https://www.kaggle.com/datasets/devendra416/ddos-datasets); báo cáo có thể trích dẫn `\cite{kaggle_ddos_dataset}`.
- **workflow.mmd:** Sơ đồ tổng thể Phase 1 + Phase 2.
- **phase1_feature_selection.md, phase2_model_training.md:** Mô tả thiết kế và lựa chọn (scaler, metric, split, nhóm tấn công).

---

## 6. Gợi ý khi viết báo cáo

1. **Thống nhất số liệu với code:** Số đặc trưng (8/21/23), số mẫu, tỷ lệ train/test, tên nhóm tấn công và kịch bản kiểm thử nên khớp với một phiên bản pipeline (vd. phase2_model_training.ipynb + fams_features.json).
2. **Scaler:** Dùng nhất quán RobustScaler trong phương pháp và thực nghiệm, trừ khi có lý do rõ.
3. **Metric:** Nếu báo cáo theo repo, nêu F2 (và F1), Gap CV–Test; nếu giữ narrative đơn giản thì F1 + Accuracy vẫn ổn.
4. **Trích dẫn:** CICDDoS2019, FAMS (Ma et al. 2023), taxonomy DDoS (Mirkovic), Scikit-learn, XGBoost, SHAP — đã có trong `reports/LaTex/reference.bib`.
5. **Sau mỗi lần chỉnh báo cáo:** Chạy `reports/Helper/build.sh` để build lại PDF.

---

*File này dùng làm ngữ cảnh để viết báo cáo hợp lý với repo; cập nhật khi pipeline hoặc dữ liệu thay đổi.*
