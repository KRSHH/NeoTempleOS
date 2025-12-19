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
VOLUME_UNFOCUSED=70     # Volume when calculator loses focus (%)

# Create a unique marker for our paplay process
MARKER="neotempleos_calc_$$"

# Cleanup function to kill all our processes
cleanup() {
    # Kill all paplay processes playing our file
    pkill -f "paplay.*calculator.flac" 2>/dev/null
    # Also try killing by the specific sound file
    killall paplay 2>/dev/null
    # Restore volume
    pactl set-sink-volume @DEFAULT_SINK@ 100% 2>/dev/null
    exit 0
}

# Set trap to cleanup on exit
trap cleanup EXIT INT TERM

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
    while true; do
        # Get the active window name
        ACTIVE_WINDOW=$(xdotool getactivewindow getwindowname 2>/dev/null || echo "")
        
        # Check if calculator is focused
        if [[ "$ACTIVE_WINDOW" == *"Calculator"* ]]; then
            # Focused - full volume
            pactl set-sink-volume @DEFAULT_SINK@ ${VOLUME_FOCUSED}% 2>/dev/null
        else
            # Not focused - reduce volume
            pactl set-sink-volume @DEFAULT_SINK@ ${VOLUME_UNFOCUSED}% 2>/dev/null
        fi
        
        sleep 0.3
    done
) &
FOCUS_PID=$!

# Run the actual calculator (blocks until closed)
gnome-calculator "$@"

# Calculator closed - cleanup runs via trap
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

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 7: OS IDENTITY - Change Ubuntu to NeoTempleOS EVERYWHERE
    # ═══════════════════════════════════════════════════════════════════
    
    # /etc/os-release - Main OS identification (used by neofetch, hostnamectl, etc)
    cat <<'OSRELEASE' > /etc/os-release
PRETTY_NAME="NeoTempleOS 1.0 (Divine Brainrot)"
NAME="NeoTempleOS"
VERSION_ID="1.0"
VERSION="1.0 (Divine Brainrot)"
VERSION_CODENAME=brainrot
ID=neotempleos
ID_LIKE=ubuntu debian
HOME_URL="https://github.com/KRSHH/NeoTempleOS"
SUPPORT_URL="https://github.com/KRSHH/NeoTempleOS/issues"
BUG_REPORT_URL="https://github.com/KRSHH/NeoTempleOS/issues"
UBUNTU_CODENAME=noble
OSRELEASE

    # /etc/lsb-release - LSB distribution info
    cat <<'LSBRELEASE' > /etc/lsb-release
DISTRIB_ID=NeoTempleOS
DISTRIB_RELEASE=1.0
DISTRIB_CODENAME=brainrot
DISTRIB_DESCRIPTION="NeoTempleOS 1.0 (Divine Brainrot)"
LSBRELEASE

    # /etc/issue - Pre-login console message
    cat <<'ISSUE' > /etc/issue
NeoTempleOS 1.0 \n \l

ISSUE

    # /etc/issue.net - Network pre-login
    echo "NeoTempleOS 1.0 - The Divine Brainrot Experience" > /etc/issue.net

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 8: PLYMOUTH BOOT SPLASH
    # ═══════════════════════════════════════════════════════════════════
    
    mkdir -p /usr/share/plymouth/themes/neotempleos

    # Plymouth theme config
    cat <<'PLYMOUTH_CONF' > /usr/share/plymouth/themes/neotempleos/neotempleos.plymouth
[Plymouth Theme]
Name=NeoTempleOS
Description=NeoTempleOS Boot Splash - Divine Brainrot Loading
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/neotempleos
ScriptFile=/usr/share/plymouth/themes/neotempleos/neotempleos.script
PLYMOUTH_CONF

    # Plymouth script (text-based boot animation)
    cat <<'PLYMOUTH_SCRIPT' > /usr/share/plymouth/themes/neotempleos/neotempleos.script
# NeoTempleOS Plymouth Boot Script
Window.SetBackgroundTopColor(0.05, 0.05, 0.05);
Window.SetBackgroundBottomColor(0.0, 0.0, 0.0);

# Title text
title_text = "N E O T E M P L E O S";
title_image = Image.Text(title_text, 1, 1, 1, 1, "Sans Bold 32");
title_sprite = Sprite(title_image);
title_sprite.SetX(Window.GetWidth() / 2 - title_image.GetWidth() / 2);
title_sprite.SetY(Window.GetHeight() / 2 - 50);

# Subtitle
subtitle_text = "The Divine Brainrot Experience";
subtitle_image = Image.Text(subtitle_text, 0.7, 0.7, 0.7, 1, "Sans 16");
subtitle_sprite = Sprite(subtitle_image);
subtitle_sprite.SetX(Window.GetWidth() / 2 - subtitle_image.GetWidth() / 2);
subtitle_sprite.SetY(Window.GetHeight() / 2 + 10);

# Loading dots animation
dots = "";
dot_count = 0;

fun refresh_callback() {
    dot_count++;
    if (dot_count % 30 == 0) {
        if (String(dots).CharCount() >= 3)
            dots = "";
        else
            dots = dots + ".";
        
        loading_text = "Loading" + dots;
        loading_image = Image.Text(loading_text, 0.5, 0.5, 0.5, 1, "Sans 14");
        loading_sprite.SetImage(loading_image);
        loading_sprite.SetX(Window.GetWidth() / 2 - loading_image.GetWidth() / 2);
    }
}

loading_sprite = Sprite();
loading_sprite.SetY(Window.GetHeight() / 2 + 60);
Plymouth.SetRefreshFunction(refresh_callback);

