export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export VISUAL=nvim

# ALIAS
alias fish='exec fish'
alias bashrc='hx ~/.bashrc'

alias ls='eza --icons'
alias ll='eza -a'
alias cleanhome='rm -rf ~/.cache/* $PREFIX/tmp/* ~/.local/share/ 2
>/dev/null; echo "Cache lokal dibersihkan ✅"'
alias tquilla='cat /data/data/com.termux/files/usr/etc/motd'
alias splash='nano /data/data/com.termux/files/usr/etc/motd'
alias cls='clear'
alias properties='nano ~/.termux/termux.properties'
alias fm='export EDITOR=nano; export NNN_OPENER=termux-open; nnn -d
eH -C'
alias updt='pkg update && pkg upgrade -y'
alias yz='yazi'
alias editmyscript='nano ~/.local/bin/myscript'
alias ex='exit'
alias u='pkg uninstall'
alias i='pkg install'
alias editscript='hx ~/.local/bin/myscript'
alias myscript='source ~/.local/bin/myscript'
alias dvideo='yt-dlp --trim-filenames 60 --restrict-filenames -S "res:720,codec,br,fps" -f "bv*+ba/best" -o "~/storage/videos/%(playlist|NA)s/%(title).60s [%(id)s].%(ext)s"'
alias dmusic='yt-dlp --trim-filenames 80 --restrict-filenames -x --audio-format mp3 -S "abr,codec" -o "~/storage/music/%(playlist|NA)s/%(title)s [%(id)s].%(ext)s"'
alias playvideo='mpv --no-config --vo=sixel  --profile=sw-fast --really-quiet --vo-sixel-reqcolors=0 --ao='pulse''
alias play='~/gui/termux-player.sh'
#alias kew='dbus-launch kew'
kew() {
  if ! pgrep -x dbus-daemon >/dev/null; then
    eval "$(dbus-launch --sh-syntax)"
  fi
  command kew "$@"
}
alias GIT='git add . && git commit -m'
alias py='python3'
alias mypkgs='source ~/.local/bin/home-pkgs'
alias syspkgs='source ~/.local/bin/system-pkgs'
alias yatim='apt autoremove --dry-run'
alias globalsrc='apt search'
alias music='kew'
alias termsize='echo "$(tput cols)x$(tput lines)"'
alias shared='yazi ~/storage/shared'
alias bin='mv ~/storage/shared/.store/bin ~/storage/shared/DCIM/bin && echo "successed!"'
alias py-server='echo "python -m http.server <port>" && python -m http.server'
alias ebook='cd ~/storage/shared/Documents/EbookLauncher'
alias scripts='cd ~/storage/shared/Documents/scripts'
alias hai='echo hai'
alias editcbz='lua ~/.local/bin/LuaScripts/editcbz.lua'
alias luascript='cd ~/.local/bin/LuaScripts/'
alias meme='echo hello'
alias repo='cd ~/storage/termux-app'
alias miku='cat ~/.config/fastfetch/ascii/miku'
alias rustlings-start='cd ~/storage/projects/rust-learning/rustlings && rustlings'
alias rust_notes='luajit ~/.local/bin/LuaScripts/rust_notes.lua'
alias rustdoc='termux-open ~/storage/shared/Documents/PDFfiles/Rust_Fundamental.pdf'
alias rustdoc='termux-open ~/storage/shared/Documents/PDFfiles/Rust_Fundamental.pdf'
