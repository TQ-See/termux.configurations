from termuxgui import Activity, Button, TextView, LinearLayout

def main():
    # Create an activity (e.g., a main window or dialog)
    activity = Activity(is_dialog=False)

    # Create a layout to organize elements
    layout = LinearLayout(activity)

    # Add a text view
    text_view = TextView(activity, "Hello from Termux:GUI!", parent_id=layout.id)
    text_view.set_text_size(activity, 24)

    # Add a button
    button = Button(activity, "Click Me!", parent_id=layout.id)

    # Event loop to handle interactions
    while True:
        event = activity.get_event()
        if event and event["type"] == "click" and event["id"] == button.id:
            text_view.set_text(activity, "Button Clicked!")

if __name__ == "__main__":
    main()
