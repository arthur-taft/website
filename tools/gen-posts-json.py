#!/usr/bin/env python3
"""Build posts.json from the AsciiDoc document headers in content/posts/.

Each post needs a header like:

    = Brutus Sherlock Writeup
    :date: 2026-01-03
    :summary: Writeup for the Brutus HTB Sherlock

Everything else (slug, url) is derived from the filename.
"""

import json
import pathlib
import sys


def read_header(path):
    """Pull the doctitle and attributes out of an AsciiDoc document header."""
    title = None
    attrs = {}

    with path.open(encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")

            # the header ends at the first blank line after the title
            if title is not None and not line.strip():
                break

            if title is None and line.startswith("= "):
                title = line[2:].strip()
            elif line.startswith(":") and ":" in line[1:]:
                name, _, value = line[1:].partition(":")
                attrs[name.strip()] = value.strip()

    return title, attrs


def main():
    src = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "content/posts")
    posts = []

    for path in sorted(src.glob("*.adoc")):
        title, attrs = read_header(path)

        if title is None:
            print(f"{path}: missing '= Title' header", file=sys.stderr)
            return 1

        if "date" not in attrs:
            print(f"{path}: missing ':date:' attribute", file=sys.stderr)
            return 1

        slug = path.stem
        posts.append(
            {
                "title": title,
                "date": attrs["date"],
                "summary": attrs.get("summary", ""),
                "slug": slug,
                "url": f"/blog/post/{slug}/",
            }
        )

    posts.sort(key=lambda p: p["date"], reverse=True)
    json.dump(posts, sys.stdout, indent=4)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
