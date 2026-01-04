import os

title = input("Enter post title to add media for: ")

slug = title.lower().strip().replace(" ", "-")

script_location = os.path.dirname(os.path.abspath(__file__))
base_dir = os.path.dirname(script_location)
media_path = os.path.join(base_dir, "static", "posts", "media", slug)
makefile_path = os.path.join(base_dir, "Makefile")

media_files = os.listdir(media_path)

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
            for file in media_files:
                media_build_line = f"\tcat static/posts/media/{file} > site/blog/posts/media/{slug}/{file}\n"
                lines.insert(insertion_index - 1, media_build_line)
        else:
            for file in media_files:
                media_build_line = f"\tcat static/posts/media/{file} > site/blog/posts/media/{slug}/{file}\n"
                lines.insert(insertion_index, media_build_line)

        with open(makefile_path, "w") as f:
            f.writelines(lines)
        print("Success!")
        print("- Added media files to Makefile")
    else:
        print(
            "Warning: Could not find the '.PHONY: all' tag in Makefile. Skipped update"
        )

except Exception as e:
    print(f"Error updating Makefile: {e}")
