import json
import os
import re
from datetime import datetime
import time

title = input("Enter new post title: ")

slug = title.lower().strip()

slug = slug.replace(" ", "-")

slug = re.sub(r"[^\w-]", "", slug)

date_str = datetime.now().strftime("%Y-%m-%d")
post_id = int(time.time() * 1000)

md_filename = f"{slug}.md"

script_location = os.path.dirname(os.path.abspath(__file__))
base_dir = os.path.dirname(script_location)
json_path = os.path.join(base_dir, "static", "posts", "posts.json")
txt_path = os.path.join(base_dir, "static", "posts", md_filename)

try:
    with open(json_path, "r") as f:
        posts = json.load(f)
except FileNotFoundError:
    print("Error: Could not find static/posts/posts.json")
    exit(1)

new_post = {
    "id": post_id,
    "title": title,
    "date": date_str,
    "summary": "TODO: Write a summary...",
    "slug": slug,
    "content": f"/blog/posts/{md_filename}",
}

posts.insert(0, new_post)

with open(json_path, "w") as f:
    json.dump(posts, f, indent=4)

starter_text = f"Write your content for {title} here."

with open(txt_path, "w") as f:
    f.write(starter_text)

print("\nSuccess! Created new post:")
print("- Entry added to posts.json")
print(f"- File created: static/posts/{md_filename}")

print("Updating Makefile...")

makefile_path = os.path.join(base_dir, "Makefile")
new_build_line = f"\tcat static/posts/{md_filename} > site/blog/posts/{md_filename}\n"

try:
    with open(makefile_path, "r") as f:
        lines = f.readlines()

    insertion_index = -1

    for i, line in enumerate(lines):
        if line.strip().startswith(".PHONY: all"):
            insertion_index = i
            break

    if insertion_index != 1:
        if lines[insertion_index - 1].strip() == "":
            lines.insert(insertion_index - 1, new_build_line)
        else:
            lines.insert(insertion_index, new_build_line)

        with open(makefile_path, "w") as f:
            f.writelines(lines)
        print("- Added build instructions to Makefile")
    else:
        print(
            "Warning: Could not find the '.PHONY: all' tag in Makefile. Skipped update"
        )

except Exception as e:
    print(f"Error updating Makefile: {e}")
