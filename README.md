## Shot Exporter

A batch script for exporting a directory of image sequences into individual video shots.

The script scans a project directory for image-sequence folders and generates an MP4 file for each sequence.

---

### Usage

Run the batch file and point it at your project directory:

    ExportAllShots.bat "C:\Users\Name\Desktop\ProjectDir"

If no directory is provided, the script defaults to the current working directory.

---

### Expected Directory Structure

Your project directory must follow this layout:

    ProjectDir/
    ├─ ImageSequences/
    │  ├─ Shot1_sequence/
    │  │  ├─ Shot1_0001.jpg
    │  │  ├─ Shot1_0002.jpg
    │  │  ├─ Shot1_0003.jpg
    │  │  └─ ...
    │  ├─ Shot2_sequence/
    │  │  ├─ Shot2_0001.jpg
    │  │  └─ ...
    │  └─ Shot3_sequence/
    │     └─ ...
    │
    └─ FOR-DAVINCI/
       └─ videos/

---

### Naming Rules

- Each sequence folder must be named:
      ShotX_sequence

- Image files inside must be named:
      ShotX_0001.jpg
      ShotX_0002.jpg
      ...

- Numbering must start at 0001 and be continuous.

---

### Output

For each ShotX_sequence folder, the script generates:

    FOR-DAVINCI/videos/ShotX.mp4

Example outputs:

    FOR-DAVINCI/videos/Shot1.mp4
    FOR-DAVINCI/videos/Shot2.mp4
    FOR-DAVINCI/videos/Shot3.mp4

---

### Summary

- Finds all folders matching:
      ImageSequences\Shot*_sequence

- Encodes each image sequence into an MP4

- Saves all MP4 files into:
      FOR-DAVINCI/videos/
