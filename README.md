# NeoTempleOS

<p align="center">
  <img src="images/banner.png" alt="NeoTempleOS Banner" width="600">
</p>

<p align="center">
  <strong>🔥 The Divine Brainrot Experience 🔥</strong>
</p>

<p align="center">
  <em>"Skibidi dop dop yes yes" - God, probably</em>
</p>

---

[![Build NeoTempleOS](https://github.com/YOURUSERNAME/NeoTempleOS/actions/workflows/build-noble.yml/badge.svg)](https://github.com/YOURUSERNAME/NeoTempleOS/actions/workflows/build-noble.yml)

## What is NeoTempleOS?

NeoTempleOS is a meme operating system based on Ubuntu that **fights back**. Every interaction is designed to be chaotic, funny, and absolutely unhinged.

Inspired by:
- 🚽 Skibidi Toilet
- 🇮🇹 Italian Brainrot (Tralalero Tralala)
- 🎮 Getting Over It with Bennett Foddy (narrator style)
- ⛪ The original TempleOS by Terry Davis
- 💀 Gen Alpha/Gen Z internet culture

## Features

### 🎵 Calculator with Divine Music
Open the calculator and enjoy a heavenly music loop that **cannot be stopped**. Close the calculator to end your suffering.

### 📢 Random Narrator Quotes
Every 5-15 minutes, receive divine wisdom:
- "Only in Ohio would this happen."
- "Nah, I'd win."
- "You're glazing yourself right now."
- "Stand proud. You are strong."
- "The Rizzler has noticed you."

### 🔊 Custom Sound Effects
- **Metal Pipe** on errors
- **Vine Boom** on achievements
- Custom sounds on app launch

### 🖼️ Meme Wallpapers
Default desktop featuring the finest brainrot imagery.

### 💻 Custom Terminal Greeting
Every time you open the terminal, receive a divine message.

### 🎨 Dark Theme
Because we live in a society.

## Installation

### Method 1: Download Pre-built ISO
1. Go to [Releases](https://github.com/YOURUSERNAME/NeoTempleOS/releases)
2. Download the latest `.iso` file
3. Create bootable USB with [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/)
4. Boot from USB
5. Select "Install NeoTempleOS"

### Method 2: Build from Source
```bash
# Clone the repo
git clone https://github.com/YOURUSERNAME/NeoTempleOS.git
cd NeoTempleOS

# Add your custom assets
# - Place sounds in assets/sounds/
# - Place images in assets/images/

# Build (requires Ubuntu/Debian host)
cd scripts
./build.sh -

# ISO will be created as scripts/NeoTempleOS.iso
```

## Adding Custom Content

### Custom Sounds
Add `.ogg` files to `assets/sounds/`:
- `calculator-music.ogg` - Loops while calculator is open
- `notification.ogg` - Plays with narrator quotes
- `metal-pipe.ogg` - Error sound
- `vine-boom.ogg` - Success sound

### Custom Wallpaper
Add `wallpaper.jpg` to `assets/images/` (1920x1080 or higher recommended)

### Custom Quotes
Edit `scripts/config.sh` and modify the quotes in Section 7.

## File Structure

```
NeoTempleOS/
├── .github/workflows/     # GitHub Actions for ISO builds
├── assets/
│   ├── sounds/            # Your sound effects (.ogg)
│   └── images/            # Wallpapers and images
├── scripts/
│   ├── config.sh          # Your customizations
│   ├── default_config.sh  # Default config (don't modify)
│   ├── build.sh           # Main build script
│   └── chroot_build.sh    # Chroot build script
└── images/                # README images
```

## CI/CD Workflow

1. Push code or create a tag
2. GitHub Actions builds the ISO (~30-60 mins)
3. Download from Artifacts or Releases

### Creating a Release
```bash
git tag v1.0
git push origin v1.0
# GitHub Actions will create a release with the ISO
```

## Requirements

To build locally:
- Ubuntu or Debian host system
- ~20GB free disk space
- ~4GB RAM
- Internet connection

## Contributing

1. Fork the repo
2. Add your brainrot modifications
3. Submit a PR
4. Get rejected because your memes aren't dank enough
5. Try again

## License

GPL-3.0 - Because even divine software should be free.

## Credits

- **Base System**: Ubuntu (Canonical)
- **Build System**: [mvallim/live-custom-ubuntu-from-scratch](https://github.com/mvallim/live-custom-ubuntu-from-scratch)
- **Inspiration**: Terry Davis, Gen Alpha, the entire internet
- **Divine Guidance**: Skibidi Toilet, The Rizzler, Wise Mystical Tree

---

<p align="center">
  <strong>Remember: This is a meme OS. Use at your own risk.</strong>
</p>

<p align="center">
  <em>NeoTempleOS is not responsible for any brainrot induced by using this operating system.</em>
</p>
