# Cullenect Labels

A configurable 3D printable label system for Gridfinity bins (and more), powered by OpenSCAD.

## Usage

### 1. Manual Generation (OpenSCAD)
Open `Cullenect.scad` in OpenSCAD. Use the Customizer (Window > Customizer) to adjust settings.

#### Key Parameters

**General Settings**
*   `Select_Output`: Choose what to render (Label, Socket Test, etc.).
*   `label_width`: Width in Gridfinity units (default: 1).
*   `label_surface`: Style of the label (Emboss, Deboss, Flush).
*   `Text_Color`: Color of the text/icon (for multi-color prints).

**Label Text**
*   `Text1` / `Text2`: Content of the left and right text fields.
*   `Text1_Align` / `Text2_Align`: Alignment (left, center, right).

**Fastener Icon**
*   `Show_Fastener`: Enable/Disable the fastener icon.
*   `Fastener_Head`: Type of head (socket, countersunk, pan, etc.).
*   `Fastener_Driver`: Type of driver (phillips, hex, torx, etc.).
*   `Fastener_View`: **[NEW]** Select "side" (default) or "top" (head-on view).

**Hardware Icon**
*   `Select_Hardware`: Choose a secondary hardware icon (washer, nut, magnet, etc.) to display alongside the fastener.

### 2. Automated Generation (Python)

A Python script `generate_models.py` is provided to batch generate models from JSON configuration files.

#### Requirements
*   Python 3.x
*   OpenSCAD (installed and in your PATH, or in a standard location)

#### Quick Start
1.  Define your models in JSON files inside the `configs/` directory.
2.  Run the script:
    ```bash
    python generate_models.py
    ```
3.  Find your files in the `output/` directory.

#### Config Format
Create a `.json` file in `configs/` (e.g., `my_label.json`):
```json
{
    "filename": "My_Custom_Label",
    "vars": {
        "Text1": "M3",
        "Select_Hardware": "washer",
        "Fastener_View": "top",
        "Show_Fastener": "true"
    }
}
```
*   `filename`: Output filename (extensions added automatically).
*   `vars`: Dictionary of OpenSCAD variables to override.

#### Command Line Options
```bash
python generate_models.py [options]
```

*   `--format [fmt]`: Output format. Supported: `stl` (default), `3mf`, `step`, `png`, etc.
    *   Example: `python generate_models.py --format 3mf`
*   `--jobs [n]`: Number of parallel jobs. Defaults to your CPU core count.
    *   Example: `python generate_models.py -j 4`
