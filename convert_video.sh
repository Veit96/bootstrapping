do ffmpeg -i "$f" -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le -f mov "${f/%MP4/mov}"; done

ffmpeg -i 4kfile.mp4 -s hd1080 -c:v libx264 -c:a copy fullhdfile.mp4

Avid: for f in *.MOV; do ffmpeg -i "$f" -c:v dnxhd -profile:v dnxhr_hqx -pix_fmt yuv422p10le -c:a pcm_s16le "output/${f%.*}.mov"; done
