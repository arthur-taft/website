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
