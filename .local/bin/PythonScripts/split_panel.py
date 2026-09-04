from textual.app import App, ComposeResult
from textual.containers import Container
from textual.widgets import Static, Input
from textual.reactive import reactive
from textual import events
import subprocess


class MiniTerminal(Static):
    output = reactive("")

    def compose(self) -> ComposeResult:
        yield Static("Mini Terminal", id="title")
        yield Static("", id="display")
        yield Input(placeholder="Ketik perintah...", id="input")

    def on_mount(self):
        self.update_output("Siap menerima perintah...")

    def update_output(self, text: str):
        display = self.query_one("#display", Static)
        display.update(text)

    def on_input_submitted(self, event: Input.Submitted):
        cmd = event.value.strip()
        if cmd:
            try:
                result = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT, text=True)
            except subprocess.CalledProcessError as e:
                result = e.output
            self.update_output(f"$ {cmd}\n{result}")
            event.input.value = ""


class FloatingApp(App):
    CSS = """
    Screen {
        background: #101010;
    }

    #overlay {
        align: center middle;
        background: rgba(0,0,0,0.4);
    }

    #panel {
        border: heavy #00ff88;
        width: 70%;
        height: 50%;
        background: #202020;
        padding: 1;
        color: white;
    }

    #title {
        content-align: center middle;
        color: #00ff88;
        text-style: bold;
    }

    #display {
        height: 1fr;
        overflow-y: auto;
        border: round #404040;
        margin-top: 1;
        padding: 1;
    }

    #input {
        border: round #00ff88;
        margin-top: 1;
        padding: 0 1;
    }
    """

    show_panel = reactive(False)

    def compose(self) -> ComposeResult:
        # Tidak langsung tampil, kita hanya simpan container
        self.panel_container = Container(MiniTerminal(id="mini"), id="panel")
        yield Container(id="overlay")  # lapisan transparan di atas layar

    async def on_key(self, event: events.Key):
        # Toggle F2
        if event.key == "f2":
            self.show_panel = not self.show_panel
            overlay = self.query_one("#overlay", Container)
            overlay.remove_children()
            if self.show_panel:
                overlay.mount(self.panel_container)
            else:
                overlay.remove_children()


if __name__ == "__main__":
    FloatingApp().run()
