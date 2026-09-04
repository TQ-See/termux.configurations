from termuxgui import gui_create_window, gui_add_label, gui_add_button, gui_run, gui_stop

# buat window
win = gui_create_window("Halo dari Termux GUI")

# tambahkan label
gui_add_label(win, "Hello world!")

# tambahkan tombol tutup
gui_add_button(win, "Tutup", lambda: gui_stop())

# jalankan
gui_run()
