#!/data/data/com.termux/files/usr/bin/bash
# SND_TO_MP3 v1.0 (Termux minimal)

usage() {
    echo "SND_TO_MP3 v1.0 (minimal)"
    echo "Usage:"
    echo "  bash SND_TO_MP3.sh file.snd"
    echo "  bash SND_TO_MP3.sh --all /folder/path"
    exit 1
}

convert_snd_to_mp3() {
    snd="$1"
    [ ! -f "$snd" ] && echo "[ERROR] File not found: $snd" && return

    mp3="${snd%.snd}.mp3"
    ogg="${snd%.snd}.ogg"

    # Extract OGG part from SND
    offset=$(grep -abo $'\x4f\x67\x67\x53' "$snd" | head -n1 | cut -d: -f1)
    [ -z "$offset" ] && offset=128

    dd if="$snd" of="$ogg" bs=1 skip=$offset status=none

    # Rename OGG → MP3
    mv "$ogg" "$mp3"
    echo "[OK] $snd -> $mp3"
}

if [ $# -lt 1 ]; then
    usage
fi

if [ "$1" = "--all" ]; then
    [ -z "$2" ] && usage
    folder="$2"
    if [ ! -d "$folder" ]; then
        echo "[ERROR] Folder not found: $folder"
        exit 1
    fi
    for f in "$folder"/*.snd; do
        [ -e "$f" ] || continue
        convert_snd_to_mp3 "$f"
    done
else
    for f in "$@"; do
        convert_snd_to_mp3 "$f"
    done
fi