# Message display
fun message_callback(text) {
    msg_image = Image.Text(text, 0.6, 0.6, 0.6, 1, "Sans 12");
    msg_sprite.SetImage(msg_image);
    msg_sprite.SetX(Window.GetWidth() / 2 - msg_image.GetWidth() / 2);
    msg_sprite.SetY(Window.GetHeight() - 50);
}
msg_sprite = Sprite();
Plymouth.SetMessageFunction(message_callback);
PLYMOUTH_SCRIPT

    # Set NeoTempleOS as default Plymouth theme
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
        /usr/share/plymouth/themes/neotempleos/neotempleos.plymouth 200 || true
    update-alternatives --set default.plymouth \
        /usr/share/plymouth/themes/neotempleos/neotempleos.plymouth || true

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 9: GDM LOGIN SCREEN BRANDING
    # ═══════════════════════════════════════════════════════════════════
    
    mkdir -p /etc/dconf/profile
    mkdir -p /etc/dconf/db/gdm.d

    # GDM dconf profile
    cat <<'GDM_PROFILE' > /etc/dconf/profile/gdm
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
GDM_PROFILE

    # GDM settings
    cat <<'GDM_SETTINGS' > /etc/dconf/db/gdm.d/01-neotempleos
[org/gnome/login-screen]
banner-message-enable=true
banner-message-text='Welcome to NeoTempleOS\nThe Divine Brainrot Experience'
disable-user-list=false
GDM_SETTINGS

    # Update dconf database
    dconf update || true

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 10: NEOFETCH CUSTOM CONFIG
    # ═══════════════════════════════════════════════════════════════════
    
    mkdir -p /etc/skel/.config/neofetch
    cat <<'NEOFETCH_CONF' > /etc/skel/.config/neofetch/config.conf
# NeoTempleOS Neofetch Configuration
print_info() {
    info title
    info underline
    prin "OS" "NeoTempleOS 1.0 (Divine Brainrot)"
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "WM" wm
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
    info cols
    prin ""
    prin "「 Divine Brainrot Mode: ACTIVE 」"
}

# Use custom ASCII
ascii_distro="auto"
NEOFETCH_CONF

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 11: MOTD (Message of the Day)
    # ═══════════════════════════════════════════════════════════════════
    
    # Remove Ubuntu MOTD scripts
    rm -f /etc/update-motd.d/* 2>/dev/null || true

    # Create NeoTempleOS MOTD
    cat <<'MOTD_SCRIPT' > /etc/update-motd.d/00-neotempleos
#!/bin/bash
echo ""
echo "███╗   ██╗███████╗ ██████╗ ████████╗███████╗███╗   ███╗██████╗ ██╗     ███████╗ ██████╗ ███████╗"
echo "████╗  ██║██╔════╝██╔═══██╗╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔════╝██╔═══██╗██╔════╝"
echo "██╔██╗ ██║█████╗  ██║   ██║   ██║   █████╗  ██╔████╔██║██████╔╝██║     █████╗  ██║   ██║███████╗"
echo "██║╚██╗██║██╔══╝  ██║   ██║   ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  ██║   ██║╚════██║"
echo "██║ ╚████║███████╗╚██████╔╝   ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗███████╗╚██████╔╝███████║"
echo "╚═╝  ╚═══╝╚══════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝ ╚═════╝ ╚══════╝"
echo ""
echo "                         The Divine Brainrot Experience - v1.0"
echo '                         "Skibidi dop dop yes yes" - God, probably'
echo ""
MOTD_SCRIPT
    chmod +x /etc/update-motd.d/00-neotempleos

    # Static MOTD fallback
    cat <<'STATIC_MOTD' > /etc/motd

    ╔═══════════════════════════════════════════════════════════════════╗
    ║                      N E O T E M P L E O S                         ║
    ║                   The Divine Brainrot Experience                   ║
    ╚═══════════════════════════════════════════════════════════════════╝

STATIC_MOTD

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 12: HOSTNAME & SYSTEM IDENTITY
    # ═══════════════════════════════════════════════════════════════════
    
    echo "neotempleos" > /etc/hostname
    
    # dpkg origins
    cat <<'ORIGIN' > /etc/dpkg/origins/neotempleos
Vendor: NeoTempleOS
Vendor-URL: https://github.com/KRSHH/NeoTempleOS
Bugs: https://github.com/KRSHH/NeoTempleOS/issues
Parent: Ubuntu
ORIGIN
    ln -sf /etc/dpkg/origins/neotempleos /etc/dpkg/origins/default || true

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 13: TERMINAL GREETING
    # ═══════════════════════════════════════════════════════════════════
    
    cat <<'GREETING' > /etc/profile.d/neotempleos-greeting.sh
#!/bin/bash
QUOTES=(
    "Welcome back, divine one."
    "The compiler awaits your commands."
    "Skibidi dop dop... yes yes."
    "God's third temple runs on Linux now."
    "Only sigma males use the terminal."
    "What the shell are you doing here?"
    "Nah, you'll win. Probably."
)
RANDOM_QUOTE=${QUOTES[$RANDOM % ${#QUOTES[@]}]}
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               N E O T E M P L E O S  v1.0                     ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  $RANDOM_QUOTE"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
GREETING
    chmod +x /etc/profile.d/neotempleos-greeting.sh

    # ═══════════════════════════════════════════════════════════════════
    # SECTION 14: GNOME ABOUT PANEL OVERRIDE
    # ═══════════════════════════════════════════════════════════════════
    
    # Install neofetch
    apt-get install -y neofetch || true
    
    echo "══════════════════════════════════════════════════════════════"
    echo "   NEO TEMPLE OS - COMPLETE BRANDING APPLIED                  "
    echo "══════════════════════════════════════════════════════════════"
}

# Config file version - must match expected version in build scripts
export CONFIG_FILE_VERSION="0.4"
