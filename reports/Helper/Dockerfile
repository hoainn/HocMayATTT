# TeX Live image: build báo cáo LaTeX (tiếng Việt, IEEE)
FROM texlive/texlive:latest

RUN tlmgr --repository https://mirror.ctan.org/systems/texlive/tlnet install \
      babel-vietnamese adjustbox collectbox \
      standalone pgf \
    && tlmgr path add

WORKDIR /build
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["pdflatex -interaction=nonstopmode Main.tex && bibtex Main && pdflatex -interaction=nonstopmode Main.tex && pdflatex -interaction=nonstopmode Main.tex"]
