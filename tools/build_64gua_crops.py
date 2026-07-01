from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
PAGE_DIR = ROOT / "outputs" / "64gua_pages"
OUT_DIR = ROOT / "outputs" / "64gua_yaoci_images"
SWIFT_OCR = ROOT / "tools" / "vision_ocr.swift"
MODULE_CACHE = ROOT / "outputs" / "swift-module-cache"

OCR_BOX = (250, 160, 700, 600)
CROP_BOX = (300, 735, 895, 1073)

HEXAGRAM_NAMES = [
    "乾为天",
    "坤为地",
    "水雷屯",
    "山水蒙",
    "水天需",
    "天水讼",
    "地水师",
    "水地比",
    "风天小畜",
    "天泽履",
    "地天泰",
    "天地否",
    "天火同人",
    "火天大有",
    "地山谦",
    "雷地豫",
    "泽雷随",
    "山风蛊",
    "地泽临",
    "风地观",
    "火雷噬嗑",
    "山火贲",
    "山地剥",
    "地雷复",
    "天雷无妄",
    "山天大畜",
    "山雷颐",
    "泽风大过",
    "坎为水",
    "离为火",
    "泽山咸",
    "雷风恒",
    "天山遁",
    "雷天大壮",
    "火地晋",
    "地火明夷",
    "风火家人",
    "火泽睽",
    "水山蹇",
    "雷水解",
    "山泽损",
    "风雷益",
    "泽天夬",
    "天风姤",
    "泽地萃",
    "地风升",
    "泽水困",
    "水风井",
    "泽火革",
    "火风鼎",
    "震为雷",
    "艮为山",
    "风山渐",
    "雷泽归妹",
    "雷火丰",
    "火山旅",
    "巽为风",
    "兑为泽",
    "风水涣",
    "水泽节",
    "风泽中孚",
    "雷山小过",
    "水火既济",
    "火水未济",
]

OCR_ALIASES = {
    "山天大蓄": "山天大畜",
    "无安": "天雷无妄",
}

SHORT_TO_CANONICAL = {
    "乾": "乾为天",
    "坤": "坤为地",
    "坎": "坎为水",
    "离": "离为火",
    "震": "震为雷",
    "艮": "艮为山",
    "巽": "巽为风",
    "兑": "兑为泽",
}
for _name in HEXAGRAM_NAMES:
    if "为" not in _name:
        SHORT_TO_CANONICAL[_name[2:]] = _name


def normalize(text: str) -> str:
    return re.sub(r"[^\u4e00-\u9fff]", "", text)


def ocr_page(page_path: Path) -> str:
    cmd = [
        "swift",
        "-module-cache-path",
        str(MODULE_CACHE),
        str(SWIFT_OCR),
        str(page_path),
        *(str(v) for v in OCR_BOX),
    ]
    return subprocess.check_output(cmd, text=True)


def find_hexagram_name(ocr_text: str, used: set[str]) -> str:
    normalized = normalize(ocr_text)
    for alias, canonical in OCR_ALIASES.items():
        if alias in normalized and canonical not in used:
            return canonical
    matches = [name for name in HEXAGRAM_NAMES if name in normalized]
    unused_matches = [name for name in matches if name not in used]
    if unused_matches:
        return unused_matches[0]
    if matches:
        return matches[0]
    short_matches = []
    for short_name, canonical in SHORT_TO_CANONICAL.items():
        if canonical in used:
            continue
        count = normalized.count(short_name)
        if count:
            short_matches.append((count, len(short_name), canonical))
    if short_matches:
        short_matches.sort(reverse=True)
        return short_matches[0][2]
    raise ValueError(f"could not identify hexagram name from OCR:\n{ocr_text}")


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    MODULE_CACHE.mkdir(parents=True, exist_ok=True)

    pages = sorted(PAGE_DIR.glob("page-*.png"))
    if len(pages) != 64:
        raise SystemExit(f"expected 64 rendered pages, found {len(pages)}")

    manifest = []
    used: set[str] = set()

    for index, page_path in enumerate(pages, start=1):
        ocr_text = ocr_page(page_path)
        name = find_hexagram_name(ocr_text, used)
        used.add(name)

        with Image.open(page_path) as image:
            crop = image.crop(CROP_BOX)
            output_path = OUT_DIR / f"{name}.png"
            crop.save(output_path)

        manifest.append(
            {
                "page": index,
                "source": page_path.name,
                "name": name,
                "output": output_path.name,
            }
        )
        print(f"{index:02d}: {name}")

    missing = [name for name in HEXAGRAM_NAMES if name not in used]
    (OUT_DIR / "_manifest.json").write_text(
        json.dumps({"count": len(manifest), "missing": missing, "items": manifest}, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    if missing:
        raise SystemExit("missing hexagrams: " + ", ".join(missing))


if __name__ == "__main__":
    main()
