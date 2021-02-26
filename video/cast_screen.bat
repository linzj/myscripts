set PATH=D:\ffmpeg-20161218-02aa070-win64-static\bin;C:\Users\lin\AppData\Local\Programs\Python\Python39;%PATH%
@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -framerate 24 -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -r 24 -pix_fmt yuv420p -listen 1 -f flv -flvflags no_duration_filesize rtmp://0.0.0.0:1234
@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -framerate 60 -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -preset llhp -profile:v baseline -pix_fmt yuv420p -listen 1 -f flv -flvflags no_duration_filesize rtmp://0.0.0.0:1234
@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -framerate 30 -probesize 100M -draw_mouse 1 -i desktop -acodec aac -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p -listen 1 -f flv -flvflags no_duration_filesize rtmp://0.0.0.0:1234

@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -framerate 24 -probesize 100M -draw_mouse 1 -i desktop -acodec aac -c:v h264_nvenc -r 24 -crf 25 -pix_fmt yuv444p out.mp4

@REM Multicast

@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -framerate 24 -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -r 24 -pix_fmt yuv420p -listen 1 -f mpegts udp://233.233.233.233:5555

@REM test high quality
@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -framerate 24 -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -r 24 -pix_fmt yuv444p -listen 1 -f mpegts udp://233.233.233.233:5555
@REM ffmpeg.exe -re -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -preset lossless -pix_fmt yuv444p -listen 1 -f mpegts udp://233.233.233.233:5555
@REM ffmpeg.exe -re -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v libx264rgb -crf 0 -pix_fmt bgra -preset ultrafast -listen 1 -f mpegts udp://233.233.233.233:5555

@REM test rtp unicast
@REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 1000M -f gdigrab -framerate 60 -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -preset llhq -profile:v baseline -pix_fmt yuv420p -listen 1 -f rtp_mpegts rtp://192.168.1.10:5555
REM ffmpeg.exe -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 1000M -f gdigrab -framerate 24 -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v libx264 -profile:v main -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p -listen 1 -f rtp_mpegts rtp://192.168.1.10:5555
@REM ffmpeg.exe -re -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v libx264rgb -crf 0 -pix_fmt bgra -preset ultrafast -listen 1 -f rtp_mpegts rtp://192.168.1.10:5555

@REM test rtp ipv6 multicast
@REM ffmpeg.exe -re -f dshow -i audio="@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{B2575203-1ABE-41A4-A72F-FA717B7788F1}" -rtbufsize 100M -f gdigrab -probesize 10M -draw_mouse 1 -thread_queue_size 4096 -i desktop -acodec aac -c:v h264_nvenc -preset lossless -pix_fmt yuv444p -listen 1 -f rtp_mpegts rtp://[ff08::1]:5555

@REM test dshow device
@REM ffmpeg.exe -rtbufsize 1000M -thread_queue_size 4096 -f dshow -i video="screen-capture-recorder" -thread_queue_size 4096 -f dshow -i audio="virtual-audio-capturer" -acodec aac -c:v h264_nvenc -preset llhq -profile:v high -pix_fmt yuv420p -listen 1 -f flv -flvflags no_duration_filesize rtmp://[::0]:1234
@REM ffmpeg.exe -rtbufsize 1000M -thread_queue_size 4096 -r 24 -f dshow -i video="screen-capture-recorder" -thread_queue_size 4096 -f dshow -i audio="virtual-audio-capturer" -acodec aac -r 24 -c:v h264_nvenc -preset slow -profile:v high -pix_fmt yuv420p -listen 1 -f rtp_mpegts rtp://192.168.1.10:5555
@REM -itsoffset:a 1.5 
@REM ffmpeg.exe -thread_queue_size 4096 -f dshow -i video="screen-capture-recorder" -thread_queue_size 4096 -f dshow -i audio="virtual-audio-capturer" -acodec aac -c:v h264_nvenc -preset llhq -profile:v high -pix_fmt yuv420p -listen 1  -f mpegts tcp://0.0.0.0:5555

mkdir tmp
cd tmp
del /q *
start /b ffmpeg.exe -thread_queue_size 4096 -f dshow -i video="screen-capture-recorder" -thread_queue_size 4096 -f dshow -itsoffset:a 0.4 -i audio="virtual-audio-capturer" -acodec aac -g 120 -c:v h264_nvenc -preset llhq -qp 20 -profile:v high -pix_fmt yuv420p -f hls -hls_time 1.0 -hls_delete_threshold 2 -hls_flags delete_segments+append_list  out.m3u8
python -m http.server
