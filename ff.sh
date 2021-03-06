#! /bin/bash

if [ $# -ne 1 ]; then
    echo "请检查文件参数，按格式输入，例如(./ff.sh test.avi)"
    exit 1;
fi

if [ ! -f $1 ]; then
    echo "请检查文件是否存在！"
    exit 1;
fi

echo "开始转换文件(mp4, flv, hls)..."
mytime=`date +%s`
basedir="video_$mytime"
filename="${1%%.*}"
newfilename="$filename"_"$mytime"
httpdir="$basedir/http"
rtmpdir="$basedir/rtmp"
hlsdir="$basedir/hls/$newfilename"

mkdir -p $httpdir $rtmpdir $hlsdir

sleep 5
echo "正在转换mp4文件(用于普通http播放)..."
ffmpeg -i $1 -c:v libx264 -f mp4 $httpdir/$newfilename.mp4
echo "mp4转换完成，存储在$httpdir文件夹"

sleep 5
echo "正在转换flv文件(用于rtmp播放)..."
ffmpeg -i $1 -f flv $rtmpdir/$newfilename.flv
echo "flv转换完成，存储在$rtmpdir文件夹"

sleep 5
echo "正在转换hls文件(用于切片播放)..."
ffmpeg -i $1 -c:v libx264 -map 0 -f ssegment -segment_format mpegts -segment_list $hlsdir/playlist.m3u8 -segment_time 10 $hlsdir/out%03d.ts
echo "mp4转换完成，存储在$hlsdir文件夹"
