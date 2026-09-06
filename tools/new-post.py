#!/usr/bin/env python3
"""Scaffold a new blog post.

Creates content/posts/<slug>.adoc and static/blog/posts/media/<slug>/.
Nothing else needs touching: the Makefile picks the post up by wildcard and
posts.json is regenerated from the document header at build time.
"""

import os
import pathlib
import re
import sys
from datetime import date

BASE = pathlib.Path(__file__).resolve().parent.parent

TEMPLATE = """= {title}
:date: {date}
:summary: TODO: write a summary...

Write your content for {title} here.
"""


def main():
    title = input("Enter new post title: ").strip()

    if not title:
        print("A title is required.", file=sys.stderr)
        return 1

    slug = re.sub(r"[^\w-]", "", title.lower().replace(" ", "-"))
    adoc = BASE / "content" / "posts" / f"{slug}.adoc"
    media = BASE / "static" / "blog" / "posts" / "media" / slug

    if adoc.exists():
        print(f"{adoc} already exists.", file=sys.stderr)
        return 1

    adoc.parent.mkdir(parents=True, exist_ok=True)
    adoc.write_text(
        TEMPLATE.format(title=title, date=date.today().isoformat()),
        encoding="utf-8",
    )
    media.mkdir(parents=True, exist_ok=True)

    print("\nSuccess! Created new post:")
    print(f"- {adoc.relative_to(BASE)}")
    print(f"- {media.relative_to(BASE)}/")
    print("\nDrop images in that media directory and reference them as:")
    print(f"  image::/blog/posts/media/{slug}/example.png[alt text]")
    print("\nThen run 'make build'. No Makefile edits needed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
