#!/data/data/com.termux/files/usr/bin/bash

# === KONFIGURASI ===
MUSIC_DIR="$HOME/storage/shared/Termux-media/Musics"

# === CEK DEPENDENSI ===
for cmd in gum mpv termux-notification; do
    command -v $cmd >/dev/null 2>&1 || {
        echo "$cmd belum terinstall. Jalankan: pkg install $cmd"
        exit 1
    }
done

# === FUNGSI NOTIFIKASI ===
notify() {
    termux-notification --id "mpv" \
        --title "🎵 Now Playing" \
        --content "$1" \
        --priority high \
        --ongoing true
}

notify_info() {
    termux-notification --id "mpv-info" \
        --title "Termux MPV Player" \
        --content "$1" \
        --priority low
}

# === PEMUTARAN LAGU DENGAN NOTIFIKASI ===
play_with_notify() {
    mode="$1"
    pkill -9 mpv >/dev/null 2>&1
    notify_info "Memulai pemutaran musik ($mode mode)..."

    last_title=""

    if [ "$mode" = "shuffle" ]; then
        nohup mpv --no-video --shuffle --loop-playlist=inf \
            --term-playing-msg='${filename}' "$MUSIC_DIR"/*.mp3 |
        while read -r path; do
            title="$(basename "$path")"
            if [ "$title" != "$last_title" ] && [ -n "$title" ]; then
                notify "$title"
                last_title="$title"
            fi
        done >/dev/null 2>&1 &
    else
        nohup mpv --no-video --loop-playlist=inf \
            --term-playing-msg='${filename}' "$MUSIC_DIR"/*.mp3 |
        while read -r path; do
            title="$(basename "$path")"
            if [ "$title" != "$last_title" ] && [ -n "$title" ]; then
                notify "$title"
                last_title="$title"
            fi
        done >/dev/null 2>&1 &
    fi

    gum log -l info "Playback started in background. Kembali ke menu..."
    sleep 1
}

# === PAUSE / RESUME ===
pause_resume() {
    pid=$(pgrep mpv)
    if [ -n "$pid" ]; then
        kill -STOP "$pid"
        notify_info "Playback paused"
        gum confirm "Playback paused. Resume?" && {
            kill -CONT "$pid"
            notify_info "Playback resumed"
        }
    else
        gum log -l error "Tidak ada musik yang sedang diputar."
    fi
}

# === STOP ===
stop_play() {
    pkill -9 mpv >/dev/null 2>&1
    notify_info "Playback stopped"
    gum log -l info "Playback stopped."
    sleep 1
}

# === MENU UTAMA ===
while true; do
    clear
    gum style --border double --margin "1 2" --padding "1 2" --border-foreground cyan "Termux MPV Music Player"
    echo
    CHOICE=$(gum choose "Play All" "Shuffle Play" "Pause/Resume" "Stop" "Exit")
    case "$CHOICE" in
        "Play All") play_with_notify "all" ;;
        "Shuffle Play") play_with_notify "shuffle" ;;
        "Pause/Resume") pause_resume ;;
        "Stop") stop_play ;;
        "Exit") clear; exit 0 ;;
    esac
done
