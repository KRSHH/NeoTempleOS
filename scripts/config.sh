#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           NEO TEMPLE OS                                       ║
# ║                    "The Divine Brainrot Experience"                           ║
# ║                                                                               ║
# ║  MVP: Calculator with divine music that cannot be stopped.                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Ubuntu 24.04 LTS (Noble Numbat)
export TARGET_UBUNTU_VERSION="noble"

# Mirror for faster downloads
export TARGET_UBUNTU_MIRROR="http://us.archive.ubuntu.com/ubuntu/"

# Standard kernel
export TARGET_KERNEL_PACKAGE="linux-generic"

# OS Name - appears in ISO filename and GRUB
export TARGET_NAME="NeoTempleOS"

# GRUB Menu Labels
export GRUB_LIVEBOOT_LABEL="Experience the Divine Brainrot"
export GRUB_INSTALL_LABEL="Install NeoTempleOS (No Going Back)"

# Packages to remove after installation
export TARGET_PACKAGE_REMOVE="
    ubiquity \
    casper \
    discover \
    laptop-detect \
    os-prober \
"

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         CUSTOMIZE IMAGE FUNCTION                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
function customize_image() {
    echo "══════════════════════════════════════════════════════════════"
    echo "   INSTALLING NEO TEMPLE OS - CALCULATOR MUSIC EDITION        "
    echo "══════════════════════════════════════════════════════════════"

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 1: DESKTOP ENVIRONMENT
    # ═══════════════════════════════════════════════════════════════════
    apt-get install -y \
        ubuntu-gnome-desktop

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 2: AUDIO (for meme sounds)
    # ═══════════════════════════════════════════════════════════════════
    apt-get install -y \
        pulseaudio \
        pulseaudio-utils \
        xdotool

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 3: REMOVE BLOATWARE
    # ═══════════════════════════════════════════════════════════════════
    apt-get purge -y \
        transmission-gtk \
        transmission-common \
        gnome-mahjongg \
        gnome-mines \
        gnome-sudoku \
        aisleriot \
        hitori || true

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 4: CREATE DIRECTORIES & COPY SOUNDS
    # ═══════════════════════════════════════════════════════════════════
    mkdir -p /usr/share/neotempleos/sounds
    mkdir -p /usr/local/bin

    # Copy sounds from assets
    if [[ -d "/root/assets/sounds" ]]; then
        cp -r /root/assets/sounds/* /usr/share/neotempleos/sounds/ || true
    fi

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 5: CALCULATOR WITH LOOPING MUSIC
    # ═══════════════════════════════════════════════════════════════════
    cat <<'CALC_SCRIPT' > /usr/local/bin/neotempleos-calculator
#!/bin/bash
# NeoTempleOS Calculator - Divine music with focus-aware volume

SOUND_FILE="/usr/share/neotempleos/sounds/calculator.flac"
VOLUME_FOCUSED=100      # Volume when calculator is focused (%)
VOLUME_UNFOCUSED=40     # Volume when calculator loses focus (%)

# Start music loop in background
if [[ -f "$SOUND_FILE" ]]; then
    (
        while true; do
            paplay "$SOUND_FILE" 2>/dev/null
            sleep 0.1
        done
    ) &
    LOOP_PID=$!
fi

# Start focus monitor in background
(
    CALC_PID=$$
    while kill -0 $CALC_PID 2>/dev/null; do
        # Get the active window name
        ACTIVE_WINDOW=$(xdotool getactivewindow getwindowname 2>/dev/null || echo "")
        
        # Check if calculator is focused
        if [[ "$ACTIVE_WINDOW" == *"Calculator"* ]]; then
            # Focused - full volume
            pactl set-sink-input-volume @DEFAULT_SINK@ ${VOLUME_FOCUSED}% 2>/dev/null || \
            pactl set-sink-volume @DEFAULT_SINK@ ${VOLUME_FOCUSED}% 2>/dev/null
        else
            # Not focused - reduce volume
            pactl set-sink-input-volume @DEFAULT_SINK@ ${VOLUME_UNFOCUSED}% 2>/dev/null || \
            pactl set-sink-volume @DEFAULT_SINK@ ${VOLUME_UNFOCUSED}% 2>/dev/null
        fi
        
        sleep 0.5
    done
) &
FOCUS_PID=$!

# Run the actual calculator (blocks until closed)
gnome-calculator "$@"

# Calculator closed - cleanup
if [[ -n "$LOOP_PID" ]]; then
    kill $LOOP_PID 2>/dev/null
    pkill -P $LOOP_PID 2>/dev/null
fi
if [[ -n "$FOCUS_PID" ]]; then
    kill $FOCUS_PID 2>/dev/null
fi

# Restore volume to normal
pactl set-sink-volume @DEFAULT_SINK@ 100% 2>/dev/null
CALC_SCRIPT
    chmod +x /usr/local/bin/neotempleos-calculator

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 6: OVERRIDE CALCULATOR DESKTOP ENTRY
    # ═══════════════════════════════════════════════════════════════════
    cat <<'CALC_DESKTOP' > /usr/share/applications/org.gnome.Calculator.desktop
[Desktop Entry]
Name=Calculator
Comment=Perform arithmetic, scientific or financial calculations
Exec=/usr/local/bin/neotempleos-calculator
Icon=org.gnome.Calculator
Terminal=false
Type=Application
Categories=GNOME;GTK;Utility;Calculator;
StartupNotify=true
CALC_DESKTOP

    echo "══════════════════════════════════════════════════════════════"
    echo "   NEO TEMPLE OS - CALCULATOR MUSIC READY                     "
    echo "══════════════════════════════════════════════════════════════"
}

# Config file version - must match expected version in build scripts
export CONFIG_FILE_VERSION="0.4"
