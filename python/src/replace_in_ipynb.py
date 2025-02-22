import os
import sys
import json
import nbformat

# Define the replacement dictionary: {'text_to_find': 'text_to_replace'}
REPLACEMENTS = {
    "old_text1": "new_text1",
    "old_text2": "new_text2",
    # Add more replacements as needed
}

def process_notebook(file_path):
    """Opens a .ipynb file, replaces text based on REPLACEMENTS dictionary, and saves it back."""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            notebook = nbformat.read(f, as_version=4)

        modified = False
        for cell in notebook["cells"]:
            if cell["cell_type"] in {"code", "markdown"}:
                cell_source = cell["source"]
                for old_text, new_text in REPLACEMENTS.items():
                    if old_text in cell_source:
                        cell["source"] = cell_source.replace(old_text, new_text)
                        modified = True
        
        if modified:
            with open(file_path, "w", encoding="utf-8") as f:
                nbformat.write(notebook, f)
            print(f"Updated: {file_path}")
        else:
            print(f"No changes: {file_path}")

    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def search_and_replace_in_folders(folders):
    """Searches for .ipynb files in given folders and applies replacements."""
    for folder in folders:
        if not os.path.isdir(folder):
            print(f"Skipping: {folder} (Not a valid directory)")
            continue

        for root, _, files in os.walk(folder):
            for file in files:
                if file.endswith(".ipynb"):
                    process_notebook(os.path.join(root, file))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python replace_in_ipynb.py <folder1> <folder2> ...")
        sys.exit(1)

    directories = sys.argv[1:]
    search_and_replace_in_folders(directories)
