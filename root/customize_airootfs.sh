#!/bin/bash
# customize_airootfs.sh — Enable system services for live ISO

systemctl enable bluetooth
systemctl enable sddm
systemctl enable NetworkManager
