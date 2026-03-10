#!/usr/bin/env bash
# Build slide PDF từ nguồn LaTeX Beamer; PDF ghi ra reports/Slides/slides.pdf
set -e
HELPER_DIR="$(cd "$(dirname "$0")" && pwd)"
REPORTS_DIR="$(cd "$HELPER_DIR/.." && pwd)"
SLIDES_DIR="$REPORTS_DIR/Slides"
IMAGE_NAME="latex-ddos-build"

echo "==> Build image Docker (reuse nếu đã có)..."
docker build -t "$IMAGE_NAME" "$HELPER_DIR"

echo "==> Build slides LaTeX -> $SLIDES_DIR/slides.pdf"
docker run --rm \
  -v "$SLIDES_DIR:/build" \
  -w /build \
  "$IMAGE_NAME" \
  "pdflatex -interaction=nonstopmode slides.tex && pdflatex -interaction=nonstopmode slides.tex"

echo "==> Xong. PDF: $SLIDES_DIR/slides.pdf"
