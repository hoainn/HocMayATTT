# Công cụ bổ trợ build báo cáo

- **build.sh** — Build PDF bằng Docker; nguồn LaTeX ở `../LaTex/`, PDF ghi ra `../Pdf/Main.pdf`.
- **Dockerfile** — Image TeX Live (tiếng Việt, IEEE, **standalone**, pgf) để build báo cáo và render diagram TikZ.

**Luôn chạy build sau mỗi lần cập nhật nguồn LaTeX:**

```bash
./build.sh
```

**Render diagram (Phase 1 / Phase 2) trong container:**

Image đã cài `standalone` và `pgf`. Từ thư mục gốc repo:

```bash
docker run --rm -v "$(pwd)/diagram:/d" -w /d latex-ddos-build \
  "pdflatex -interaction=nonstopmode phase1_diagram.tex && pdflatex -interaction=nonstopmode phase2_diagram.tex"
```

PDF sẽ nằm trong `diagram/`. Copy vào báo cáo nếu cần: `cp diagram/phase1_diagram.pdf diagram/phase2_diagram.pdf reports/LaTex/hinh/`.
