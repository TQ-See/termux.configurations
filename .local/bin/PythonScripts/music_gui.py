from termuxgui import GUI
import os

g = GUI()
w = g.window_create(title="Termux Music Player", width=300, height=200)

w.textview(text="🎵 Termux Music Player 🎵").pack()
w.textview(text="Tap tombol di bawah ini untuk mainkan lagu.").pack()

# Tombol play
play_btn = w.button(text="▶️ Play")
play_btn.pack()

# Tombol stop
stop_btn = w.button(text="⏹ Stop")
stop_btn.pack()

def play_music():
    os.system('termux-media-player play "/sdcard/Music/lagu.mp3"')

def stop_music():
    os.system('termux-media-player stop')

play_btn.on_click = play_music
stop_btn.on_click = stop_music

w.show()
input("Tekan Enter untuk keluar...\n")
