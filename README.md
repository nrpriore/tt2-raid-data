# Tap Titans 2 – Raid Data

This repository hosts static raid balance data for the Tap Titans 2 raid simulator app.

The goal of this repo is to allow seasonal / balance updates to be delivered to users without requiring an App Store update.

All files are served via GitHub Pages and are intended to be fetched by the app at runtime.

---

## 📄 Data Files

All data files live under the `data/` directory and are plain text (`.txt`) files.

Each file contains delimited data that is parsed by the simulator.

### Files included
- `Skill.txt`
- `Level.txt`
- `Enemy.txt`
- `Area.txt`
- `RaidResearch.txt`
- `TitanResearch.txt`
- `GemstoneResearch.txt`

---

## 🧾 Manifest

The app checks `manifest.json` to determine whether the dataVersion has changed and then uses the computed hash per file to determine if any updates are needed.
