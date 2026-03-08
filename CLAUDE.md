# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workspace Context

This project lives alongside sibling projects in `/Users/hoainn/Documents/Project/CaoHoc/`:

- `DDos/` — ML pipeline for DDoS/network intrusion detection (Python, Docker, Jupyter)
- `AnToanMayTinh/` — Kubernetes security & DevSecOps (Falco, Kyverno, Cilium)
- `MatMaUngDung/` — Full-stack ecommerce app (React 19 + Fastify 5 + MySQL + MinIO)

## HocMayATT (this repo)

- **Mục đích:** Phát hiện tấn công DDoS bằng học máy — pipeline FAMS (feature selection) + huấn luyện theo nhóm tấn công trên CIC-DDoS 2019.
- **Pipeline:** Phase 1 (`phase1_feature_selection.ipynb`) → FAMS features → Phase 2 (`phase2_model_training.ipynb`) với CIC-DDoS 2019 (Parquet), RobustScaler, Optuna, F2, train-one-group / test-others.
- **Báo cáo LaTeX:** Nguồn `reports/LaTex/`, build bằng `reports/Helper/build.sh`, PDF ra `reports/Pdf/Main.pdf`. Để viết báo cáo nhất quán với code và dữ liệu, xem **`REPO_CONTEXT.md`** (cấu trúc repo, pipeline, dataset, so sánh báo cáo vs code, gợi ý viết).

## Notes

Add project-specific build, lint, and run commands here as needed. After editing LaTeX sources, run `reports/Helper/build.sh` to regenerate the PDF.
