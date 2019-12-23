for f in *.m4a; do avconv -i "$f" "${f/%m4a/wav}"; done
