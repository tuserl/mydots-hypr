#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import subprocess


def get_wifi_list():
    """Get available Wi-Fi networks and return them as a list."""
    wifi_list = subprocess.run(
        ["nmcli", "-f", "SSID,SIGNAL", "dev", "wifi"],
        capture_output=True,
        text=True,
    ).stdout.split("\n")[1:]

    wifi_networks = []
    for line in wifi_list:
        parts = line.strip().split()
        if parts:
            ssid = " ".join(parts[:-1])  # SSID may contain spaces
            signal = parts[-1] + "%"  # Signal strength
            wifi_networks.append(f"{ssid} ({signal})")

    return wifi_networks


def run_wofi(wifi_networks):
    """Show a Wofi menu with available networks."""
    options = "\n".join(wifi_networks)
    choice = (
        subprocess.run(
            f"echo -e '{options}' | wofi -d -i -p 'Select Wi-Fi' -W 600 -H 400 -k /dev/null",
            shell=True,
            capture_output=True,
            text=True,
        )
        .stdout.strip()
    )

    if choice:
        return choice.split(" (")[0]  # Extract SSID before signal percentage
    return None


def connect_to_wifi(ssid):
    """Connect to the selected Wi-Fi network."""
    if ssid:
        cmd = f"nmcli dev wifi connect '{ssid}'"
        os.system(cmd)
        os.system(f"notify-send 'Connecting to {ssid}...'")


def main():
    wifi_networks = get_wifi_list()
    if not wifi_networks:
        os.system("notify-send 'No Wi-Fi networks found.'")
        return

    selected_ssid = run_wofi(wifi_networks)
    connect_to_wifi(selected_ssid)


if __name__ == "__main__":
    main()

