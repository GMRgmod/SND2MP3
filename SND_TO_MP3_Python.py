#!/usr/bin/env python3
import os, sys

def usage():
    print("SND_TO_MP3 v1.0 (minimal)")
    print("Usage:")
    print("  python3 SND_TO_MP3.py file.snd")
    print("  python3 SND_TO_MP3.py --all /folder/path")
    sys.exit(1)

def convert_snd_to_mp3(snd):
    if not snd.endswith(".snd"):
        print("[SKIP] Not an .snd file:", snd)
        return

    mp3_out = snd.replace(".snd", ".mp3")
    tmp_ogg = snd.replace(".snd", ".ogg")

    # Extract OGG from SND
    with open(snd, "rb") as f:
        data = f.read()
    offset = data.find(b"OggS")
    if offset == -1:
        offset = 128  # fallback
    with open(tmp_ogg, "wb") as out:
        out.write(data[offset:])

    # Rename OGG → MP3
    os.rename(tmp_ogg, mp3_out)
    print("[OK]", snd, "->", mp3_out)

def main():
    if len(sys.argv) < 2:
        usage()

    if sys.argv[1] == "--all":
        if len(sys.argv) < 3:
            usage()
        folder = sys.argv[2]
        if not os.path.isdir(folder):
            print("[ERROR] Folder not found:", folder)
            sys.exit(1)
        for f in os.listdir(folder):
            if f.endswith(".snd"):
                convert_snd_to_mp3(os.path.join(folder, f))
    else:
        for f in sys.argv[1:]:
            convert_snd_to_mp3(f)

if __name__ == "__main__":
    main()