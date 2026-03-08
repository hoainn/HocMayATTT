#!/usr/bin/env bash
# Build PDF từ nguồn LaTeX; PDF ghi ra reports/Pdf.
# Chạy script này sau mỗi lần chỉnh sửa file trong reports/LaTex/.
set -e
HELPER_DIR="$(cd "$(dirname "$0")" && pwd)"
REPORTS_DIR="$(cd "$HELPER_DIR/.." && pwd)"
REPORT_NAME="LaTex"
SOURCE_DIR="$REPORTS_DIR/$REPORT_NAME"
PDF_DIR="$REPORTS_DIR/Pdf"
IMAGE_NAME="latex-ddos-build"

mkdir -p "$PDF_DIR"

echo "==> Build image Docker..."
docker build -t "$IMAGE_NAME" "$HELPER_DIR"

echo "==> Build LaTeX -> $PDF_DIR"
docker run --rm \
  -v "$SOURCE_DIR:/build" \
  -v "$PDF_DIR:/out" \
  -w /build \
  "$IMAGE_NAME" \
  "pdflatex -interaction=nonstopmode Main.tex && bibtex Main && pdflatex -interaction=nonstopmode Main.tex && pdflatex -interaction=nonstopmode Main.tex && cp Main.pdf /out/"

echo "==> Xong. PDF: $PDF_DIR/Main.pdf"
