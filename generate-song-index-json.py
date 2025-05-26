#!/usr/bin/env python3
# this script assumes a structure where every folder contains all the files for a song
import argparse
import json
import os
from urllib.parse import quote
import sys


def generate_json_for_folder(path: str, base_url: str) -> list[dict]:
    results = []
    files = []
    
    if path.startswith("./"):
        path = path[2:]

    for item in os.listdir(path):
        if os.path.isdir(item):
            results += generate_json_for_folder(os.path.join(path, item), base_url)
        else:
            files.append(item)
    
    tja_files = [x for x in files if x.lower().endswith(".tja")]
    if len(tja_files) >= 1:
        music_files = [x for x in files if x.lower().endswith(".mp3") or x.lower().endswith(".ogg")]
        if len(music_files) >= 1:
            tja_file = sorted(tja_files)[0]
            music_file = sorted(music_files)[0]
            results.append(generate_json_for_file(path, base_url, tja_file, music_file))
        else:
            print(f"[!] Found a TJA file in {path}, but no music files", file=sys.stderr)
        
        if len(music_files) > 1:
            print(f"[-] {len(music_files)} music files in {path}, but only one expected: {', '.join(music_files)}", file=sys.stderr)
    
        if len(tja_files) > 1:
            print(f"[-] {len(tja_files)} .tja files in {path}, but only one expected:  {', '.join(tja_files)}", file=sys.stderr)
        

    return results


def get_tja_metadata_or_default(lines: list[str], field_name: str, default: str) -> str:
    prefix = field_name.lower() + ":"
    for line in lines:
        if line.lower().startswith(prefix):
            return line[len(prefix):]
    return default


def get_tja_difficulties(lines: list[str]) -> tuple[int,int]:
    course = -1
    level = -1
    results = []

    for line in lines:
        line = line.lower().strip()
        if line == "#start":
            # This starts the notes defining a chart and should be below the chart's metadata. This way we should be safe from multiple level/course definitions from the same chart
            if course != -1 and level != -1:
                results.append((course, level))
            else:
                print(f"[-] Missing metadata: (course={course}, level={level})", file=sys.stderr)

            course = -1
            level = -1
        elif line.startswith("course:"):
            course_str = line[len("course:"):]
            try:
                course = int(course_str)
            except Exception:
                # SEE https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#course
                course = {
                    "easy": 0,
                    "normal": 1,
                    "hard": 2,
                    "oni": 3,
                    "edit": 4,
                    "ura": 4,
                    "tower": 5,
                    "dan": 6,
                }.get(course_str, 3)
        elif line.startswith("level"):
            level_str = line[len("level:"):]
            try:
                level = int(level_str)
            except Exception:
                print("[-] Could not parse level as integer:", level_str, file=sys.stderr)
    
    return results


def generate_json_for_file(directory_path: str, base_url: str, tja_file: str, music_file: str) -> dict:
    with open(os.path.join(directory_path, tja_file)) as f:
        tja_lines = f.read().splitlines()

    title = get_tja_metadata_or_default(tja_lines, "TITLE", "Unknown title")
    artist = get_tja_metadata_or_default(tja_lines, "SUBTITLE", "Unknown artist")
    difficulties = [{"course": course, "level": level} for course, level in get_tja_difficulties(tja_lines)]

    return {
        "title": title,
        "artist": artist,
        "music": {
            "url": os.path.join(base_url, quote(directory_path), quote(music_file)),
            "path": music_file,
        },
        "charts": {
            "url": os.path.join(base_url, quote(directory_path), quote(tja_file)),
            "path": tja_file,
        },
        "difficulties": difficulties,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-u", "--url", required=True, help="prefix of the download URL. For example https://git.example.com/username/repository/raw/branch/master/")
    ap.add_argument("-d", "--directory", required=True, help="path to the local directory")
    args = ap.parse_args()

    os.chdir(args.directory)

    json_data = {
        "game": "taiko",
        "directory_name": os.path.basename(args.directory),
        "songs": generate_json_for_folder(".", args.url)
    }
    
    print(json.dumps(json_data, indent=4))


if __name__ == "__main__":
    main()
