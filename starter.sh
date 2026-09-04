#!/usr/bin/env bash

# 1. Gunakan $HOME agar lebih aman dan standar
BASE_DIR="$HOME"
SRC_DIR="$BASE_DIR/storage/termux-app"

# Gunakan Bash Array untuk dependensi
DEPENDENCIES=(termux-api fish ripgrep which curl wget fzf eza git tree yq fastfetch htop glow)
TEMP_DEPS=(luajit yazi file sops age glow yt-dlp zoxide tur-repo)

# 2. Gunakan satu array berisi path relatif
ITEMS=(
    ".nanorc"
    ".bashrc"
    ".config"
    ".local/bin"
    ".termux/termux.properties"
    ".termux/colors.properties"
)

# update termux & install all dependencies
_setuptermux() {
    echo "Setup storage.."
    termux-setup-storage
    [[ $(whoami) == "u0_a933" ]] && ln -s /storage/7DFC-741D /data/data/com.termux/files/home/storage/SDCARD
    
}

# disable motd
touch ~/.hushlogin

_seteditor() {
    PS3="Pilih editor: "
    fish_config="$HOME/.config/fish/conf.d/var.fish"

    select editor in nvim hx vim nano micro emacs; do
        if [[ -n "$editor" ]]; then
            break
        else
            echo "Pilihan tidak valid."
        fi
    done

    case "$editor" in
        hx)
            pkg install helix helix-grammars -y
            ;;
        nvim)
            pkg install neovim -y
            ;;
        *)
            pkg install "$editor" -y
            ;;
    esac

    mkdir -p "$(dirname "$fish_config")"

    # Hapus konfigurasi lama jika ada
    [[ -f "$fish_config" ]] && sed -i '/^set -gx EDITOR /d; /^set -gx VISUAL /d' "$fish_config"
    
    {
        echo "set -gx EDITOR $editor"
        echo "set -gx VISUAL $editor"
    } >> "$fish_config"
}

create_symlinks() {
    # install dependencies first
    pkg install "${TEMP_DEPS[@]}" -y

    # Clone repositori
    if [[ ! -d "$SRC_DIR/.git" ]]; then
        git clone --single-branch --depth 1 -b config https://github.com/TQ-See/termux.configurations.git "$SRC_DIR"
    fi

    for item in "${ITEMS[@]}"; do
        target_path="$BASE_DIR/$item"
        source_path="$SRC_DIR/$item"

        # Pastikan direktori induk target sudah ada
        mkdir -p "$(dirname "$target_path")"

        # Cek apakah target sudah ada
        if [[ -e "$target_path" || -L "$target_path" ]]; then
            printf "Target '$item' sudah ada.\n"
            read -r -p "Pilih aksi - [s]kip / [b]ackup / [f]orce (default): " choice
            
            case "${choice,,}" in
                s)
                    echo "-> Melewati $item..."
                    continue
                    ;;
                b)
                    echo "-> Membackup ke $target_path.backup"
                    mv "$target_path" "$BASE_DIR/.backup/$item"
                    ;;
                *) 
                    echo "-> Menimpa (force) target lama..."
                    rm -rf "$target_path"
                    ;;
            esac
        fi

        # Eksekusi pembuatan symlink
        ln -s "$source_path" "$target_path"
        echo "-> Berhasil symlink: $item"
        echo "----------------------------------------"
    done
}

# Fungsi Utama (Main)
main() {
    _setuptermux
    sleep 3
    
    pkg update && pkg upgrade -y
    pkg install "${DEPENDENCIES[@]}" -y  
    sleep 2
    
    # Gunakan read -p untuk prompt Yes/No (lebih efisien daripada select)
    while true; do
        read -r -p "Gunakan Template config msalmanrafadhlih? [Y/n]: " option
        option=${option:-Y} # Default to Y if enter is pressed
        
        case "${option,,}" in
            y|yes)
                create_symlinks
                break
                ;;
            n|no)
                echo "Skipping symlinks.."
                break
                ;;
            *)
                echo "Pilihan tidak valid. Jawab Y atau N."
                ;;
        esac
    done
    _seteditor
}

# Jalankan eksekusi
main

echo -e "\nDefault editor diatur ke: $editor"
echo -e "Jalankan perintah ini \nuntuk ganti shell: chsh -s fish"
