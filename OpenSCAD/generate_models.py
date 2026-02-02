import subprocess
import os
import sys
import shutil
import json
import glob

# --- Configuration ---
OPENSCAD_PATH_HINTS = [
    r"C:\Program Files\OpenSCAD\openscad.exe",
    r"C:\Program Files (x86)\OpenSCAD\openscad.exe",
    "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD", # macOS
    "/usr/bin/openscad", # Linux
]

OUTPUT_DIR = "output"
CONFIG_DIR = "configs"
SCAD_FILE = "Cullenect.scad"

# ---------------------

def find_openscad():
    # Check PATH first
    path = shutil.which("openscad")
    if path:
        return path
    
    # Check hints
    for hint in OPENSCAD_PATH_HINTS:
        if os.path.exists(hint):
            return hint
    
    return None

def load_configs():
    configs = []
    if not os.path.exists(CONFIG_DIR):
        print(f"Warning: Config directory '{CONFIG_DIR}' not found.")
        return configs
        
    json_files = glob.glob(os.path.join(CONFIG_DIR, "*.json"))
    for f in json_files:
        try:
            with open(f, 'r') as file:
                config = json.load(file)
                # If filename not in config, use the json filename
                if "filename" not in config:
                    base = os.path.basename(f)
                    config["filename"] = os.path.splitext(base)[0]
                configs.append(config)
        except Exception as e:
            print(f"Error reading config {f}: {e}")
            
    return configs

import argparse

def generate_model(openscad_bin, model_config, output_format="stl"):
    filename = model_config.get("filename", "unknown_model")
    variables = model_config.get("vars", {})
    
    # Strip existing extension if present and irrelevant
    base_name = os.path.splitext(filename)[0]
    filename_with_ext = f"{base_name}.{output_format}"
        
    output_path = os.path.join(OUTPUT_DIR, filename_with_ext)
    
    print(f"Generating {output_path}...")
    
    # Build command
    cmd = [openscad_bin, "-o", output_path]
    
    # Add variable overrides
    for key, value in variables.items():
        if isinstance(value, str):
             if value.lower() == "true" or value.lower() == "false":
                 cmd.append(f"-D{key}={value}")
             else:
                 cmd.append(f'-D{key}="{value}"')
        else:
            cmd.append(f"-D{key}={value}")
            
    cmd.append(SCAD_FILE)
    
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error generating {filename_with_ext}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Batch generate OpenSCAD models.")
    parser.add_argument("--format", type=str, default="stl", help="Output format (stl, 3mf, step, etc.)", choices=["stl", "3mf", "step", "obj", "off", "dxf", "svg", "png", "echo", "ast", "term", "csg"])
    parser.add_argument("--jobs", "-j", type=int, default=os.cpu_count(), help="Number of parallel jobs (default: CPU count)")
    args = parser.parse_args()

    # 1. Find OpenSCAD
    openscad = find_openscad()
    if not openscad:
        print("Error: OpenSCAD executable not found. Please add it to your PATH or update OPENSCAD_PATH_HINTS in the script.")
        sys.exit(1)
    print(f"Using OpenSCAD: {openscad}")

    # 2. Prepare Output Directory
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"Created output directory: {OUTPUT_DIR}")

    # 3. Load Configs
    models = load_configs()
    if not models:
        print("No configurations found. Add .json files to the 'configs' directory.")
        return

    print(f"Found {len(models)} configurations. Generating as .{args.format} with {args.jobs} jobs...")

    # 4. Generate Models (Parallel)
    import concurrent.futures
    import functools

    # Create a partial function with fixed arguments
    worker = functools.partial(generate_model, openscad, output_format=args.format)

    with concurrent.futures.ProcessPoolExecutor(max_workers=args.jobs) as executor:
        # Submit all tasks
        futures = [executor.submit(worker, model) for model in models]
        
        # Wait for completion and handle errors
        for future in concurrent.futures.as_completed(futures):
            try:
                future.result()
            except Exception as e:
                print(f"Job failed: {e}")
        
    print("\nBatch generation complete!")

if __name__ == "__main__":
    main()
