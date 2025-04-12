#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import subprocess


# 🔁 Set this to your actual script path
#CUSTOM_SCRIPT_PATH = "/home/sushi/myscripts/myspecialscript.sh"
CUSTOM_SCRIPT_PATH = os.path.expanduser("~/mysh/hotspot.sh")


def get_saved_connections():
    """Get saved Wi-Fi connections (SSID names)."""
    result = subprocess.run(
        ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show"],
        capture_output=True,
        text=True,
    )

    connections = []
    for line in result.stdout.strip().split("\n"):
        if not line:
            continue
        name, conn_type = line.split(":", 1)
        if conn_type == "802-11-wireless":
            connections.append(name.strip())
    return connections


def run_wofi(options_list):
    """Show a Wofi menu with provided options."""
    options = "\n".join(options_list)
    result = subprocess.run(
        ["wofi", "-d", "-i", "-p", "Saved Wi-Fi", "-W", "600", "-H", "400", "-k", "/dev/null"],
        input=options,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def run_custom_script():
    """Run the custom script provided by user."""
    if os.path.isfile(CUSTOM_SCRIPT_PATH) and os.access(CUSTOM_SCRIPT_PATH, os.X_OK):
        subprocess.run([CUSTOM_SCRIPT_PATH])
    else:
        os.system(f"notify-send 'Script not found or not executable: {CUSTOM_SCRIPT_PATH}'")


def connect_to_wifi(connection_name):
    """Connect to a saved Wi-Fi connection."""
    result = subprocess.run(["nmcli", "connection", "up", connection_name], capture_output=True, text=True)
    if result.returncode == 0:
        os.system(f"notify-send 'Connected to {connection_name}'")
    else:
        os.system(f"notify-send 'Failed to connect to {connection_name}:\n{result.stderr}'")


def main():
    connections = get_saved_connections()
    if not connections:
        os.system("notify-send 'No saved Wi-Fi connections found.'")
        return

    menu_options = ["Custom Script"] + connections
    selected = run_wofi(menu_options)

    if not selected:
        return

    if selected == "Custom Script":
        run_custom_script()
    else:
        connect_to_wifi(selected)


if __name__ == "__main__":
    main()

